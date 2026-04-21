import { CommonConstants } from 'commonlib';

@ComponentV2
export struct NewsCard {
  @Param newsTitle: string | Resource = '';
  @Param newsContent: string | Resource = '';
  @Param newsTime: string | Resource = '';
  @Param newsImage: string | Resource = '';
  @Param changeFontSize: number = 0

  build() {
    Row() {
      Column() {
        Row() {
          Image($r('app.media.new'))
            .width(40)
            .height(16)
            .objectFit(ImageFit.ScaleDown)
          Text(this.newsTitle)
            .fontSize(`${16 + this.changeFontSize}`)
            .fontColor($r('app.color.news_title_fontColor'))
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontWeight(500)
        }
        .alignItems(VerticalAlign.Center)
        .height(20)
        .width(CommonConstants.FULL_PERCENT)
        .margin({ top: 2 })
        Row() {
          Text(this.newsContent)
            .fontSize(`${14 + this.changeFontSize}`)
            .lineHeight(`${18 + this.changeFontSize}`)
            .fontColor($r('app.color.news_content_fontColor'))
            .width(CommonConstants.FULL_PERCENT)
            .maxLines(1)
            .margin({ top: 10 })
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .layoutWeight(1)
        .alignItems(VerticalAlign.Top)

        Row() {
          Text('xx新闻')
            .fontSize(`${10 + this.changeFontSize}`)
            .fontWeight('regular')
            .fontFamily('鸿蒙黑体')
            .fontColor($r('app.color.news_time_fontColor'))
            .margin({bottom: 6})

          Text(this.newsTime)
            .fontSize(`${10 + this.changeFontSize}`)
            .fontWeight('regular')
            .fontFamily('鸿蒙黑体')
            .fontColor($r('app.color.news_time_fontColor'))
            .margin({bottom: 6, left: 8})
        }
        .margin({top:`${2 * this.changeFontSize}`})
      }
      .margin({ right: 12 })
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      if (this.newsImage) {
        Image($rawfile(`${this.newsImage}`))
          .height(100)
          .width(100)
          .borderRadius(8)
          .margin({
            top: 12,
            bottom: 12
          })
      }
    }
    .padding({
      left: 12,
      right: 12
    })
    .height(`${100 + 2 * this.changeFontSize}`)
  }
}