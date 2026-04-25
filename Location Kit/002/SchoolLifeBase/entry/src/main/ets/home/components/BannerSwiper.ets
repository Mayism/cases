/**
 * 课程助手 - 轮播Banner组件
 */

@ComponentV2
export struct BannerSwiper {
  @Local currentIndex: number = 0;

  build() {
    Swiper() {
      ForEach(['校园生活 精彩每一天', '课程助手 助你学习', '签到打卡 从不缺席'], (item: string, index: number) => {
        Stack() {
          Column() {
            Text(item)
              .fontSize(16)
              .fontColor(Color.White)
              .fontWeight(700)
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.End)
          .alignItems(HorizontalAlign.Start)
          .padding({ left: 16, bottom: 16 })
        }
        .width('100%')
        .height('100%')
        .borderRadius(16)
        .backgroundColor(index === 0 ? '#FF9A56' : index === 1 ? '#4ECDC4' : '#45B7D1')
      }, (item: string) => item)
    }
    .autoPlay(true)
    .interval(3000)
    .indicator(new DotIndicator()
      .itemWidth(6)
      .itemHeight(6)
      .selectedItemWidth(16)
      .selectedItemHeight(6)
      .color('#80FFFFFF')
      .selectedColor(Color.White))
    .onChange((index: number) => {
      this.currentIndex = index;
    })
    .width('100%')
    .aspectRatio(2.1)
    .borderRadius(16)
  }
}