export const GOODS_MUST = 1 // 订单详情行枚举

export const CLOUD_STORAGE_URL = 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/test-1pvkp/'

export enum CouponStateEnum {
  USABLE = 0,
  USED = 1,
}

// 商品类别
export enum GoodSpecEnum {
  // 正常
  NORMAL = 1,
  // 选规格
  SPEC_TYPE = 2,
  // 选套餐
  PACKAGE_TYPE = 3,
  // 加购商品
  ADD_GOODS = 4,
}
export enum ScenarioStatus {
  // 立马可用
  NOW_USE = 0,
  // 低于满额
  LESS_FULL = 1,
  // 未来使用
  FUTURE_USE = 2,
  // 已使用
  HAS_USED = 3,
  // 已过期
  EXPIRE = 4,
}
export enum ReductionTypes {
  // 满减
  FULL_REDUCTION = '0',
  // 立减
  DIRECT_REDUCTION = '1',
}

