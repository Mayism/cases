import { PackageSpec } from './ResponseModel';

export interface CommonReq {
  // 商户Id
  storeId: string;
  // 用户Id
  userId: string;
  // 用户OpenID
  openId: string;
  // 用户UnionID。
  unionId: string;
  // 鸿蒙应用AppId
  hmAppid: string;
  // 订单Id
  orderId: string;
  // 商品Id
  goodId: string;
  // 商品规格字符串
  spec: string;
  // 已选商品规格
  combination: PackageSpec[];
  // 抵扣优惠券ID
  couponId: string;
  // 华为登录返回code
  code: string;
  // Id
  id: string;
  // 商品数量
  num: string;
  // 新闻类型
  type: string;
}

export interface MyOrderReq {
  // 商户id
  storeId: string,

  // 订单状态
  dnState: string,

  // 用户id
  userId: string,

  // 订单页码
  page: number,

  // 订单页大小
  pagesize: number
}