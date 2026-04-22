import { ReductionTypes, ScenarioStatus } from '../constants/Index';
import { CouponItem } from '../models/Index';

/**
 * 获取优惠减免金额
 */
export function getReduceAmount(coupon: CouponItem, orderMoney: number) {
  return Number(coupon.amountRule.discountAmount);
}


/**
 * 获取减免方式说明
 */
export function getReduceDesc(coupon: CouponItem) {
  switch (coupon.amountRule.discountType) {
    case ReductionTypes.FULL_REDUCTION:
      return '消费金额达到指定标准,即可享受减免';
    case ReductionTypes.DIRECT_REDUCTION:
      return '消费者直接享受相应减免';
    default:
      return '';
  }
}

/**
 * 获取距离优惠日天数
 */
export function getReduceDays(coupon: CouponItem) {
  const currentDate = new Date();
  const targetDate = new Date(coupon.startTime);
  const timeDifference = targetDate.getTime() - currentDate.getTime();
  const daysDifference = Math.ceil(timeDifference / (1000 * 3600 * 24));
  if (daysDifference < 7) {
    return `${daysDifference} 天`;
  } else if (daysDifference < 30) {
    const weeks = Math.floor(daysDifference / 7);
    return `${weeks} 周`;
  } else if (daysDifference < 365) {
    const months = Math.floor(daysDifference / 30);
    return `${months} 月`;
  } else {
    const years = Math.floor(daysDifference / 365);
    return `${years} 年`;
  }
}


/**
 * 获取优惠券场景状态
 */
export function getScenarioStatus(coupon: CouponItem, orderMoney: number) {
  if (coupon.offsetInfo) {
    return ScenarioStatus.HAS_USED;
  }
  const start = new Date(coupon.startTime + ' 0:0:0').getTime();
  const end = new Date(coupon.endTime + ' 23:59:59').getTime();
  const now = new Date().getTime();
  if (end < now) {
    return ScenarioStatus.EXPIRE;
  }
  if (now < start) {
    return ScenarioStatus.FUTURE_USE;
  }
  if (orderMoney < Number(coupon.amountRule.fullAmount)) {
    return ScenarioStatus.LESS_FULL;
  }
  return ScenarioStatus.NOW_USE;
}
