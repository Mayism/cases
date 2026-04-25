import { CommonConstants } from '../commonlib/Index';
import { CouponItem } from '../network/Index';
import { ScenarioStatus } from '../types';
import { getReduceDays, getScenarioStatus } from '../utils';

@ComponentV2
export struct CouponCard {
  /** 接收参数 **/
  // 优惠券信息
  @Require @Param coupon: CouponItem;
  // 是否来源订单页;
  @Param isOrder: boolean = false;
  // 订单总金额;
  @Param totalMoney: number = 0;
  // 已选择优惠券ID;
  @Param selectId: string = '';
  // 选中优惠券回调
  @Event clickCoupon: (coupon: CouponItem) => void = () => {
  };
  // 立即使用的回调
  @Event clickUseNow: () => void = () => {
  };
  /** 本地参数 **/
  @Local showInstruction: boolean = false;
  private status: ScenarioStatus = ScenarioStatus.NOW_USE;

  aboutToAppear() {
    this.status = getScenarioStatus(this.coupon, this.totalMoney);
  }

  build() {
    Column() {
      // 主体部分
      Row() {
        Column({ space: 4 }) {
          Text(this.coupon.couponName)
            .maxLines(1)
            .fontSize(16)
            .fontColor('rgba(0, 0, 0, 0.9)')
            .lineHeight($r('app.string.line_height_21'))
            .fontWeight(FontWeight.Medium)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text($r('app.string.coupon_type'))
            .rightSubStyle()
            .margin({ top: $r('app.string.margin_2') })

          Text(`有效期至： ${this.coupon.endTime + ' 24:00'}`).rightSubStyle().fontColor($r('sys.color.font_secondary'))

          if (this.isOrder &&
            (this.status === ScenarioStatus.FUTURE_USE || this.status === ScenarioStatus.LESS_FULL)) {
            Row({ space: 4 }) {
              Image($r('app.media.ic_icon_error')).width(12)
              if (this.status === ScenarioStatus.LESS_FULL) {
                Text($r('app.string.below_threshold',
                  (Number(this.coupon.amountRule.fullAmount) - this.totalMoney).toFixed(2))).rightReminderStyle()
              } else {
                Text($r('app.string.below_startTime', getReduceDays(this.coupon))).rightReminderStyle()
              }
            }
          }
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)
        .padding({ left: $r('app.string.padding_12') })

        // 右上
        if (this.status === ScenarioStatus.HAS_USED) {
          Image($r('app.media.ic_coupon_used')).width(48).position({ top: -24, right: -8 })
        } else if (this.status === ScenarioStatus.EXPIRE) {
          Image($r('app.media.ic_coupon_expired')).width(48).position({ top: -24, right: -8 })
        } else if (this.isOrder) {
          if (this.status === ScenarioStatus.NOW_USE) {
            Radio({ value: '', group: 'radioGroup' })
              .position({ top: -4, right: 10 })
              .checked(this.selectId === this.coupon.couponID)
              .radioStyle({ checkedBackgroundColor: $r('app.color.sys_brand_fuchsia') })
              .height(20)
              .width(20)
              .onClick(() => {
                this.clickCoupon(this.coupon);
              })
          }
        } else {
          Button($r('app.string.use_now'))
            .height(28)
            .position({ top: 0, right: 12 })
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_on_primary'))
            .backgroundColor($r('app.color.sys_brand_fuchsia'))
            .padding({
              left: 8,
              right: 8,
              top: 4,
              bottom: 4,
            })
            .onClick(() => {
              this.clickUseNow();
            })
        }

        // 右下
        Image(this.showInstruction ? $r('app.media.ic_up') : $r('app.media.ic_down'))
          .width(24)
          .height(24)
          .position({ right: 12, bottom: 0 })
          .onClick(() => {
            this.showInstruction = !this.showInstruction;
          })
      }
      .clip(true)
      .width(CommonConstants.FULL_WIDTH)
      .backgroundImage($r('app.media.coupon_card_bg'))
      .backgroundImageSize(ImageSize.Cover)
      .borderRadius($r('app.string.border_radius_16'))
      .opacity(this.status === ScenarioStatus.NOW_USE ||
        (!this.isOrder && (this.status === ScenarioStatus.FUTURE_USE || this.status === ScenarioStatus.LESS_FULL)) ?
        1 : 0.4)
      .padding({ top: $r('app.string.padding_16'), bottom: $r('app.string.padding_16') })

      // 隐藏说明
      if (this.showInstruction) {
        Column({ space: 6 }) {
          Text($r('app.string.instruction_label'))
            .fontSize($r('app.string.font_size_10'))
            .fontColor($r('sys.color.font_secondary'))
          Text('此券仅供指定商品使用').descTextStyle()
          Text('本券不与其他优惠活动叠加使用').descTextStyle()
        }
        .alignItems(HorizontalAlign.Start)
        .width(CommonConstants.FULL_WIDTH)
        .padding({
          top: 8,
          bottom: 8,
          left: 12,
          right: 12,
        })
      }
    }.width(CommonConstants.FULL_WIDTH)
  }
}

@Extend(Text)
function rightSubStyle() {
  .fontSize($r('app.string.font_size_12'))
  .lineHeight($r('app.string.line_height_16'))
  .fontColor($r('app.color.sys_brand_fuchsia'))
}


@Extend(Text)
function rightReminderStyle() {
  .fontSize($r('app.string.font_size_10'))
  .fontColor($r('app.color.sys_brand_fuchsia'))
}

@Extend(Text)
function descTextStyle() {
  .fontSize($r('app.string.font_size_8'))
  .fontColor($r('sys.color.font_secondary'))
}