export class HttpCode {
  static readonly SUCCESS = 0
  static readonly SUCCESS_200 = 200
  static readonly CANCEL_PAY = 1001930000
  static readonly PAY_FAILED = 1001930001
  static readonly NETWORK_ERROR = 1001930011
  static readonly DUPLICATE_REQUEST = 1001930010
}

export class RequestUrl {
  // base url
  static readonly BASE_URL = 'https://xxxxxxxxx/v1/app';
  // 获取商场信息
  static readonly GET_SHOPPING_MALL_INFO_URL = 'getShoppingMallInfo'
  // 获取用户信息
  static readonly GET_USER_INFO = 'getUserInfo'
  // 新增车牌
  static readonly ADD_PLATE_NUMBER = 'addPlateNumber'
  // 删除车牌
  static readonly DELETE_PLATE_NUMBER = 'deletePlateNumber'
  // 查询车牌
  static readonly QUERY_PLATE_NUMBER = 'queryPlateNumber'
  // 关联手机号
  static readonly GET_OPEN_LOGIN_HM_URL = 'getOpenLoginHm'
  // 解除关联手机号
  static readonly GET_CLOSE_LOGIN_HM_URL = 'getCloseLoginHm'
  // 获取缴费信息
  static readonly GET_PAY_DETAIL = 'getPayDetail'
  // 获取缴费记录
  static readonly GET_PAY_RECORD_LIST = 'getPayRecordList'
  static readonly PAY_ORDER = 'payOrder'
  static readonly GET_PRIVACY_INFO = 'getPrivacyInfo'
  // 修改用户信息
  static readonly MODIFY_USER_INFO = 'modifyUserInfo'
  // 查询我的钱包
  static readonly GET_MY_WALLET_LIST_URL = 'getMyWalletList'
  // 查询服务
  static readonly GET_SERVICE_URL = 'getService'
  // 查询店铺导购
  static readonly GET_STORE_GUIDE_URL = 'getStoreGuide'
}

export class CommonUrl {
  static readonly CLOUD_STORAGE_URL = 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/template-thwjd/'
}

export class Constants {
  // 接口请求超时时间
  static readonly REQUEST_TIME_OUT = 3 * 1000
  static readonly FULL_SIZE = '100%'
  static readonly BORDER_WIDTH = 16
  // 用户授权成功
  static readonly USER_GRANT_SUCCESS = 0
  // 时间转换
  static readonly SECOND_TO_MIN = 60
  // 延迟时间1000ms
  static readonly DELAY_TIME_1000 = 1000
  static readonly AM_PM = 12
  static readonly MAP_HEIGHT_DEFAULT = 216
  static readonly MID_DAY_TIME = '12:00'
  static readonly YEAR_PICKER =
    ['1990年', '1991年', '1992年', '1993年', '1994年', '1995年', '1996年', '1997年', '1998年', '1999年',
      '2000年', '2001年', '2002年', '2003年', '2004年', '2005年', '2006年', '2007年', '2008年', '2009年', '2010年',
      '2011年', '2012年',
      '2013年', '2014年', '2015年', '2016年', '2017年', '2018年', '2019年', '2020年', '2021年', '2022年', '2023年',
      '2024年', '2025年',
      '2026年', '2027年', '2028年', '2029年', '2030年']
  static readonly MONTH_PICKER: string[] =
    ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
}

export enum PLATE_TYPE {
  NORMAL = 1,
  SPECIAL,
}

export enum PLATE_COLOR_TYPE {
  BLUE = '1',
  GREEN = '2',
  YELLOW = '3'
}

// 停车支付
export enum PAY_STATUE {
  ENTERED = 1,
  PENDING_PAYMENT,
  PAYMENT_COMPLETED,
  PENDING_EXIT,
  DEPARTED
}

// 停车状态
export enum CAR_STATUE {
  ENTERED = 1,
  PENDING_EXIT,
  DEPARTED
}

// 优惠券状态枚举
export enum COUPON_STATE_ENUM {
  // 未领取
  NOT_PICKED_UP = 0,
  // 可使用
  USABLE,
  //已使用
  USED,
}

// 优惠券状态枚举
export enum POINT_TYPE_ENUM {
  // 自助积分
  self_point = 1,
  // 消费记录
  CONSUMPTION_RECORDS,
}