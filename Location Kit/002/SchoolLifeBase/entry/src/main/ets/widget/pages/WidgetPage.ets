/**
 * 课程助手 - 服务卡片 (1x2)
 * 提供首页入口和打卡入口
 */

@Entry
@ComponentV2
struct WidgetPage {
  @Local title: string = '课程助手';

  build() {
    Row() {
      // 首页入口
      Column() {
        Text('\uD83C\uDFE0')
          .fontSize(24)
          .fontColor('#ED6F21')
        Text('首页')
          .fontSize(12)
          .fontColor('#1A1A1A')
          .fontWeight(500)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .height('100%')
      .onClick(() => {
        postCardAction(this, {
          action: 'router',
          abilityName: 'EntryAbility',
          params: {
            intentTask: 'GO_TO_HOME_PAGE'
          }
        });
      })

      // 分隔线
      Divider()
        .vertical(true)
        .height(40)
        .color('#E8EAED')
        .strokeWidth(1)

      // 打卡入口
      Column() {
        Text('\uD83D\uDCCD')
          .fontSize(24)
          .fontColor('#ED6F21')
        Text('打卡')
          .fontSize(12)
          .fontColor('#1A1A1A')
          .fontWeight(500)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .height('100%')
      .onClick(() => {
        postCardAction(this, {
          action: 'router',
          abilityName: 'EntryAbility',
          params: {
            intentTask: 'GO_TO_CHECKIN_PAGE'
          }
        });
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .padding({ left: 8, right: 8 })
  }
}