import { RouterMap } from './RouterMap'

export class Constants {
  // 接口请求超时时间
  static readonly REQUEST_TIME_OUT = 3 * 1000
  static readonly FULL_SIZE = '100%'
  // 用户授权成功
  static readonly USER_GRANT_SUCCESS = 0
  // 必选品
  static readonly GOODS_MUST = 1
  // 店铺休息
  static readonly STORE_REST = 1
  // 优惠券领取状态 5 已领取
  static readonly COUPON_STATE_COLLECT = '5'
  // 页面边距
  static readonly BORDER_WIDTH = 16
  static readonly GOOD_TYPE_HOT = '1'
  static readonly RICH_TEXT_URI = 'resource://rawfile/richtext.html'
  static readonly MID_DAY_TIME = '12:00'
  static readonly DEFAULT_CITY = '北京'
  static readonly YEAR_PICKER =
    ['2010年', '2011年', '2012年', '2013年', '2014年', '2015年', '2016年', '2017年', '2018年', '2019年', '2020年',
      '2021年', '2022年', '2023年', '2024年', '2025年', '2026年', '2027年', '2028年', '2029年', '2030年', '2031年',
      '2032年', '2033年', '2034年', '2035年', '2036年', '2037年', '2038年', '2039年', '2040年',
      '2000年', '2001年', '2002年', '2003年', '2004年', '2005年', '2006年', '2007年', '2008年', '2009年']
  static readonly MONTH_PICKER: string[] =
    ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
  //todo 积分兑换金额
  static readonly POINT_REDEEMED_MONEY = 5
  //todo 每桌预计等待时间（分钟）
  static readonly QUEUE_TABLE_MIN = 5
  //todo banner广告信息 广告位ID
  static readonly AD_INFO = 'testw6vs28auh3'
  //todo 支持华为应用内分享的页面
  static readonly SHARE_PAGES: string[] = [RouterMap.MAIN_INDEX, RouterMap.GOODS_DETAIL_PAGE]
  //todo 卡片跳转参数不封装对象的页面
  static readonly CARD_JUMP_PARAMS_PAGES: string[] = [RouterMap.BOOK_RES_PAGE, RouterMap.QUEUE_RES_PAGE]
}

export class CommonUrl {
  // todo mock图片url前缀，真实图片地址可以按业务需求指定
  static readonly CLOUD_STORAGE_URL = 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/test-1pvkp/'
}

export enum PayType {
  HUAWEI_PAY = 1,
  WALLET,
}

// 订单状态
export enum DnState {
  // 全部
  ALL = 0,
  // 待支付
  TO_BE_PAID = 1,
  // 已完成
  COMPLETED = 2,
  // 已取消
  CANCELED = 3,
}

// 订单列表tab
export enum OrderListEnum {
  // 全部
  ALL = 0,
  // 待支付
  TO_BE_PAID,
  // 已完成
  COMPLETED,
  // 已取消
  CANCELED,
}

// 商品类别
export enum GoodsSpecEnum {
  // 正常
  NORMAL = 1,
  // 选规格
  SPEC_TYPE = 2,
  // 选套餐
  PACKAGE_TYPE = 3,
}

// 订单类型
export enum OrderTypeEnum {
  // 堂食
  DINE_IN = 1,
  // 外带
  TAKEOUT = 2,
}

// 订单详情行枚举
export enum OrderDetailRowEnum {
  XYH_MONEY = 0,
  MJ_MONEY,
  YHQ_MONEY,
  BOX_MONEY,
  PAY_TYPE,
  REAL_PAY,
  ORDER_TIME,
  ORDER_ID,
  TABLE_INFO,
  ORDER_TYPE,
  TABLEWARE,
  REMARK,
}

// 订单状态
export enum OrderStateEnum {
  All = 0,
  noFinished,
  finished,
  AfterSales
}

export enum ModuleName {
  HOME = 'home',
  ORDER = 'order',
  ORDER_LIST = 'order_list',
  PERSONAL_CENTER = 'personal_center',
}

export enum EmitterEvent {
  REFRESH_ORDER_LIST = 'refreshOrderList',
  REFRESH_MINE = 'refreshMine'
}

export { RouterMap }
