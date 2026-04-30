import { preferences } from '@kit.ArkData';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { formBindingData, formProvider } from '@kit.FormKit';
import { Logger } from 'lib_common';
import { CardManager } from 'module_points';

const TAG = '[WidgetUtil]';

export class WidgetUtil {
  private static readonly _fileName: string = 'shopping_mall_form_id_file';
  private static readonly _formIdKey: string = 'shopping_mall_form_id_key';
  private static readonly _formIdEventName: string = 'form_id_event_name';
  private static readonly _formClickEventName: string = 'form_click_event_name';

  public static getFormIds(ctx: Context) {
    const store = WidgetUtil._getStore(ctx);
    if (!store) {
      return [];
    }
    try {
      return store.getSync(WidgetUtil._formIdKey, []) as string[];
    } catch (e) {
      Logger.error(TAG, `getSync fail. Code: ${e.code}, message: ${e.message}`);
      return [];
    }
  }

  public static async addFormId(formId: string, cxt: Context) {
    const list = WidgetUtil.getFormIds(cxt);
    try {
      if (!list.some((id) => id === formId)) {
        list.push(formId);
        const store = WidgetUtil._getStore(cxt);
        if (store) {
          store.putSync(WidgetUtil._formIdKey, list);
          await store.flush();
        }
      }
    } catch (e) {
      Logger.error(TAG, `addFormId fail. Code: ${e.code}, message: ${e.message}`);
    }
  }

  public static async delFormId(formId: string, cxt: Context) {
    const list = WidgetUtil.getFormIds(cxt);
    try {
      const index = list.findIndex((id) => id === formId);
      if (index !== -1) {
        list.splice(index, 1);
        const store = WidgetUtil._getStore(cxt);
        if (store) {
          store.putSync(WidgetUtil._formIdKey, list);
          await store.flush();
        }
      }
    } catch (e) {
      Logger.error(TAG, `delFormId fail. Code: ${e.code}, message: ${e.message}`);
    }
  }

  // 发布公共事件跨进程传递卡片id
  public static publishFormId(formId: string, isDelete: boolean) {
    try {
      commonEventManager.publish(
        WidgetUtil._formIdEventName,
        { data: formId, parameters: { isDelete } },
        (err: BusinessError) => {
          if (err) {
            Logger.error(
              TAG,
              `Failed to publish form_id_event_name. Code is ${err.code}, message is ${err.message}`,
            );
          } else {
            Logger.info(TAG, 'Succeeded in publishing form_id_event_name.');
          }
        },
      );
    } catch (e) {
      Logger.error(TAG, `publishFormId fail. Code: ${e.code}, message: ${e.message}`);
    }
  }

  // 订阅获取卡片id
  public static async subscribeFormId(ctx: Context) {
    let subscriber: commonEventManager.CommonEventSubscriber | undefined =
      undefined;
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [WidgetUtil._formIdEventName],
      publisherPermission: '',
    };
    try {
      commonEventManager.createSubscriber(subscribeInfo, (err1, data1) => {
        if (data1) {
          subscriber = data1;
          commonEventManager.subscribe(subscriber, async (err2, data2) => {
            if (data2) {
              if (data2.parameters?.isDelete) {
                WidgetUtil.delFormId(data2.data as string, ctx);
              } else {
                WidgetUtil.addFormId(data2.data as string, ctx);
                WidgetUtil.updateWidgetsWhenChange(ctx);
              }
              Logger.info(TAG, 'Succeeded in creating subscribeFormId.');
            }
          });
        }
      });
    } catch (e) {
      Logger.error(TAG, `subscribeFormId fail. Code: ${e.code}, message: ${e.message}`);
    }
  }

  public static async updateWidgetsWhenChange(ctx: Context) {
    WidgetUtil.getFormIds(ctx).forEach((id) => {
      const formData = CardManager.get().getCardData();
      formProvider.updateForm(
        id,
        formBindingData.createFormBindingData(formData),
      ).catch((e: BusinessError) => {
        Logger.error(TAG, `updateForm fail. Code: ${e.code}, message: ${e.message}`);
      });
    });
  }

  // 发布卡片按钮点击事件
  public static publishFormClick(formId: string) {
    try {
      commonEventManager.publish(
        WidgetUtil._formClickEventName,
        { data: formId },
        (err: BusinessError) => {
          if (err) {
            Logger.error(
              TAG,
              `Failed to publish form_click_event_name. Code is ${err.code}, message is ${err.message}`,
            );
          } else {
            Logger.info(TAG, 'Succeeded in publishing form_click_event_name.');
          }
        },
      );
    } catch (e) {
      Logger.error(TAG, `publishFormClick fail. Code: ${e.code}, message: ${e.message}`);
    }
  }

  // 订阅卡片按钮点击事件
  public static async subscribeFormClick() {
    let subscriber: commonEventManager.CommonEventSubscriber | undefined =
      undefined;
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [WidgetUtil._formClickEventName],
      publisherPermission: '',
    };
    try {
      commonEventManager.createSubscriber(subscribeInfo, (err1, data1) => {
        if (data1) {
          subscriber = data1;
          commonEventManager.subscribe(subscriber, async (err2, data2) => {
            if (data2) {
              Logger.info(TAG, 'Succeeded in creating subscribeFormClick.');
              const formData = CardManager.get().getCardData(true);
              formProvider.updateForm(
                data2.data,
                formBindingData.createFormBindingData(formData),
              ).catch((e: BusinessError) => {
                Logger.error(TAG, `updateForm fail. Code: ${e.code}, message: ${e.message}`);
              });
            }
          });
        }
      });
    } catch (e) {
      Logger.error(TAG, `subscribeFormClick fail. Code: ${e.code}, message: ${e.message}`);
    }
  }

  private static _getStore(ctx: Context): preferences.Preferences | undefined {
    try {
      return preferences.getPreferencesSync(ctx, { name: WidgetUtil._fileName });
    } catch (e) {
      Logger.error(TAG, `getPreferencesSync fail. Code: ${e.code}, message: ${e.message}`);
      return undefined;
    }
  }
}
