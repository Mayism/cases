import { Amount } from './Amount';

@Component
export struct PaymentOrderComp {
  @Prop mercShortName: ResourceStr = '';
  @Prop paymentAmount: string = '';

  build() {
    Column() {
      Text(this.mercShortName)
        .fontFamily('HarmonyHeiTi')
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Normal)

      Amount({
        amount: this.paymentAmount,
      }).margin({ top: 2 })
    }
  }
}