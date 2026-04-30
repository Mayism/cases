import { Constants, NavHeaderBar, RouterMap, RouterUtil } from 'lib_common';
import { SettingPageViewModel } from '../viewmodel/SettingPageViewModel';

@Builder
export function SettingPageBuilder() {
  SettingPage()
}

@ComponentV2
struct SettingPage {
  @Local vm: SettingPageViewModel = new SettingPageViewModel()

  @Styles
  cardStyle(){
    .width(Constants.FULL_SIZE)
    .borderRadius(16)
    .padding(12)
    .backgroundColor($r('sys.color.background_primary'))
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: $r('app.string.setting') })
      Column({ space: 12 }) {
        Row() {
          Row() {
            Text($r('app.string.personal_info'))
              .fontSize(16)
              .fontColor($r('sys.color.font_primary'))
              .margin({ left: 6 })
          }
          .padding({
            left: 6,
            right: 6,
            top: 8,
            bottom: 8,
          })

          Image($r('app.media.ic_right')).width(16).fillColor('#999999')
        }
        .cardStyle()
        .justifyContent(FlexAlign.SpaceBetween)
        .onClick(() => {
          if (this.vm.userInfo.isRelative) {
            RouterUtil.pushPathByName(RouterMap.USER_INFO_PAGE)
          } else {
            this.getUIContext().getPromptAction().showToast({ message: $r('app.string.no_relative_account_msg') });
          }
        })

        Row() {
          Row() {
            Text($r('app.string.privacy')).fontSize(16).fontColor($r('sys.color.font_primary')).margin({ left: 6 })
          }
          .padding({
            left: 6,
            right: 6,
            top: 8,
            bottom: 8,
          })

          Image($r('app.media.ic_right')).width(16).fillColor('#999999')
        }
        .cardStyle()
        .justifyContent(FlexAlign.SpaceBetween)
        .onClick(() => {
          RouterUtil.pushPathByName(RouterMap.PRIVACY_PAGE)
        })

        Row() {
          Row() {
            Text($r('app.string.clear_cache')).fontSize(16).fontColor($r('sys.color.font_primary')).margin({ left: 6 })
          }
          .padding({
            left: 6,
            right: 6,
            top: 8,
            bottom: 8,
          })

          Row() {
            Image($r('app.media.ic_right')).width(16).fillColor('#999999')
          }
        }
        .cardStyle()
        .justifyContent(FlexAlign.SpaceBetween)
        .onClick(() => {
          this.vm.clearCache(this.getUIContext());
        })
      }
      .width(Constants.FULL_SIZE)
      .padding({
        top: 12,
        left: Constants.BORDER_WIDTH,
        right: Constants.BORDER_WIDTH,
        bottom: this.vm.windowModel.getWindowBottomHeight(),
      })

    }.hideTitleBar(true).backgroundColor($r('sys.color.background_secondary'))
  }
}
