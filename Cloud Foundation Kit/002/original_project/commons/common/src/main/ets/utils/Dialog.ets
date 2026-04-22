import { ComponentContent, promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { Constants, RouterMap } from '../constants/Common';
import { UtilLog as Logger } from '@hw-agconnect/util-log';
import { RouterModule } from './RouterModule';

const TAG = '[Dialog]';

export class Dialog {
  private static _ctx: UIContext;
  private static _contentNode: ComponentContent<Object>;
  private static _options: promptAction.BaseDialogOptions;
  private static _hasInit: boolean;

  public static init(ctx: UIContext) {
    if (Dialog._hasInit) {
      return;
    }
    Dialog._ctx = ctx;
    Dialog._contentNode = new ComponentContent(Dialog._ctx, wrapBuilder(dialogView));
    Dialog._options = {
      alignment: DialogAlignment.Center,
      transition: TransitionEffect.OPACITY,
      autoCancel: false,
    };
    Dialog._hasInit = true;
  }

  public static open() {
    if (Dialog._contentNode !== null) {
      Dialog._ctx.getPromptAction()
        .openCustomDialog(Dialog._contentNode, Dialog._options)
        .then(() => {
          Logger.info(TAG, 'OpenCustomDialog complete.');
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          Logger.error(TAG, `OpenCustomDialog args error code is ${code}, message is ${message}`);
        });
    }
  }

  public static close() {
    if (Dialog._contentNode !== null) {
      Dialog._ctx.getPromptAction()
        .closeCustomDialog(Dialog._contentNode)
        .then(() => {
          Logger.info(TAG, 'CloseCustomDialog complete.');
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          Logger.error(TAG, `CloseCustomDialog args error code is ${code}, message is ${message}`);
        });
    }
  }
}

@Builder
export function dialogView() {
  Column() {
    Column() {
      Row({ space: 8 }) {
        Text('店铺未发起排队').fontColor($r('sys.color.font_primary')).titleStyle()
        Text('无需排号').fontColor($r('app.color.brand_red')).titleStyle()
      }

      Text('您可以直接到店就餐~~').fontColor($r('sys.color.font_primary')).normalStyle().margin({ top: 8, bottom: 8 })

      Row({ space: 8 }) {
        Text('我知道了')
          .btnStyle()
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_primary'))
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => {
            Dialog.close();
          })

        Text('去订座')
          .btnStyle()
          .fontSize($r('sys.float.Body_L'))
          .backgroundColor($r('app.color.brand_red'))
          .fontColor($r('app.color.system_color_background_white'))
          .onClick(() => {
            Dialog.close();
            RouterModule.push(RouterMap.BOOK_PAGE);
          })
      }.margin({ top: 8 })
    }
    .alignItems(HorizontalAlign.Start)
    .height(144)
    .width('calc(100% - 32vp)')
    .backgroundColor($r('app.color.system_color_background_white'))
    .borderRadius(32)
    .padding({
      left: 16,
      right: 16,
      top: 24,
      bottom: 16,
    })
  }
  .padding({ top: 250 })
  .width(Constants.FULL_SIZE)
  .height(Constants.FULL_SIZE)
  .backgroundColor($r('sys.color.mask_fourth'))
}

@Extend(Text)
function titleStyle() {
  .fontSize($r('sys.float.Title_S'))
  .fontWeight(FontWeight.Bold)
}
@Extend(Text)
function normalStyle() {
  .fontSize($r('sys.float.Body_L'))
  .fontWeight(FontWeight.Medium)
}

@Extend(Text)
function btnStyle() {
  .height(40)
  .borderRadius(20)
  .layoutWeight(1)
  .textAlign(TextAlign.Center)
  .fontWeight(FontWeight.Medium)
}