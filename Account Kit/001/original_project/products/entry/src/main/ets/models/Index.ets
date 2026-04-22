import { GoodsResp, OrderGoodsResp, OrderInfoResp, OrderTableResp, SpecCatalogResp } from 'network'

export class DiscountModel {
  icon: ResourceStr
  content: ResourceStr

  constructor(icon: ResourceStr, content: ResourceStr) {
    this.icon = icon
    this.content = content
  }
}

export class PreorderLabel {
  id: number
  label: string
  check: boolean

  constructor(id: number, label: string, check: boolean) {
    this.id = id
    this.label = label
    this.check = check
  }
}

export class Goods implements GoodsResp {
  id: string = ''
  name: string = ''
  logo: string = ''
  bigImg: Array<string> = []
  // 现价
  money: number = 0
  // 原价
  money2: number = 0
  // 折扣
  discount: string = ''
  content: string = ''
  sales: number = 0
  // 是否有规格 1 无 2有规格 3套餐
  specType: number = 0
  details: string = ''
  num: number = 0
  isMust: number = 0
  spec: Array<SpecCatalogResp> = []
  // 餐盒费
  boxMoney: number = 0
}

@ObservedV2
export class OrderInfo implements OrderInfoResp {
  id: string = ''
  orderNum: string = ''
  time: string = ''
  payTime: string = ''
  money: number = 0
  reductionMoney: number = 0
  boxMoney: number = 0
  mjMoney: number = 0
  xyhMoney: number = 0
  note: string = ''
  payType: number = 0
  orderType: number = 1
  tableware: string = ''
  yhqMoney: number = 0
  couponId: string = ''
  redeemedPoint: boolean = false
  @Trace state: number = 0
  oid: string = ''
  storeTel: string = ''
  storeName: string = ''
  storeLogo: string = ''
  storeAddress: string = ''
  lat: string = ''
  lng: string = ''
  rechargeId: string = ''
  preorderTime: string = ''
  preorderPhone: string = ''
}

// 订单列表
@ObservedV2
export class MyOrderInfo {
  @Trace order: OrderInfo = new OrderInfo()
  goods: Array<OrderGoodsResp> = []
  table?: OrderTableResp
}

// 系统的分享参数模型
export interface ShareInfo {
  showShareMenu: boolean; // 当前页面是否允许分享，面板分享开关是否打开, 不填默认为不允许
  title?: string; // 系统分享面板标题，默认为元服务名称
  description?: string; // 系统分享面板简介，默认为元服务一句话描述
  previewUri?: string; // 分享图片缩略图，为本地文件uri，预留字段，不起作用
  parameters?: Object; // 开发者自定参数
  preview?: string; // 分享缩略图的base64编码，大小限制在32kb，太大会导致分享按钮置灰
}

/**
 * 扫码直达/AppLink跳转参数
 */
@ObservedV2
export class LinkScanModel {
  @Trace id: string = '';
  @Trace pageUrl: string = ''
}