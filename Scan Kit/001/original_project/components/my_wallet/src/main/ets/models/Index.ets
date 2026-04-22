// 充值档次
export class RechargeTier {
  id: string = ''
  name: string = ''
  payMoney: number = 0
  realMoney: number = 0
  desc: string = ''
  type: number = 0
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
}

export enum WalletRecordType {
  RECHARGE = 1,
  CONSUME = 2
}