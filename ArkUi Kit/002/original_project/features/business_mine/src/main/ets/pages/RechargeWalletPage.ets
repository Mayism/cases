import { Constants, NavHeaderBar, RouterUtil, ContextUtils } from 'lib_common';
import { RechargeWalletViewModel } from '../viewmodel/RechargeWalletViewModel';

@Builder
export function RechargeWalletPageBuilder() {
  RechargeWalletPage()
}

@ComponentV2
struct RechargeWalletPage {
  @Local vm: RechargeWalletViewModel = new RechargeWalletViewModel()

  validateInput() {
    if (!this.vm.serialNumber) {
      ContextUtils.showToast({ message: '序列号不能为空' });
      return false;
    }
    if (!this.vm.key) {
      ContextUtils.showToast({ message: '密钥不能为空' });
      return false;
    }
    return true;
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: '电子钱包充值' })
      Column() {
        Column({ space: 12 }) {
          Text('输入序列号').fontSize($r('sys.float.Body_L')).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
          TextInput({ text: $$this.vm.serialNumber, placeholder: '请输入序列号' })
            .placeholderFont({ size: $r('sys.float.Body_L') })
            .placeholderColor($r('sys.color.font_secondary'))
            .textAlign(TextAlign.Start)
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_primary'))
            .textAlign(TextAlign.Center)
            .type(InputType.Number)
          Text('录入刮刮卡涂层下的密钥')
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
          TextInput({ text: $$this.vm.key, placeholder: '请输入充值密钥' })
            .placeholderFont({ size: $r('sys.float.Body_L') })
            .placeholderColor($r('sys.color.font_secondary'))
            .textAlign(TextAlign.Start)
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_primary'))
            .textAlign(TextAlign.Center)
        }.width(Constants.FULL_SIZE).alignItems(HorizontalAlign.Start)

        Button('立即充值')
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_on_primary'))
          .width(Constants.FULL_SIZE)
          .height(40)
          .backgroundColor($r('app.color.app_theme'))
          .margin({ top: 24, left: 12, right: 12 })
          .onClick(() => {
            const isValid = this.validateInput();
            if (isValid) {
              RouterUtil.pop(1);
            }
          })
      }
      .width(Constants.FULL_SIZE)
      .layoutWeight(1)
      .constraintSize({ maxWidth: Constants.FULL_SIZE })
      .margin({
        top: 12,
        left: Constants.BORDER_WIDTH,
        right: Constants.BORDER_WIDTH,
        bottom: this.vm.windowModel.getWindowBottomHeight(),
      })
    }
    .hideTitleBar(true)
  }
}
