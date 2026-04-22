export interface UserInfoResp {
  id: string
  name: string
  img: string
  openId: string
  unionId: string
  storeId: string
  totalScore: number
  lockedScore?: number
  wallet: number
  userTel: string
}

export interface HelpMsgResp {
  id: string
  question: string
  answer: string
}

export interface RechargeRecord {
  id: string
  // 金额变动类型 1：充值  2：消费
  recordType: number
  // 变动金额
  rechargeMoney: number
  // 当前余额
  balance: number
  // 变动时间
  time: number
  // 充值状态
  statue: number
}

export interface PointRecord {
  id: number
  // 积分变动类型 1：下单  2：兑换
  action: number
  // 变动积分
  changePoint: number
  // 变动时间
  time: number
}