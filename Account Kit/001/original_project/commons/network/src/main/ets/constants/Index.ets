export class HttpCode {
  static readonly SUCCESS = 0
  static readonly STATUE_SUCCESS = 200
  static readonly STATUE_ERROR = 2
  static readonly SUCCESS_STR = '1'
  static readonly SUCCESS_200 = 200
  static readonly CANCEL_PAY = 1001930000
  static readonly PAY_FAILED = 1001930001
  static readonly NETWORK_ERROR = 1001930011
  static readonly DUPLICATE_REQUEST = 1001930010
}

export class RequestUrl {
  // 接口请求超时时间
  static readonly REQUEST_TIME_OUT = 500
  // todo 网络请求base url，真实网络请求可以替换请求地址
  static readonly BASE_URL = 'https://xxxxxxxxx/catering/v1/app';
  // 获取应用基础信息
  static readonly GET_APP_INFO_URL = '/store/app-info'
  // 获取店铺餐桌信息
  static readonly GET_TABLE_LIST_URL = '/store/table-list'
  // 通过静默登入获取用户openID unionID,然后通过接口获取用户信息
  static readonly GET_LOGIN_HM_URL = 'getUserInfo'
  // 关联手机号
  static readonly GET_OPEN_LOGIN_HM_URL = 'getOpenLoginHm'
  // 解除关联手机号
  static readonly GET_CLOSE_LOGIN_HM_URL = 'getCloseLoginHm'
  // 通过storeId接口获取店铺信息
  static readonly GET_STORE_LIST_URL = '/store/list'
  // 通过storeId接口获取店铺信息
  static readonly GET_STORE_INFO_URL = '/store/store-info'
  // 通过storeId接口获取商品信息
  static readonly GET_DISHES_LIST_URL = 'getDishesList'
  // 扫码进入选品页清除此用户历史购物车记录
  // 清空购物车
  static readonly GET_DEL_CAR_URL = 'clearMyCar'
  // 通过storeId 、userId接口获取商家优惠券信息
  static readonly GET_COUPONS_URL = 'getCoupons'
  // 餐饮后付提交订单
  static readonly GET_ADD_DN_ORDER_URL = 'addDnOrder'
  // 我的订单列表
  static readonly GET_MY_ORDER_URL = 'getMyOrder'
  // 取消订单
  static readonly GET_CANCEL_ORDER_URL = 'cancelOrder'
  // 订单详情
  static readonly GET_ORDER_INFO_URL = 'getOrderInfo'
  // 通过优惠券couponId、userId接口领取优惠券
  static readonly GET_LQ_COUPONS_URL = 'lqCoupons'
  // 我的购物车
  static readonly GET_MY_CAR_URL = 'getMyCar'
  // 删除已经添加到购物车的菜品数量
  static readonly GET_UPD_CAR_URL = 'updateMyCar'
  // 点击选规格，获取商品规格信息并弹窗选择
  static readonly GET_GOOD_INFO_URL = 'getGoodInfo'
  // 获取单个商品规格信息
  static readonly GET_GOOD_SPEC_URL = 'getGoodSpec'
  // 规格菜品到购物车
  static readonly GET_ADD_CAR_URL = 'addCar'
  // 查询我的优惠券列表
  static readonly GET_MY_COUPONS_URL = 'getMyCoupons'
  // 查询帮助信息
  static readonly GET_HELP_URL = 'getHelpMsg'
  // 加菜
  static readonly GET_ADD_GOODS_URL = 'addGoods'
  // 超值加购
  static readonly GET_SNACK_SIZED_DEAL = 'getSnackSizedDeal'
  // 删除订单
  static readonly DELETE_ORDER_URL = 'deleteOrder'
  // 判断用户是否为新用户
  static readonly GET_IS_NEW_URL = 'getIsNew'
  // 获取华为支付信息
  static readonly GET_HUAWEI_PAY_INFO_URL = 'getHuaweiPayInfo'
  // 充值钱包
  static readonly RECHARGE_MONEY_URL = 'rechargeMoney'
  // 查询账单明细
  static readonly GET_RECHARGE_RECORD_URL = 'getRechargeRecord'
  // 检查积分兑换情况
  static readonly CHECK_POINT = 'checkPoint'
  /**
   * 门店相关
   */
  static readonly URL_STORE_BOOK_LIST = '/api/store/book/list'
  static readonly URL_STORE_QUEUE_LIST = '/api/store/queue/list'
  /**
   * 订单相关
   */
  static readonly URL_ORDER_LIST = '/api/order/book/list'
  static readonly URL_ORDER_BOOK_CREATE = '/api/order/book/create'
  static readonly URL_ORDER_BOOK_CANCEL = '/api/order/book/cancel'
  static readonly URL_ORDER_QUEUE_CREATE = '/api/order/queue/create'
  static readonly URL_ORDER_QUEUE_CANCEL = '/api/order/queue/cancel'
  static readonly URL_ORDER_QUEUE_REFRESH = '/api/order/queue/refresh'
  static readonly URL_USER_POINT_LIST = '/api/user/point/list'
}

export const WEEK_DAYS = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六']