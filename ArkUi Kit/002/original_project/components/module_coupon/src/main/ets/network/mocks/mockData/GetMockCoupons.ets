import { BaseSuccessResponse } from '../../types/BaseSuccessResponse';
import {
  CouponItem,
  CouponModel,
  CouponRule,
  GetCouponsResp,
  OffsetInfo
} from '../../types/responseTypes/GetCouponsResp';

class CommonRules {
  // 满减-低
  static readonly RULE1_LOW: CouponRule = {
    amountRuleNo: '1',
    amountRuleDesc: '满减',
    discountMode: '0',
    discountType: '0',
    fullAmount: '100',
    discountAmount: '10',
    discountCoefficient: '',
  }
  // 满减-高
  static readonly RULE1_HIGH: CouponRule = {
    amountRuleNo: '1',
    amountRuleDesc: '满减',
    discountMode: '0',
    discountType: '0',
    fullAmount: '200',
    discountAmount: '25',
    discountCoefficient: '',
  }
  // 立减
  static readonly RULE2: CouponRule = {
    amountRuleNo: '2',
    amountRuleDesc: '立减',
    discountMode: '0',
    discountType: '1',
    fullAmount: '',
    discountAmount: '5',
    discountCoefficient: '',
  }
  // 折扣
  static readonly RULE3: CouponRule = {
    amountRuleNo: '3',
    amountRuleDesc: '折扣',
    discountMode: '0',
    discountType: '2',
    fullAmount: '',
    discountAmount: '',
    discountCoefficient: '0.8',
  }
}

// 核销单 === 已使用
const OFFSET_INFO: OffsetInfo = {
  offsetID: '',
  couponCollectionTime: '',
  couponOffsetTime: '',
  offsetOrder: '',
  couponStatus: '',
}

export class CouponMock {
  static validList: CouponItem[] = [
  // 生效-待使用-活动期间-立减
    new CouponModel('1', '停车券', '0', '2025-1-1', '2035-1-1', '2', CommonRules.RULE2, '-1', '0', '', '', '', '',
      '2', [], [{ key: 0, value: '新用户注册' }], '', ''),
    // 生效-待使用-活动期间-立减
    new CouponModel('2', '停车券', '0', '2025-1-1', '2035-1-1', '2', CommonRules.RULE2, '-1', '0', '', '', '', '',
      '2', [], [{ key: 0, value: '新用户注册' }], '', ''),
    // 生效-已使用-满减
    new CouponModel('7', '停车券', '0', '2025-1-1', '2035-1-1', '2', CommonRules.RULE2, '-1', '0', '', '',
      '', '', '2', [], [{ key: 0, value: '新用户注册' }], '', '', OFFSET_INFO),
    // 生效-已使用-立减
    new CouponModel('8', '停车券', '0', '2025-1-1', '2035-1-1', '2', CommonRules.RULE2, '-1', '0', '', '', '', '',
      '2', [], [{ key: 0, value: '新用户注册' }], '', '', OFFSET_INFO),
    // 生效-已使用-折扣
    new CouponModel('9', '停车券', '0', '2025-1-1', '2035-1-1', '2', CommonRules.RULE2, '-1', '0', '', '', '', '',
      '2', [], [{ key: 0, value: '新用户注册' }], '', '', OFFSET_INFO),
    // 生效-已过期-满减
    new CouponModel('10', '停车券', '0', '2025-1-1', '2025-2-1', '2', CommonRules.RULE2, '-1', '0', '', '',
      '', '', '2', [], [{ key: 0, value: '新用户注册' }], '', ''),
    // 生效-已过期-立减
    new CouponModel('11', '停车券', '0', '2025-1-1', '2025-2-1', '2', CommonRules.RULE2, '-1', '0', '', '', '',
      '', '2', [], [{ key: 0, value: '新用户注册' }], '', ''),
    // 生效-已过期-折扣
    new CouponModel('12', '停车券', '0', '2025-1-1', '2025-2-1', '2', CommonRules.RULE2, '-1', '0', '', '', '',
      '', '2', [], [{ key: 0, value: '新用户注册' }], '', ''),
  ];
  static inValidList: CouponItem[] = [
  // 失效-已使用-满减
    new CouponModel('13', '停车券', '0', '2025-1-1', '2025-2-1', '3', CommonRules.RULE2, '-1', '0', '', '',
      '', '', '2', [], [{ key: 0, value: '新用户注册' }], '', '', OFFSET_INFO),
    // 失效-已使用-立减
    new CouponModel('14', '停车券', '0', '2025-1-1', '2025-2-1', '3', CommonRules.RULE2, '-1', '0', '', '', '',
      '', '2', [], [{ key: 0, value: '新用户注册' }], '', '', OFFSET_INFO),
    // 失效-已使用-折扣
    new CouponModel('15', '停车券', '0', '2025-1-1', '2025-2-1', '3', CommonRules.RULE2, '-1', '0', '', '', '',
      '', '2', [], [{ key: 0, value: '新用户注册' }], '', '', OFFSET_INFO),
  ];
}

/** 生效优惠券 **/
export const getCouponsMock1: BaseSuccessResponse<GetCouponsResp> = {
  code: 0,
  data: {
    total: 13,
    couponsList: CouponMock.validList,
  },
}

/** 失效且核销优惠券 **/
export const getCouponsMock2: BaseSuccessResponse<GetCouponsResp> = {
  code: 0,
  data: {
    total: 3,
    couponsList: CouponMock.inValidList,
  },
}

export const getCouponsMockNull: BaseSuccessResponse<GetCouponsResp> = {
  code: 0,
  data: {
    total: 0,
    couponsList: [],
  },
}