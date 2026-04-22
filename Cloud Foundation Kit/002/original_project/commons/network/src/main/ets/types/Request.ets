import { PackageSpecResp } from './Order';
import { StoreInfoResp } from './Store';

export interface CommonReq {
  // 商户Id
  storeId: string;

  // 用户Id
  userId: string;

  // 用户OpenID
  openId: string;

  // 用户UnionID。
  unionId: string;

  // 鸿蒙应用包名
  packageName: string;

  // 订单Id
  orderId: string;

  // 商品Id
  goodsId: string;

  // 商品规格字符串
  spec: string;

  // 已选商品规格
  combination: PackageSpecResp[];

  // 抵扣优惠券ID
  couponId: string;

  // 华为登录返回code
  code: string;

  // Id
  id: string;

  // 商品数量
  num: number;

  // 充值金额
  rechargeTierId: string;

  // 是否关联
  isRelative: boolean;
}

export interface AddCarReq {
  // 商品单价
  money: number;

  // 商品id
  goodsId: string;

  // 商品数量
  num: number;

  // 商品规格
  specType: number;

  // 已选商品规格字符串
  spec: string;

  // 已选商品规格
  combination: PackageSpecResp[];

  // 商品打包费
  boxMoney: number;
}

export interface GoodsReq {
  // 商品id
  id: string;

  // 商品图片
  img: string;

  // 商品单价
  money: number;

  // 商品名称
  name: string;

  // 商品数量
  num: number;

  // 已选商品规格字符串
  spec: string;

  // 已选商品规格
  combination: PackageSpecResp[];
}

export interface AddDnOrderReq {
  tableId: string, //桌号
  money: number, //订单金额
  discount: string, //优惠金额
  mjMoney: number, //满减金额
  xyhMoney: number, //新人优惠金额
  note: string, //备注
  payType: number, //支付类型 0 华为支付
  sz: string, //购物车列表
  tableware: ResourceStr, //用餐人数
  yhqMoney: number, //优惠券金额
  couponId: string, //抵扣优惠券ID
  redeemedPoint: boolean, //是否兑换积分
  orderType: number, //订单使用类型 填写 1 店铺堂食 2 打包带走
  boxMoney: number, //打包费
  reductionMoney: number, //优惠金额
  rechargeId?: string, // 充值档次
  preorderTime: string, // 预约时间
  preorderPhone: string, // 预约号码
  storeName?: string, // 店铺名称
  storeLogo?: string, // 店铺logo
  storeTel?: string, // 店铺电话
  storeAddress?: string, // 店铺地址
}


export interface MyOrderReq {
  // 订单状态
  state: Array<number>,

  // 订单页码
  page: number,

  // 订单页大小
  pagesize: number
}

export interface BookStoreParams {
  // 0-0:00~8:59, 1-9:00~15:59, 2-16:00~21:59, 3-22:00~23:59
  period: number;
  max: number;
  isPrivate: boolean;
}

export interface QueueStoreParams {
  max: number;
}

export interface BookOrderData {
  store: StoreInfoResp;
  time: string;
  count: number;
  room: boolean;
  name: string;
  phone: string;
  decoration?: string;
  tableWares?: string[];
  tips?: string;
}

export interface CancelBookOrderDate {
  orderId: number;
}

export interface QueueOrderData {
  store: StoreInfoResp;
  count: number;
}

export interface CancelQueueOrderDate {
  orderId: number;
}

export interface RefreshQueueOrderParams {
  orderId: number;
}