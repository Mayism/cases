
@ComponentV2
export struct TitleBar {
  @Param title: string = ''
  @Param @Once onBackClick: () => void = () => {}

  build() {
    Row() {
      Row() {
        Image($r('app.media.chevron_left'))
          .width(16)
          .height(16)
          .objectFit(ImageFit.Cover)
      }
      .width(40)
      .height(40)
      .backgroundColor('#E6E8E9')
      .borderRadius(20)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.onBackClick()
      })
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ left: 8 })
    }
    .width('100%')
    .margin({ top: 8, bottom: 8 })
  }
}