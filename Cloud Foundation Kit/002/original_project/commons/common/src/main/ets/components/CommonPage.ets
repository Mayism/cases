import { AppStorageV2 } from '@kit.ArkUI';
import { Constants } from '../constants/Common';
import { WindowModel } from '../models/StorageModel';
import { CommonHeader } from './CommonHeader';

@ComponentV2
export struct CommonPage {
  @Param windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel()) as WindowModel
  @Param title: string = '标题';
  @BuilderParam topUi?: () => void;
  @BuilderParam mainUi?: () => void;
  @BuilderParam bottomUi?: () => void;
  @Event onShow?: () => void;

  build() {
    NavDestination() {
      Column() {
        /** 标题栏 **/
        CommonHeader({ title: this.title })

        this.topUi?.()

        Scroll() {
          Column({ space: 12 }) {
            this.mainUi?.()
          }.justifyContent(FlexAlign.Start)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .width('calc(100% - 32vp)')
        .padding({ bottom: $r('app.string.padding_6') })

        this.bottomUi?.()
      }
      .backgroundColor($r('app.color.system_color_background_gray'))
    }
    .hideTitleBar(true)
    .padding({ top: this.windowModel.getWindowTopHeight(), bottom: this.windowModel.getWindowBottomHeight() })
    .backgroundColor(this.windowModel.fullScreen ? $r('app.color.system_color_background_gray') : undefined)
    .height(Constants.FULL_SIZE)
    .onShown(() => {
      this.onShow?.();
    })
  }
}