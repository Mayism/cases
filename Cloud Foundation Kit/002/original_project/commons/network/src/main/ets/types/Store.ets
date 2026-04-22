export class PreloadResponse {
  appInfo?: AppInfoResp
  tableList?: Array<TableInfoResp>
}

export interface AppInfoResp {
  // banner图
  bannerList: string[]
  // 图片域名
  imgBaseUrl: string
  // 客服电话
  telephone: string
}

export interface StoreInfoResp {
  id: string
  name: string
  address: string
  // 营业起止时间
  time1: string
  time2: string
  tel: string
  // 促销信息
  announcement: string
  logo: string
  // 位置坐标
  coordinates: string
  // 营业执照
  businessLicense: string
  // 食品经营许可证
  foodLicense: string
  environment: Array<string>
  isRest: number
  // 新用户满减金额
  xyhMoney: number
  // 备注口味：多个以;；分隔
  taste: string
  // 活动满减
  reductionList: Array<ReductionResp>
  // 充值档次
  rechargeTier: Array<RechargeTier>
  // 包间
  privateRoom: Array<number>,

  // 大厅
  diningHall: Array<number>,

  // 餐桌最大人数
  maxCount: number,

  // 是否排队
  needQueue: boolean,

  // 排队信息
  queueInfo: StoreQueueInfoResp,
}

export interface TableInfoResp {
  id: string
  // 餐桌名称
  tableName: string
  // 餐桌类型
  typeName: string
  // 餐桌人数
  num: number
  // 餐桌状态
  status: number
}

export interface ReductionResp {
  id: string
  name: string
  full: number
  reduction: number
  type: number
}

export interface RechargeTier {
  id: string
  name: string
  // 支付金额
  payMoney: number
  // 充值金额
  realMoney: number
  desc: string
  type: number
}

export interface StoreQueueInfoResp {
  used: number;
  min: number;
  mid: number;
  max: number;
  now: number;
}