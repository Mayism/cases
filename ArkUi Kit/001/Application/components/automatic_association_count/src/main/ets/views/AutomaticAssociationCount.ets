import { AvatarFunctionButton } from '../components/AvatarFunctionButton';
import { UserInfo } from '../model/UserInfo';
import { AccountUtils } from '../utils/AccountUtils';
import { commonToast } from '../utils/Toast';

@ComponentV2
export struct AutomaticAssociationCount {
  @Param isLogin: boolean = false
  @Require @Param userInfo: UserInfo
  @Event $isLogin: (isLogin: boolean) => void
  @Event $userInfo: (userInfo: UserInfo) => void
  @Event onLogin: (code: string) => void
  @Event onLoginOut: () => void

  build() {
    Row() {
      Row() {
        if (!this.isLogin) {
          Image(
            $r('app.media.avatar_grey'))
            .width($r('app.float.mine_avatar_width'))
            .height($r('app.float.mine_avatar_width'))
            .borderRadius($r('sys.float.corner_radius_level10'))
            .margin({ right: $r('app.float.mine_avatar_margin_right') })
            .syncLoad(false)
            .objectFit(ImageFit.Fill);
        } else {
          Column() {
            // 声明FunctionalButton
            AvatarFunctionButton({
              avatarSize: 60,
              isLogin: this.isLogin,
              userInfo: this.userInfo,
            })
          }
        }
        if (this.isLogin) {
          Column({ space: 10 }) {
            Text(this.userInfo.userName || '华为用户')
              .fontSize($r('sys.float.Subtitle_L'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
            Row({ space: 5 }) {
              Image($r('app.media.mobile_phone'))
                .width($r('app.float.mine_phone_width'))
                .height($r('app.float.mine_phone_height'))
              Text(this.userInfo.phoneNumber.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2'))
                .fontSize($r('sys.float.Body_M'))
                .fontWeight(FontWeight.Regular)
                .fontColor($r('sys.color.font_secondary'))
            }
          }.width('30%').alignItems(HorizontalAlign.Start)
        }
        if (!this.isLogin) {
          Text('未关联')
            .fontSize($r('sys.float.Subtitle_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_secondary'))
        }
      };

      Row({ space: 5 }) {
        Image($r('app.media.link')).width($r('app.float.mine_link_width')).height($r('app.float.mine_link_height'))
        Text(this.isLogin ? '解除关联' : '关联账号')
          .fontColor(this.isLogin ? $r('sys.color.font_on_primary') : $r('sys.color.font_emphasize'))
          .fontSize($r('sys.float.Caption_M'))
          .fontWeight(FontWeight.Regular)
      }
      .backgroundColor(this.isLogin ? $r('sys.color.comp_background_emphasize') :
      $r('sys.color.comp_background_tertiary'))
      .borderRadius(16)
      .padding($r('app.float.mine_link_padding'))
      .onClick(() => {
        if (this.isLogin) {
          commonToast.show({
            type: 'dialog',
            hasTitle: '账号解除关联',
            message: '请确认是否解除账号关联',
            confirmAction: () => {
              AccountUtils.cancelRelative(getContext(this), (state: string) => {
                if (state === 'succeeded') {
                  this.$isLogin(false)
                  this.$userInfo(new UserInfo())
                }
                if (state === 'err') {
                  this.onLoginOut()
                }
              })
              commonToast.hide()
            },
          })
          return
        }
        AccountUtils.getQuickLoginAnonymousPhone(getContext(this), (code: string) => {
          this.onLogin(code)
        })
      })
    }
    .width('100%')
    .margin({ top: $r('app.float.mine_link_margin_top') })
    .padding({ left: 8, right: $r('app.float.mine_link_padding_right') })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}
