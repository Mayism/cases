import { StoreInfoResp } from './Store'

export interface SpecItemResp {
  specValId: string
  specValName: string
  specValLogo: string
  specValNum: string
}

export interface SpecCatalogResp {
  specId: string
  specName: string
  specValId: string
  specVal: Array<SpecItemResp>
}

/**
 * 商品
 */
export interface GoodsResp {
  id: string
  name: string
  logo: string
  bigImg: Array<string>
  // 现价
  money: number
  // 原价
  money2: number
  // 折扣
  discount: string
  content: string
  sales: number
  // 是否有规格 1 无 2有规格 3套餐 4加购商品
  specType: number
  details: string
  num: number
  isMust: number
  spec: Array<SpecCatalogResp>
  // 餐盒费
  boxMoney: number
}

/**
 * 菜品类别
 */
export interface DishesTypeResp {
  id: string
  typeName: string
  goods: Array<GoodsResp>
}

/**
 * 规格菜品
 */
export interface GoodsSpecResp {
  id: string
  money: number
  money2: number
  discount: string
  spec: string
  combination: PackageSpecResp[]
  number: number
  goodsId: string
  boxMoney: number
  isMust: number
  specType: number
}


export interface MyCarResp {
  boxMoney: number
  goodsList: Array<CarGoodsInfoResp>
  num: number
  money: number
}

export interface PackageSpecResp {
  specName: string
  specNum: number
}

export interface CarGoodsInfoResp {
  id: string
  goodsId: string
  name: string
  logo: string
  num: number
  specType: number
  spec: string
  combination: PackageSpecResp[]
  discount: string
  money: number
  money2: number
  boxMoney: number
  isMust: number
}


export interface OrderInfoResp {
  id: string
  orderNum: string
  time: string
  payTime: string
  money: number
  reductionMoney: number
  boxMoney: number
  mjMoney: number
  xyhMoney: number
  note: string
  payType: number
  orderType: number
  tableware: string
  yhqMoney: number
  redeemedPoint: boolean
  couponId: string
  state: number
  oid: string
  storeTel: string
  storeName: string
  storeLogo: string
  storeAddress: string
  lat: string
  lng: string
  rechargeId: string
  preorderTime: string
  preorderPhone: string
}

export interface OrderGoodsResp {
  id: string
  logo: string
  money: number
  money2: number
  discount: string
  name: string
  num: number
  isMust: number
  specType: number
  spec: string
  combination: PackageSpecResp[]
}

export interface OrderTableResp {
  id: string
  name: string
  typeName: string
}

// 订单列表
export interface MyOrderResp {
  order: OrderInfoResp
  goods: Array<OrderGoodsResp>
  table: OrderTableResp
}


export interface CouponItem {
  // ID
  couponID: string
  // 名称
  couponName: string
  // 有效期模式: 0-固定时间 ; -1-领取后N天有效((暂时只支持固定时间)
  validityPeriodMode: string
  // 优惠开始时间
  startTime: string
  // 优惠结束时间
  endTime: string
  // 优惠券状态: 0-草稿 ; 1-评审 ; 2-生效(评审通过后生效,非商家取消状态不变) ; 3-失效(评审通过且生效后,商家在活动中途手动关闭) ; 4-取消(评审失败商家关闭);5-已领取
  // 用户可见状态:所有生效优惠券(待使用+已使用+已过期) ; 失效前已使用的优惠券
  status: string
  // 使用规则
  amountRule: CouponRule
  // 发劵数量: -1-标识无限制 ; 其他数字标识发劵实际数量
  distributionQuantity: string
  // 支持重复领取：0-可以 ; 1-不可以
  repeatedPickup: string
  // 品类组
  categoryGroup: string
  // 品牌组
  brandGroup: string
  // 商品目录组
  catalogGroup: string
  // 商品组
  productGroup: string
  // 领取人限制: 0-所有人 ; 1-指定领取用户群 ; 2-指定领取场景(暂时只支持领取场景)
  recipientLimits: string
  // 领取用户群: 0-普通 ; 1-等级 ; 2-会员
  specifiedSubGroup: Array<KeyValue>
  // 领取场景: 0-新用户注册(暂时只支持新用户注册)
  specifiedPickupScenario: Array<KeyValue>
  // 创建时间
  createdTime: string
  // 最近更新时间
  lastUpdateTime: string
  // 核销单
  offsetInfo?: OffsetInfo
}

export interface CouponRule {
  // ID
  amountRuleNo: string
  // 描述说明
  amountRuleDesc: string
  // 优惠模式: 固定金额-0(暂时只支持固定金额)
  discountMode: string
  // 优惠类型：满减-0 ; 立减-1 ; 折扣-2
  discountType: string
  // 满减标准
  fullAmount: string
  // 立减额度
  discountAmount: string
  // 折扣系数
  discountCoefficient: string
}

export interface KeyValue {
  key: number
  value: string
}

export interface OffsetInfo {
  // 核销ID
  offsetID: string
  // 领取时间，默认核销时间
  couponCollectionTime: string
  // 核销时间
  couponOffsetTime: string
  // 核销订单
  offsetOrder: string
  // 核销状态：0-已核销(活动期间正常使用的优惠券) ; 1-已失效(活动期间商家手动关闭但用户已使用的优惠券)
  couponStatus: string
}

export interface BookOrderDetail {
  orderId: number;
  store: StoreInfoResp;
  time: string;
  count: number;
  room: boolean;
  name: string;
  phone: string;
  decoration: string;
  tableWares: string[];
  tips: string;
}

export interface QueueOrderDetail {
  orderId: number;
  store: StoreInfoResp;
  time: string;
  count: number;
  mine: number;
  now: number;
  wait: number;
}

export interface OrderLists {
  book: BookOrderDetail[];
  queue: QueueOrderDetail[];
}

export interface BookOrderModel extends BookOrderDetail {
  schedule: boolean;
}
