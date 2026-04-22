import { MyCarResp, StoreInfoResp, StoreQueueInfoResp } from 'network'
import { CarGoodsInfo, MyCar, StoreInfo, StoreQueueInfo } from '../models/StorageModel'

export function myCarMapper(myCarResp: MyCarResp) {
  let myCar: MyCar = new MyCar(myCarResp.boxMoney, myCarResp.num, myCarResp.money)
  myCar.goodsList = myCarResp.goodsList.map(item => {
    let carGood = new CarGoodsInfo()
    carGood.id = item.id
    carGood.goodsId = item.goodsId
    carGood.name = item.name
    carGood.logo = item.logo
    carGood.num = item.num
    carGood.specType = item.specType
    carGood.spec = item.spec
    carGood.combination = item.combination
    carGood.discount = item.discount
    carGood.money = item.money
    carGood.money2 = item.money2
    carGood.boxMoney = item.boxMoney
    carGood.isMust = item.isMust
    return carGood
  })
  return myCar
}

export function getStoreQueueInfoMapper(storeQueueInfoResp: StoreQueueInfoResp) {
  let storeQueueInfo = new StoreQueueInfo()
  storeQueueInfo.used = storeQueueInfoResp.used
  storeQueueInfo.min = storeQueueInfoResp.min
  storeQueueInfo.mid = storeQueueInfoResp.mid
  storeQueueInfo.max = storeQueueInfoResp.max
  storeQueueInfo.now = storeQueueInfoResp.now
  return storeQueueInfo

}

export function getStoreInfoMapper(storeInfo: StoreInfoResp) {
  let storeInfoTemp = new StoreInfo()
  storeInfoTemp.id = storeInfo.id
  storeInfoTemp.name = storeInfo.name
  storeInfoTemp.address = storeInfo.address
  storeInfoTemp.time1 = storeInfo.time1
  storeInfoTemp.time2 = storeInfo.time2
  storeInfoTemp.tel = storeInfo.tel
  storeInfoTemp.announcement = storeInfo.announcement
  storeInfoTemp.logo = storeInfo.logo
  storeInfoTemp.coordinates = storeInfo.coordinates
  storeInfoTemp.businessLicense = storeInfo.businessLicense
  storeInfoTemp.foodLicense = storeInfo.foodLicense
  storeInfoTemp.environment = storeInfo.environment
  storeInfoTemp.isRest = storeInfo.isRest
  storeInfoTemp.xyhMoney = storeInfo.xyhMoney
  storeInfoTemp.taste = storeInfo.taste
  storeInfoTemp.reductionList = storeInfo.reductionList
  storeInfoTemp.rechargeTier = storeInfo.rechargeTier
  storeInfoTemp.maxCount = storeInfo.maxCount
  storeInfoTemp.needQueue = storeInfo.needQueue
  storeInfoTemp.queueInfo = getStoreQueueInfoMapper(storeInfo.queueInfo)
  storeInfoTemp.privateRoom = storeInfo.privateRoom
  storeInfoTemp.diningHall = storeInfo.diningHall
  return storeInfoTemp
}

export function getStoreQueueInfoRespMapper(storeQueueInfo: StoreQueueInfo) {
  let storeQueueInfoResp: StoreQueueInfoResp = {
    used: storeQueueInfo.used,
    min: storeQueueInfo.min,
    mid: storeQueueInfo.mid,
    max: storeQueueInfo.max,
    now: storeQueueInfo.now,
  }
  return storeQueueInfoResp

}

export function getStoreInfoRespMapper(storeInfo: StoreInfo | undefined) {
  if (!storeInfo) {
    return {} as StoreInfoResp
  }
  let storeInfoTemp: StoreInfoResp = {
    id: storeInfo.id,
    name: storeInfo.name,
    address: storeInfo.address,
    tel: storeInfo.tel,
    announcement: storeInfo.announcement,
    logo: storeInfo.logo,
    coordinates: storeInfo.coordinates,
    maxCount: storeInfo.maxCount,
    needQueue: storeInfo.needQueue,
    queueInfo: getStoreQueueInfoRespMapper(storeInfo.queueInfo),
    privateRoom: storeInfo.privateRoom,
    diningHall: storeInfo.diningHall,
  } as StoreInfoResp
  return storeInfoTemp
}