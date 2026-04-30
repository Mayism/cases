import { NavHeaderBar, PaymentRouter, RouterMap, RouterUtil, ContextUtils } from 'lib_common';
import { UILicensePlate } from 'module_keyboard';

@Builder
export function FindCarPageBuilder() {
  FindCarPage()
}

@ComponentV2
struct FindCarPage {
  @Local plate: string = '';
  @Local controller: TextInputController = new TextInputController();

  build() {
    NavDestination() {
      NavHeaderBar({ title: '找车服务', hasBgColor: false })
      Column() {
        Text('xxx商场')
          .fontSize($r('sys.float.Subtitle_S'))
          .fontColor($r('sys.color.font_secondary'))
          .margin({ top: 12 })
        Text('查找您的爱车').fontSize($r('sys.float.Title_S')).fontWeight(FontWeight.Medium).margin({ top: 4 })
        Image($r('app.media.find_car')).width(144).margin({ top: 24 })
        Row() {
          UILicensePlate({
            controller: this.controller,
            //是否默认激活键盘，选中输入框
            plateNumber: this.plate,
            //是否默认激活键盘，选中输入框
            intFocus: false,
            //输入完整车牌后触发回调，获取车牌号
            onChange: (res: string[]) => {
              this.plate = res.join('')
            },
          })
        }.margin({ top: 24 })

        Button('查找')
          .width('100%')
          .backgroundColor($r('app.color.app_theme'))
          .fontColor($r('sys.color.font_on_primary'))
          .fontSize($r('sys.float.Body_L'))
          .height(40)
          .margin({ top: 12 })
          .onClick(() => {
            if (!this.plate || this.plate.length < 7) {
              ContextUtils.showToast({ message: '请输入完整的车牌' });
              return;
            }
            this.controller.stopEditing();
            RouterUtil.pushPathByName(RouterMap.FIND_CAR_RESULT_PAGE, { plate: this.plate } as PaymentRouter);
          })

      }
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
    .hideTitleBar(true)
  }
}