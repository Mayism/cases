import { MockService } from 'external_interactions';
import { LengthMetrics } from '@ohos.arkui.node';
import { PaymentType } from '../data/PaymentType';
import { getBorderRadius } from '../util/PaymentUtil';

export enum ButtonOpacity {
  // Default Opacity
  PRIMARY = 1,
  // Button opacity is set to gray
  DISABLED = 0.6,
  // Opacity of payment methods
  PAYMENT_UNAVAILABLE = 0.38
}

@Component
export struct PaymentItemComp {
  @Prop paymentType: PaymentType;
  @Prop canChecked: boolean = false;
  @Prop isChecked?: boolean = false;
  onSelect: () => void = () => {
  };

  build() {
    Row() {
      Image($r('app.media.other_pay'))
        .borderRadius(getBorderRadius(24))
        .width(24)
        .height(24)
        .margin({ end: LengthMetrics.vp(16) })

      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center }) {
        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.Start,
          alignItems: ItemAlign.Start,
        }) {
          Text(this.paymentType?.payTypeDesc)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi-Medium')
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
          if (this.paymentType.payTypeDesc === '余额支付') {
            Text(MockService.account.balance.toString())
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontFamily('HarmonyHeiTi-Medium')
              .fontColor($r('sys.color.font_secondary'))
          }
        }
        .padding({
          top: (this.paymentType?.paymentTypeTip) ? 4 : 0,
        })

        if (this.paymentType?.paymentTypeTip) {
          Row() {
            Text(this.paymentType?.paymentTypeTip)
              .fontSize($r('sys.float.ohos_id_text_size_body3'))
              .fontColor($r('sys.color.comp_focused_secondary'))
              .fontFamily('HarmonyHeiTi')
              .fontWeight(FontWeight.Normal)
              .width('90%')
              .padding({ top: 4, bottom: 4 })
          }
        }
      }
      .layoutWeight(1)

      if (this.canChecked) {
        Radio({ value: this.paymentType?.payTypeSerialNo as string, group: 'aggrPaymentRadioGroup' })
          .visibility(this.isChecked ? Visibility.Visible : Visibility.Hidden)
          .checked(this.isChecked)
          .height(20)
          .width(20)
          .margin(2)
      } else {
        Image($r('app.media.arrow_right'))
          .width(12)
          .height(24)
          .fillColor($r('sys.color.ohos_id_color_fourth'))
          .visibility(this.paymentType?.isAvailable ? Visibility.Visible : Visibility.None)
      }
    }
    .padding({
      top: 12,
      bottom: 12,
    })
    .opacity(this.paymentType?.isAvailable ? ButtonOpacity.PRIMARY : ButtonOpacity.PAYMENT_UNAVAILABLE)
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      if (!this.paymentType?.isAvailable) {
        return;
      }
      this.onSelect();
    })
  }
}
