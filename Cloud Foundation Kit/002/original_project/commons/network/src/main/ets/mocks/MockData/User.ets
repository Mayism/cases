import { Decimal } from '@kit.ArkTS'
import { HelpMsgResp, PointRecord, RechargeRecord, UserInfoResp } from '../../types/User'
import { rechargeTierList } from './Store'

const userInfo: UserInfoResp = {
  id: '1',
  name: '华为用户',
  img: '',
  openId: '',
  unionId: '',
  storeId: '',
  totalScore: 288,
  lockedScore: 0,
  wallet: 200,
  userTel: '',
}

const rechargeRecordList: RechargeRecord[] = []

export const getUserInfoResp = (isRelative: boolean): UserInfoResp => {
  if (isRelative) {
    userInfo.userTel = '10000002222'
  }
  return userInfo
}

export const getOpenLogin = (): UserInfoResp => {
  userInfo.userTel = '10000002222'
  return userInfo
}

export const getCloseLogin = (): UserInfoResp => {
  userInfo.userTel = ''
  return userInfo
}

export const rechargeMoney = (rechargeTierId: string): number => {
  let rechargeTier = rechargeTierList.find(item => item.id === rechargeTierId)
  if (rechargeTier) {
    userInfo.wallet = new Decimal(userInfo.wallet).add(rechargeTier.realMoney).toNumber()
    insertRechargeRecord(rechargeTier.realMoney, 1)
    return 1
  }
  return 2
}

export const consumeMoney = (money: number): number => {
  userInfo.wallet = userInfo.wallet > money ? new Decimal(userInfo.wallet).sub(money).toNumber() : 0; // 消费记录
  insertRechargeRecord(money, 2)
  return 1
}

export const insertRechargeRecord = (rechargeMoney: number, recordType: number) => {
  let rechargeRecord: RechargeRecord = {
    id: `${rechargeRecordList.length + 1}`,
    recordType,
    rechargeMoney,
    balance: userInfo.wallet,
    time: new Date().getTime(),
    statue: 0,
  }
  return rechargeRecordList.push(rechargeRecord)
}

export const getRechargeRecord = (): RechargeRecord[] => {
  return rechargeRecordList
}

export const getHelp = (): Array<HelpMsgResp> => {
  const helpJson: string =
    '[{"id": "1","question": "我们如何收集和使用您的个人信息","answer": "欢迎您使用我们的餐饮模板，您的信任对我们很重要，我们将严格遵守法律法规要求的安全保护措施，保护您的个人信息安全可控。"}]'
  return JSON.parse(helpJson);
}

const pointList: Array<PointRecord> = [{
  id: 1,
  action: 1,
  changePoint: 238,
  time: 1760062989000,
}, {
  id: 2,
  action: 1,
  changePoint: 150,
  time: 1760322189000,
}, {
  id: 3,
  action: 2,
  changePoint: 150,
  time: 1760562989000,
}, {
  id: 4,
  action: 1,
  changePoint: 50,
  time: 1760862989000,
}, {
  id: 5,
  action: 1,
  changePoint: 150,
  time: 1761162989000,
}, {
  id: 6,
  action: 2,
  changePoint: 150,
  time: new Date().getTime(),
}]

export const getPointList = (): Array<PointRecord> => {
  return pointList;
}

export const insertPointRecord = (point: PointRecord): void => {
  pointList.push(point);
  if (point.action === 1) {
    userInfo.totalScore = new Decimal(userInfo.totalScore).add(point.changePoint).toNumber()
  } else {
    userInfo.totalScore = new Decimal(userInfo.totalScore).sub(point.changePoint).toNumber()
    userInfo.lockedScore = new Decimal(userInfo.lockedScore || 0).sub(point.changePoint).toNumber()
  }
}

export const checkPoint = (): boolean => {
  return new Decimal(userInfo.totalScore).sub(userInfo.lockedScore || 0).toNumber() > 150
}

export const lockedPoint = (point: number): void => {
  userInfo.lockedScore = new Decimal(userInfo.lockedScore || 0).add(point).toNumber();
}

export const unlockedPoint = (point: number): void => {
  userInfo.lockedScore = new Decimal(userInfo.lockedScore || 0).sub(point).toNumber();
}
