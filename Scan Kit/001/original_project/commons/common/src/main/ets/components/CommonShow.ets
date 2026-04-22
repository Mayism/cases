import { Constants } from '../constants/Common';

@ComponentV2
export struct CommonShow {
  @Param title: string = '';

  build() {
    Row(){
      Column({ space: 8 }) {
        Text(this.title)
          .padding({ left: 12 })
          .fontSize($r('sys.float.Title_S'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.font_on_primary'))
        Text('您的餐位由门店安排！')
          .padding({ left: 12 })
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.font_on_primary'))
      }
      .alignItems(HorizontalAlign.Start)
      Image($r('app.media.ic_order_success')).width(128).height(128)
    }
    .height(128)
    .borderRadius(20)
    .width(Constants.FULL_SIZE)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor($r('sys.color.multi_color_09'))
  }
}
