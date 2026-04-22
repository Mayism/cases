import { Constants, CouponRouter, NavHeaderBar, RouterMap, RouterModule, TabBarType, WindowModel } from 'common/Index';
import { AppStorageV2 } from '@kit.ArkUI';
import { CouponCard, CouponItem } from 'base_ui';
import * as API from '../api/Index';

@Builder
export function SelectCouponPageBuilder() {
  SelectCouponPage()
}

@ComponentV2
struct SelectCouponPage {
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!
  // 订单总金额
  @Local totalMoney: number = 0
  // 已选择优惠券id
  @Local selectId: string = ''
  @Local selectCouponMoney: number = 0
  @Local currentIndex: number = 0
  @Local myCouponsUsable: Array<CouponItem> = []
  @Local myCouponsUnUsable: Array<CouponItem> = []

  aboutToAppear() {
    this.getParams()
    this.getMyCoupon()
  }

  getParams() {
    let params = RouterModule.getNavParam<CouponRouter>(RouterMap.SELECT_COUPON_PAGE)
    if (params) {
      this.totalMoney = params.totalMoney ?? 0
      this.selectId = params.selectId ?? ''
    }
  }

  getMyCoupon() {
    API.getMyCoupons().then((res) => {
      res.forEach((item: CouponItem) => {
        // 初始化优惠券金额
        if (item.couponID === this.selectId) {
          this.selectCouponMoney = Number(item.amountRule.discountAmount)
        }
        // 过滤可使用的优惠券 1.满减金额小于等于订单金额 2.日期在有效期内 3.未使用
        if (Number(item.amountRule.fullAmount) <= this.totalMoney &&
          new Date(`${item.endTime} 23:59:59`).getTime() > new Date().getTime() && !item.offsetInfo) {
          this.myCouponsUsable.push(item)
        } else {
          this.myCouponsUnUsable.push(item)
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
    .backgroundColor($r('sys.color.comp_background_primary'))
  }

  @Styles
  listStyle(){
    .backgroundColor('#F2F1F3F5').align(Alignment.Top).height(Constants.FULL_SIZE).padding({
      top: 8,
      left: 12,
      right: 12,
      bottom: 8,
    })
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: $r('app.string.coupon_label') })

      Tabs({ index: this.currentIndex }) {
        TabContent() {
          List({ space: 8 }) {
            ForEach(this.myCouponsUsable, (item: CouponItem) => {
              ListItem() {
                CouponCard({
                  coupon: item,
                  isOrder: true,
                  selectId: this.selectId,
                  totalMoney: this.totalMoney,
                  clickCoupon: (coupon: CouponItem) => {
                    this.selectCoupon(coupon)
                  },
                  useNow: () => {
                    RouterModule.popToName<number>(RouterMap.MAIN_INDEX, TabBarType.ORDER)
                  },
                })
              }
            }, (item: CouponItem) => JSON.stringify(item))
          }.listStyle().scrollBar(BarState.Off)
        }.tabBar(this.tabBuilder(0, $r('app.string.can_use')))

        TabContent() {
          List({ space: 8 }) {
            ForEach(this.myCouponsUnUsable, (item: CouponItem) => {
              ListItem() {
                CouponCard({ coupon: item, isOrder: true, totalMoney: this.totalMoney })
              }
            }, (item: CouponItem) => JSON.stringify(item))
          }.listStyle().scrollBar(BarState.Off)
        }.tabBar(this.tabBuilder(1, $r('app.string.can_not_use')))
      }
      .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
        this.currentIndex = targetIndex
      })
      .width(Constants.FULL_SIZE)
      .barHeight(70)
      .layoutWeight(1)
      .onChange((index) => {
        this.currentIndex = index;
      })

      if (this.currentIndex === 0) {
        Row() {
          Text($r('app.string.selected_coupon', `${this.selectId ? 1 : 0}`))
            .fontColor($r('sys.color.font_secondary'))
            .fontSize($r('sys.float.Caption_M'))
            .lineHeight(14)
          Row() {
            Text($r('app.string.currency_symbol'))
              .fontColor($r('sys.color.multi_color_09'))
              .fontSize(8)
              .fontWeight(FontWeight.Medium)
              .lineHeight(12)
              .margin({ bottom: 1 })
            Text(`${Number(this.selectCouponMoney)}`)
              .fontColor($r('sys.color.multi_color_09'))
              .fontSize($r('sys.float.Body_L'))
              .fontWeight(FontWeight.Medium)
              .lineHeight(18)
          }.margin({ left: 6 }).alignItems(VerticalAlign.Bottom)

          Button($r('app.string.confirm'))
            .fontColor($r('sys.color.comp_background_list_card'))
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(700)
            .height(32)
            .backgroundColor($r('sys.color.multi_color_09'))
            .padding({
              top: 8,
              left: 32,
              right: 32,
              bottom: 8,
            })
            .margin({ left: 12 })
            .onClick(() => {
              RouterModule.pop({
                'selectId': this.selectId,
                'reduce': this.selectCouponMoney,
              } as Record<string, string | number>)
            })
        }
        .width(Constants.FULL_SIZE)
        .height(56)
        .padding({ top: 12, bottom: 12, right: 14 })
        .justifyContent(FlexAlign.End)
      }
    }.hideTitleBar(true).padding({ bottom: this.windowModel.getWindowBottomHeight() })
  }

  canUseCoupon(item: CouponItem) {
    if (new Date(`${item.endTime} 23:59:59`).getTime() > new Date().getTime() && item.offsetInfo) {
      return true
    } else {
      return false
    }

  }

  selectCoupon(coupon: CouponItem) {
    this.selectId = coupon.couponID
    this.selectCouponMoney = Number(coupon.amountRule.discountAmount)
  }
}
