/**
 * 课程助手 - 签到按钮组件
 */

@ComponentV2
export struct CheckinButton {
  @Event onCheckinClick: () => void = () => {};

  build() {
    Stack() {
      Row() {
        Column() {
          Text('去签到')
            .fontSize(20)
            .fontWeight(700)
            .fontColor(Color.White)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Stack() {
          Text('\u276F')
            .fontSize(18)
            .fontColor(Color.White)
        }
        .width(40)
        .height(40)
        .borderRadius(20)
        .backgroundColor('rgba(255,255,255,0.3)')
      }
      .width('100%')
      .height('100%')
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height(96)
    .borderRadius(16)
    .linearGradient({
      direction: GradientDirection.Left,
      colors: [['#ED6F21', 0], ['#FFC39F', 1]]
    })
    .onClick(() => {
      this.onCheckinClick();
    })
  }
}