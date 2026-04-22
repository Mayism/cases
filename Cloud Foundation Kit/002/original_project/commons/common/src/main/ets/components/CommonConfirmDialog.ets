import { Constants, RouterMap } from '../constants/Common';
import { ConfirmDialogOption } from '../models/RouterModel';
import { RouterModule } from '../utils/RouterModule';

@Builder
export function commonConfirmDialogBuilder() {
  CommonConfirmDialog();
}

@ComponentV2
export struct CommonConfirmDialog {
  @Local dialogOption: ConfirmDialogOption = {
    title: '',
    message: '',
  };

  hide() {
    RouterModule.pop();
  }

  confirm() {
    RouterModule.pop({ 'param': true } as Record<string, boolean>);
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Center }) {
        Column() {
          Text(this.dialogOption.title)
            .fontColor($r('sys.color.font_primary'))
            .fontSize($r('sys.float.Title_S'))
            .fontWeight(FontWeight.Medium)
            .height(56)
          Text(this.dialogOption.message)
            .fontColor($r('sys.color.font_primary'))
            .fontSize($r('sys.float.Body_M'))
          Row({ space: 16 }) {
            Text('取消')
              .fontSize($r('sys.float.Body_L'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_emphasize'))
              .width(120)
              .height(40)
              .textAlign(TextAlign.Center)
              .onClick(() => {
                this.hide();
              });
            Text('确定')
              .fontSize($r('sys.float.Body_L'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_emphasize'))
              .width(120)
              .height(40)
              .textAlign(TextAlign.Center)
              .onClick(() => {
                this.confirm();
              });
          }
          .width(Constants.FULL_SIZE)
          .padding({ left: 12, right: 12 })
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width(Constants.FULL_SIZE)
        .backgroundColor($r('sys.color.background_primary'))
        .padding({ left: 24, right: 24, bottom: 16 })
        .margin({ left: 16, right: 16 })
        .constraintSize({ maxWidth: Constants.FULL_SIZE })
        .borderRadius(32)
      }
      .width(Constants.FULL_SIZE)
      .height(Constants.FULL_SIZE);
    }
    .mode(NavDestinationMode.DIALOG)
    .transition(TransitionEffect.OPACITY.animation({ duration: 200 }))
    .onReady(() => {
      const param = RouterModule.getNavParam<ConfirmDialogOption>(RouterMap.CONFIRM_DIALOG);
      if (param) {
        this.dialogOption = param;
      }
    })
    .onBackPressed(() => {
      return false;
    })
    .backgroundColor('rgba(0, 0, 0, 0.3)')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .hideTitleBar(true);
  }
}