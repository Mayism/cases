@Component
export struct ConfirmButton {
  @Prop text: ResourceStr = '';

  build() {
    Column() {
      Row() {
        Button(this.text) {
          Row() {
            Text(this.text)
              .fontSize($r('sys.float.Body_L'))
              .fontWeight(FontWeight.Medium)
              .fontFamily('HarmonyHeiTi-Medium')
              .fontColor($r('sys.color.ohos_fa_text_contrary'))
              .textAlign(TextAlign.Center)
              .textOverflow({
                overflow: TextOverflow.Ellipsis
              })
              .maxLines(1)
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
        }
        .focusOnTouch(true)
        .type(ButtonType.Normal)
        .borderRadius(20)
        .backgroundColor($r('sys.color.ohos_id_color_floating_button_bg_normal'))
        .constraintSize({
          minWidth: '100%',
          maxWidth: '100%',
          minHeight: 40,
          maxHeight: 40,
        })
        .padding({
          top: 4,
          bottom: 4,
          left: 16,
          right: 16,
        })
        .opacity(1)
        .stateEffect(true)
      }
      .onClick(() => {
        this.getUIContext().getHostContext()?.eventHub.emit('confirmPay', false)
      })
    }.width('100%')
    .alignItems(HorizontalAlign.Center)
  }
}