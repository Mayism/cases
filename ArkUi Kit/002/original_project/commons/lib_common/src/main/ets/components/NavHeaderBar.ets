import { RouterUtil } from '../utils/RouterUtil';
import { Constants } from '../constants/Common';

@ComponentV2
export struct NavHeaderBar {
  @Param @Require title: ResourceStr;
  @Param hasBackButton: boolean = true;
  @Param hasBgColor: boolean = true;
  @Param backImg: ResourceStr = $r('app.media.ic_back_grey');
  @Param hasBackgroundImg: boolean = true;
  @Param isMainPage: boolean = false;
  windowTopHeight: number = AppStorage.get('windowTopHeight') as number || 38.77

  build() {
    Column() {
      Row() {
        if (this.hasBackButton) {
          Image(this.backImg)
            .width(40)
            .height(40)
            .draggable(false)
            .onClick(() => {
              RouterUtil.pop()
            })
        }
        Text(this.title)
          .fontColor($r('sys.color.font_primary'))
          .fontSize(this.isMainPage ? $r('sys.float.Title_M') : $r('sys.float.Title_S'))
          .width(Constants.FULL_SIZE)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 8 })
      }.height(40).margin({ left: 16 })
    }
    .alignItems(HorizontalAlign.Start)
    .padding({
      top: 8 + this.windowTopHeight,
      bottom: 8,
    })
    .width(Constants.FULL_SIZE)
    .backgroundColor(this.hasBgColor ? $r('sys.color.background_primary') : '#00000000')
  }
}