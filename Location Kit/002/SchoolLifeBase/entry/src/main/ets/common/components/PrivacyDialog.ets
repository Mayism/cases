/**
 * 课程助手 - 隐私协议弹窗
 * 首次启动时展示，用户必须同意后才能使用应用
 * 未同意时阻塞UI交互（HitTestMode.Block）
 */

import { AppStore } from '../common/store/Store';

@CustomDialogV2
export struct PrivacyDialog {
  @Local isLoading: boolean = false;
  onAgree: () => void = () => {};

  private appStore: AppStore = AppStore.getInstance();

  build() {
    Column() {
      // 标题
      Text('隐私协议')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .margin({ bottom: 16 })

      // 协议内容
      Scroll() {
        Column() {
          Text('欢迎使用课程助手！\n\n')
            .fontSize(14)
            .fontColor('#666666')
            .lineHeight(22)

          Text('在使用本应用前，请您仔细阅读并同意以下协议：\n\n')
            .fontSize(14)
            .fontColor('#666666')
            .lineHeight(22)

          Text('1. 《课程助手隐私政策》\n')
            .fontSize(14)
            .fontColor('#ED6F21')
            .lineHeight(22)

          Text('2. 《课程助手用户服务协议》\n\n')
            .fontSize(14)
            .fontColor('#ED6F21')
            .lineHeight(22)

          Text('我们重视您的隐私保护和个人信息保护，在您使用本应用服务之前，请仔细阅读以上协议。\n\n')
            .fontSize(14)
            .fontColor('#666666')
            .lineHeight(22)

          Text('您可以通过同意以下协议来使用本应用。如果您不同意协议内容，将无法使用本应用的服务。')
            .fontSize(14)
            .fontColor('#666666')
            .lineHeight(22)
        }
        .width('100%')
      }
      .layoutWeight(1)
      .width('100%')

      // 按钮区域
      Row() {
        Button('不同意')
          .fontSize(16)
          .fontColor('#666666')
          .backgroundColor('#F5F5F5')
          .borderRadius(24)
          .layoutWeight(1)
          .height(44)
          .enabled(!this.isLoading)
          .onClick(() => {
            // 不同意则不关闭弹窗，用户必须同意才能使用
          })

        Blank().width(16)

        Button('同意并继续')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#ED6F21')
          .borderRadius(24)
          .layoutWeight(1)
          .height(44)
          .enabled(!this.isLoading)
          .onClick(async () => {
            this.isLoading = true;
            await this.appStore.setPrivacyAgreed(true);
            this.isLoading = false;
            this.onAgree();
          })
      }
      .width('100%')
      .margin({ top: 16 })
    }
    .width('100%')
    .padding(24)
  }
}