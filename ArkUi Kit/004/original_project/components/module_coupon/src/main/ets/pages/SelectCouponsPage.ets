import { CommonConstants } from '../commonlib/Index'
import { CouponItem } from '../network/Index'
import { CouponCard } from '../components/CouponCardComp'
import { SELECT_TAB_BAR } from '../constants/Index'
import { ScenarioStatus } from '../types'
import { getCouponList, getReduceAmount, getScenarioStatus } from '../utils'

@ComponentV2
export struct SelectCoupons {
  // 传入的券id
  @Param selectIdParam: string = '';
  // 选择优惠券回调
  @Event onSelect: (id: string, money: number) => void = () => {
  };
  // 订单总金额
  @Local totalMoney: number = 0;
  @Local selectCouponMoney: number = 0;
  @Local myCouponsAll: CouponItem[] = [];
  @Local refreshing: boolean[] = [];
  @Local currentIndex: number = 0;
  @Local selectId: string = '';
  private tabBar: string[] = [];

  @Computed
  get contentData() {
    const data: Array<CouponItem[]> = [[], []];
    this.myCouponsAll.forEach((item: CouponItem) => {
      if (item.couponID === this.selectId) {
        this.selectCouponMoney = getReduceAmount(item, this.totalMoney);
      }
      const status = getScenarioStatus(item, this.totalMoney);
      switch (status) {
        case ScenarioStatus.NOW_USE:
          data[0].push(item);
          break;
        case ScenarioStatus.LESS_FULL:
        case ScenarioStatus.FUTURE_USE:
          data[1].push(item);
          break;
        default:
          break;
      }
    })
    // 减免多 => 减免少
    data[0].sort((a: CouponItem, b: CouponItem) => getReduceAmount(b, this.totalMoney) -
    getReduceAmount(a, this.totalMoney));
    // 满额不足 => 活动未开始
    data[1].sort((a: CouponItem, b: CouponItem) => getScenarioStatus(a, this.totalMoney) -
    getScenarioStatus(b, this.totalMoney));
    return data
  }

  aboutToAppear() {
    this.tabBar = SELECT_TAB_BAR;
    this.refreshing = Array.from<boolean>({ length: this.tabBar.length }).fill(false);
    this.selectId = this.selectIdParam;
    getCouponList().then((res) => {
      this.myCouponsAll = res;
    })
  }

  build() {
    Column() {
      this.contentBuilder(0)
      this.btnBuilder()
    }
    .width('100%')
  }

  @Builder
  contentBuilder(index: number) {
    if (this.contentData[index].length) {
      this.tabContentBuilder(index)
    } else {
      this.emptyBuilder()
    }
  }

  @Builder
  tabContentBuilder(index: number) {
    Refresh({ refreshing: this.refreshing[index] }) {
      List({ space: 12 }) {
        ForEach(this.contentData[index], (item: CouponItem) => {
          ListItem() {
            CouponCard({
              coupon: item,
              isOrder: true,
              selectId: this.selectId,
              totalMoney: this.totalMoney,
              clickCoupon: (coupon: CouponItem) => {
                if (this.selectId === coupon.couponID) {
                  this.selectId = '';
                  this.selectCouponMoney = 0;
                } else {
                  this.selectId = coupon.couponID;
                  this.selectCouponMoney = getReduceAmount(coupon, this.totalMoney);
                }
              },
            })
          }
        }, (item: CouponItem, index) => JSON.stringify(item) + '_' + index)
      }
      .width(CommonConstants.FULL_WIDTH)
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .layoutWeight(1)
    .onStateChange(status => {
      if (status === RefreshStatus.Refresh) {
        this.refreshing[index] = true;
      }
    })
    .onRefreshing(() => {
      getCouponList().then((res) => {
        this.myCouponsAll = res;
        this.refreshing[index] = false;
      })
    })
    .align(Alignment.Top)
  }

  @Builder
  emptyBuilder() {
    Column() {
      Column() {
        Image($r('app.media.ic_no_record')).width(160)
        Text('暂无停车券').fontSize(12).fontColor($r('sys.color.font_secondary')).margin({ top: 12 })
      }.width('100%')
    }
    .justifyContent(FlexAlign.Center)
    .layoutWeight(1)
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
  }

  @Builder
  btnBuilder() {
    Column() {
      Button('确定')
        .width('100%')
        .backgroundColor($r('app.color.sys_brand_fuchsia'))
        .height(40)
        .onClick(() => {
          this.onSelect(this.selectId, this.selectCouponMoney);
        })
    }
    .padding({ top: 8, bottom: 8 })
  }

  @Builder
  bottomBuilder() {
    Row() {
      Text($r('app.string.selected_coupon', `${this.selectId ? 1 : 0}`))
        .fontColor($r('sys.color.font_secondary'))
        .fontSize($r('sys.float.Caption_M'))
        .lineHeight($r('app.string.line_height_14'))

      Row() {
        Text($r('app.string.currency_symbol'))
          .fontColor($r('sys.color.multi_color_09'))
          .fontSize($r('app.string.font_size_8'))
          .fontWeight(FontWeight.Medium)
          .lineHeight($r('app.string.line_height_12'))
          .margin({ bottom: 1 })
        Text(this.selectCouponMoney.toFixed(2))
          .fontColor($r('app.color.sys_brand_fuchsia'))
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .lineHeight($r('app.string.line_height_18'))
      }
      .margin({ left: $r('app.string.margin_6') })
      .alignItems(VerticalAlign.Bottom)

      Button($r('app.string.confirm'))
        .fontColor($r('sys.color.comp_background_list_card'))
        .fontSize($r('sys.float.Body_L'))
        .fontWeight(FontWeight.Bold)
        .height(32)
        .backgroundColor($r('app.color.sys_brand_fuchsia'))
        .padding({
          top: 8,
          left: 32,
          right: 32,
          bottom: 8,
        })
        .margin({ left: $r('app.string.margin_12') })
        .onClick(() => {
          this.onSelect(this.selectId, this.selectCouponMoney);
        })
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(56)
    .padding({ top: 12, right: 14 })
    .justifyContent(FlexAlign.End)
    .transition(TransitionEffect.translate({ y: '100%' }).animation({ duration: 100, curve: Curve.Smooth }))
  }
}
