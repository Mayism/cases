import { Constants } from '../constants/Common'

@ComponentV2
export struct EmptyComp {
  @Param text:ResourceStr = '暂无数据'
  @Param image:ResourceStr = $r('app.media.empty_data')
  build() {
    Column() {
      Image(this.image).width(160)
      Text(this.text).fontSize(12).fontColor($r('sys.color.font_secondary')).margin({ top: 12 })
    }.width(Constants.FULL_SIZE)
  }
}