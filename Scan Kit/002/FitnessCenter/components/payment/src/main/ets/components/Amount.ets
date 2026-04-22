const FONT_FAMILY_HEITI = 'HarmonyHeiTi';

@Component
export struct Amount {
  @Prop amount: string = '';
  private currency: string = '¥';
  private color: ResourceStr = $r('sys.color.ohos_id_color_text_primary');

  build() {
    Row() {
      Text() {
        Span(this.currency)
          .fontSize(24)
          .fontFamily(FONT_FAMILY_HEITI)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.color)
          .alignSelf(ItemAlign.Baseline)
        Span(this.amount)
          .fontSize(36)
          .fontFamily(FONT_FAMILY_HEITI)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.color)
      }
    }.justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Bottom)
  }
}