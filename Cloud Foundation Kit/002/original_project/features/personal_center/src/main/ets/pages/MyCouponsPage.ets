import { AppStorageV2 } from '@kit.ArkUI';
import { CouponCard, CouponItem } from 'base_ui';
import {
  BreakpointNameEnum,
  BreakpointType,
  Constants,
  GridRowColSetting,
  HomePageRouter,
  NavHeaderBar,
  RouterModule,
  TabBarType,
  WindowModel,
} from 'common/Index';
import * as API from '../api/Index';

@Builder
export function MyCouponsPageBuilder() {
  MyCouponsPage()
}

@ComponentV2
struct MyCouponsPage {
  @Local breakpoint: string = '';
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!
  @Local currentIndex: number = 0
  @Local myCouponsAll: CouponItem[] = []
  @Local myCouponsUsable: CouponItem[] = []
  @Local myCouponsExpired: CouponItem[] = []
  @Local myCouponsUsed: CouponItem[] = []

  aboutToAppear() {
    this.getMyCoupon()
  }

  getMyCoupon() {
    API.getMyCoupons().then((res) => {
      res.forEach((item: CouponItem) => {
        this.myCouponsAll.push(item)
        if (item.offsetInfo) {
          this.myCouponsUsed.push(item)
        } else if (new Date(`${item.endTime} 23:59:59`).getTime() > new Date().getTime()) {
          this.myCouponsUsable.push(item)
        } else {
          this.myCouponsExpired.push(item)
        }
      })
    })
  }

  @Builder
  tabBuilder(index: number, name: Resource) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? $r('sys.color.multi_color_09') : $r('sys.color.font_secondary'))
        .fontSize($r('sys.float.Body_L'))
        .fontWeight(FontWeight.Medium)
      if (this.currentIndex === index) {
        Row()
          .width(42)
          .height(0)
          .borderWidth({ bottom: 2 })
          .borderColor($r('sys.color.multi_color_09'))
          .margin({ top: 4 })
      }
    }
    .width(Constants.FULL_SIZE)
    .height(50)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .padding({ top: 12, bottom: 12 })
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: $r('app.string.my_coupon') })
      GridRow(GridRowColSetting.DEFAULT_GRID_ROW_OPTIONS) {
        GridCol({ span: GridRowColSetting.GRID_ROW_OPTIONS_COLUMNS }) {
          Scroll() {
            Tabs({ index: this.currentIndex }) {
              TabContent() {
                this.CouponListBuilder(this.myCouponsAll, () => {
                  RouterModule.pop({ index: TabBarType.ORDER } as HomePageRouter)
                })
              }.tabBar(this.tabBuilder(0, $r('app.string.all')))

              TabContent() {
                this.CouponListBuilder(this.myCouponsUsable, () => {
                  RouterModule.pop({ index: TabBarType.ORDER } as HomePageRouter)
                })
              }.tabBar(this.tabBuilder(1, $r('app.string.available')))

              TabContent() {
                this.CouponListBuilder(this.myCouponsExpired)
              }.tabBar(this.tabBuilder(2, $r('app.string.expired')))

              TabContent() {
                this.CouponListBuilder(this.myCouponsUsed)
              }.tabBar(this.tabBuilder(3, $r('app.string.coupon_used')))
            }
            .width(Constants.FULL_SIZE)
            .barHeight(50)
            .layoutWeight(1)
            .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
              this.currentIndex = targetIndex
            })
            .onChange((index) => {
              this.currentIndex = index;
            })
          }
          .layoutWeight(1)
          .scrollBar(BarState.Off)
          .align(Alignment.Top)
          .margin({
            left: GridRowColSetting.getPageMargin(this.breakpoint),
            right: GridRowColSetting.getPageMargin(this.breakpoint),
            bottom: this.windowModel.getWindowBottomHeight(),
          })
        }
      }.layoutWeight(1)
      .onBreakpointChange((bp) => {
        this.breakpoint = bp;
      })
    }.hideTitleBar(true)
    .backgroundColor($r('sys.color.comp_background_gray'))
  }

  @Builder
  CouponListBuilder(couponList: CouponItem[], useNow?: () => void) {
    List({ space: 8 }) {
      ForEach(couponList, (item: CouponItem) => {
        ListItem() {
          CouponCard({
            coupon: item, useNow,
          }).backgroundColor($r('sys.color.background_primary')).borderRadius(16);
        };
      }, (item: CouponItem) => JSON.stringify(item));
    }
    .align(Alignment.Top)
    .height(Constants.FULL_SIZE)
    .scrollBar(BarState.Off)
    .lanes(new BreakpointType<number>({
      [BreakpointNameEnum.SM]: 1,
      [BreakpointNameEnum.MD]: 2,
      [BreakpointNameEnum.LG]: 2,
      [BreakpointNameEnum.XL]: 2,
    }).getValue(this.breakpoint), 12)
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
    .contentStartOffset(8)
    .contentEndOffset(8)
  }
}
