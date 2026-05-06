import { getScenarioStatus } from './index';
import { Https } from '../network/Index';
import { CouponStatus, ScenarioStatus } from '../types/index';

/**
 * 全局变量
 */
@ObservedV2
export class GlobalCouponUtils {
  // 我的券包（可用）数量
  @Trace validCouponListCount: number = 0;

  constructor() {
    this.setValidCouponListCount();
  }

  private setValidCouponListCount() {
    this.getValidCouponListCount().then((resp) => {
      this.validCouponListCount = resp;
    })
  }

  /**
   * 获取有效优惠券数量
   */
  private async getValidCouponListCount() {
    const resp = await Https.getCoupons({ userId: 'xxx', status: CouponStatus.effective });
    const list = resp.data.couponsList.filter(v => {
      const status = getScenarioStatus(v, 10);
      return status === ScenarioStatus.NOW_USE;
    })
    return list.length;
  }

  /**
   * 消费优惠券
   */
  consumeCoupon(couponID: string) {
    return Https.consumeCoupon({ couponID }).then(() => {
      this.setValidCouponListCount();
    });
  };
}