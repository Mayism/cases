import { Reduction, StoreInfo } from 'common';
import { MyOrderResp, StoreInfoResp } from 'network';
import { MyOrderInfo, OrderInfo } from '../models/Index';

export function storeInfoMapper(storeInfoResp: StoreInfoResp) {
  let reductionList: Array<Reduction> =
    storeInfoResp.reductionList.map(item => new Reduction(item.id, item.name, item.full, item.reduction))
  let storeInfo: StoreInfo = new StoreInfo()
  storeInfo.id = storeInfoResp.id;
  storeInfo.name = storeInfoResp.name;
  storeInfo.address = storeInfoResp.address;
  storeInfo.time1 = storeInfoResp.time1;
  storeInfo.time2 = storeInfoResp.time2;
  storeInfo.tel = storeInfoResp.tel;
  storeInfo.announcement = storeInfoResp.announcement;
  storeInfo.logo = storeInfoResp.logo;
  storeInfo.coordinates = storeInfoResp.coordinates;
  storeInfo.businessLicense = storeInfoResp.businessLicense;
  storeInfo.foodLicense = storeInfoResp.foodLicense;
  storeInfo.environment = storeInfoResp.environment;
  storeInfo.isRest = storeInfoResp.isRest;
  storeInfo.xyhMoney = storeInfoResp.xyhMoney;
  storeInfo.taste = storeInfoResp.taste
  storeInfo.reductionList = reductionList
  storeInfo.rechargeTier = storeInfoResp.rechargeTier
  return storeInfo;
}


export function orderInfoMapper(myOrderResp: MyOrderResp): MyOrderInfo {
  let orderInfo: OrderInfo = new OrderInfo()
  orderInfo.id = myOrderResp.order.id
  orderInfo.orderNum = myOrderResp.order.orderNum
  orderInfo.time = myOrderResp.order.time
  orderInfo.payTime = myOrderResp.order.payTime
  orderInfo.money = myOrderResp.order.money
  orderInfo.reductionMoney = myOrderResp.order.reductionMoney
  orderInfo.boxMoney = myOrderResp.order.boxMoney
  orderInfo.mjMoney = myOrderResp.order.mjMoney
  orderInfo.xyhMoney = myOrderResp.order.xyhMoney
  orderInfo.note = myOrderResp.order.note
  orderInfo.payType = myOrderResp.order.payType
  orderInfo.orderType = myOrderResp.order.orderType
  orderInfo.tableware = myOrderResp.order.tableware
  orderInfo.yhqMoney = myOrderResp.order.yhqMoney
  orderInfo.couponId = myOrderResp.order.couponId
  orderInfo.state = myOrderResp.order.state
  orderInfo.oid = myOrderResp.order.oid
  orderInfo.storeTel = myOrderResp.order.storeTel
  orderInfo.storeName = myOrderResp.order.storeName
  orderInfo.storeLogo = myOrderResp.order.storeLogo
  orderInfo.storeAddress = myOrderResp.order.storeAddress
  orderInfo.lat = myOrderResp.order.lat
  orderInfo.lng = myOrderResp.order.lng
  orderInfo.preorderTime = myOrderResp.order.preorderTime
  orderInfo.preorderPhone = myOrderResp.order.preorderPhone
  let myOrderInfo = new MyOrderInfo()
  myOrderInfo.order = orderInfo
  myOrderInfo.goods = myOrderResp.goods
  myOrderInfo.table = myOrderResp.table
  return myOrderInfo
}