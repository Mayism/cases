import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { UtilLog as Logger } from '@hw-agconnect/util-log';
import { abilityAccessCtrl, bundleManager, Context, PermissionRequestResult, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { calendarManager } from '@kit.CalendarKit';
import { BookOrderDetail } from 'network';
import { OrderUtil } from 'network/src/main/ets/utils/OrderUtil';
import { formatTimeStrToDate } from './Utils';
import { WindowUtil } from './WindowUtil';

const TAG = '[CalenderUtil]';

export class CalenderUtil {
  private static _calendar: calendarManager.Calendar | undefined = undefined;
  private static ctx: Context;

  public static async init(ctx: Context) {
    CalenderUtil.ctx = ctx || WindowUtil.globalContext;
  }

  public static addCalenderEvent(order: BookOrderDetail): Promise<boolean> {
    return new Promise(async (resolve) => {
      const hasPermission = await CalenderUtil._requestCalendarPermissions(CalenderUtil.ctx);
      if (!hasPermission) {
        Logger.error(TAG, 'Get Calender Permission error.');
        resolve(false);
        return;
      }
      CalenderUtil._calendar = await calendarManager.getCalendarManager(CalenderUtil.ctx).getCalendar();
      if (OrderUtil.checkHasSchedule(order.orderId)) {
        promptAction.showToast({ message: '已添加至日程' });
        resolve(false);
        return;
      }
      const date: Date = formatTimeStrToDate(order.time);
      const event: calendarManager.Event = {
        title: `订座-${order.store.name}`,
        location: { location: order.store.address },
        type: calendarManager.EventType.NORMAL,
        startTime: date.getTime(),
        endTime: date.getTime() + 60 * 60 * 1000,
        reminderTime: [30],
      };

      CalenderUtil._calendar?.addEvent(event).then((data: number) => {
        Logger.info(TAG, `Succeeded in adding event, id -> ${data}`);
        promptAction.showToast({ message: '订座日程添加成功' });
        OrderUtil.updateSchedule(order.orderId);
        Logger.info(TAG, data.toString());
        resolve(true);
      }).catch((err: BusinessError) => {
        promptAction.showToast({ message: '订座日程添加失败' });
        Logger.error(TAG, `Failed to addEvent. Code: ${err.code}, message: ${err.message}`);
        resolve(false)
      });
    })
  }

  private static async _requestCalendarPermissions(context: Context): Promise<boolean> {
    try {
      const accessCtrlManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      const accessTokenId: number = await CalenderUtil._getAccessTokenId();
      const permissions: Permissions[] = ['ohos.permission.READ_CALENDAR', 'ohos.permission.WRITE_CALENDAR'];
      for (let permission of permissions) {
        if (
          accessCtrlManager.checkAccessTokenSync(accessTokenId, permission) ===
          abilityAccessCtrl.GrantStatus.PERMISSION_DENIED
        ) {
          const result: PermissionRequestResult =
            await accessCtrlManager.requestPermissionsFromUser(context, permissions);
          return result.authResults.every((auth) => auth === 0);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }


  private static async _getAccessTokenId(): Promise<number> {
    try {
      let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION,
      );
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      return appInfo.accessTokenId;
    } catch (e) {
      Logger.error(TAG, `Failed to _getAccessTokenId. e: ${e}`);
      return Promise.reject(e)
    }
  }
}