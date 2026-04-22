import { AppStorageV2 } from '@kit.ArkUI';
import { Constants } from '../constants/Common';
import { WindowModel } from '../models/StorageModel';
import { RouterModule } from '../utils/RouterModule';

@ComponentV2
export struct NavHeaderBar {
  @Param title: ResourceStr = '';
  @Param hasBackButton: boolean = true;
  @Param hasBgColor: boolean = true;
  @Param backImg: ResourceStr = $r('app.media.ic_back');
  @Param hasBackgroundImg: boolean = true;
  @Param isMainPage: boolean = false;
  @Param windowTopHeight: number = AppStorageV2.connect(WindowModel)?.getWindowTopHeight() || 38.77

  build() {
    Column() {
      Row() {
        if (this.hasBackButton) {
          Image(this.backImg)
            .width(40)
            .height(40)
            .onClick(() => {
              RouterModule.pop()
            })
        }
        Text(this.title)
          .fontColor($r('sys.color.font_primary'))
          .fontSize(this.isMainPage ? $r('sys.float.Title_M') : $r('sys.float.Title_S'))
          .width($r('app.string.full_size'))
          .fontWeight(FontWeight.Medium)
          .margin({ left: 8 })
      }.height(36).margin({ left: 16, right: 16 })
    }
    .alignItems(HorizontalAlign.Start)
    .padding({
      top: 10 + this.windowTopHeight,
      bottom: 8,
    })
    .width(Constants.FULL_SIZE)
    .backgroundColor(this.hasBgColor ? $r('sys.color.background_primary') : '#00000000')
  }
}