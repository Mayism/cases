import { UtilLog as Logger } from '@hw-agconnect/util-log';
import { ComponentContent, promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = '[FullLoading]';

export class FullLoading {
  public static isLoading: boolean = false;
  private static _ctx: UIContext;
  private static _contentNode: ComponentContent<Object>;
  private static _options: promptAction.BaseDialogOptions;

  public static init(ctx: UIContext) {
    FullLoading._ctx = ctx;
    FullLoading._contentNode = new ComponentContent(FullLoading._ctx, wrapBuilder(fullLoading));
    FullLoading._options = {
      alignment: DialogAlignment.Center,
      autoCancel: false,
    };
  }

  public static show(doNext?: () => void) {
    if (FullLoading.isLoading) {
      return;
    }
    if (FullLoading._contentNode !== null) {
      FullLoading._ctx.getPromptAction()
        .openCustomDialog(FullLoading._contentNode, FullLoading._options)
        .then(() => {
          FullLoading.isLoading = true;
          doNext?.();
        })
        .catch((error: BusinessError) => {
          Logger.error(TAG, `OpenCustomDialog args error code is ${error.code}, message is ${error.message}`);
        });
    }
  }

  public static hide(doNext?: () => void) {
    if (!FullLoading.isLoading) {
      return;
    }
    if (FullLoading._contentNode !== null && FullLoading.isLoading) {
      FullLoading._ctx.getPromptAction()
        .closeCustomDialog(FullLoading._contentNode)
        .then(() => {
          Logger.info(TAG, 'CloseCustomDialog complete.');
          FullLoading.isLoading = false;
          doNext?.();
        })
        .catch((error: BusinessError) => {
          Logger.error(TAG, `CloseCustomDialog args error code is ${error.code}, message is ${error.message}`);
        });
    }
  }
}

@Builder
export function fullLoading() {
  Stack({ alignContent: Alignment.Center }) {
    Column() {
      LoadingProgress().size({ width: 40, height: 40 }).color($r('sys.color.icon_on_primary'))
    }
    .justifyContent(FlexAlign.Center)
    .width(100)
    .height(100)
    .backgroundColor('#88000000')
    .borderRadius(8)
  }
  .width('100%')
  .height('100%')
  .backgroundColor(Color.Transparent)
}