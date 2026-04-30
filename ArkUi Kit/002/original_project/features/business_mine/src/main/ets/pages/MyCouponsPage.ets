import { AppStorageV2 } from '@kit.ArkUI';
import { Constants, NavHeaderBar, RouterMap, RouterUtil, WindowModel, } from 'lib_common';
import { MyCoupons } from 'module_coupon';

@Builder
export function MyCouponsPageBuilder() {
  MyCouponsPage()
}

@ComponentV2
struct MyCouponsPage {
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!

  build() {
    NavDestination() {
      NavHeaderBar({ title: $r('app.string.my_coupon'), hasBgColor: false })
      Column() {
        MyCoupons({
          clickUseNow: () => {
            RouterUtil.pushPathByName(RouterMap.PLATE_NUMBER_PAGE);
          },
        })
      }
      .padding({
        bottom: this.windowModel.getWindowBottomHeight()
      })
      .layoutWeight(1)
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}
