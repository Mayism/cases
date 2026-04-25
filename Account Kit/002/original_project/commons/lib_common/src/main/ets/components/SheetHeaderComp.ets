import { Constants } from '../constants/Common';

@ComponentV2
export struct SheetHeaderComp {
  @Param title: ResourceStr = '';
  @Event close: () => void = () => {
  }

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize($r('sys.float.Title_S'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
        Image($r('app.media.ic_close')).width(40).onClick(() => {
          this.close()
        })
      }
      .width(Constants.FULL_SIZE)
      .height(56)
      .justifyContent(FlexAlign.SpaceBetween)
    }
  }
}