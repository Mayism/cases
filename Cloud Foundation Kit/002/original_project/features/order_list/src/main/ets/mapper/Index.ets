import { GoodsOfOrder, PackageSpec } from 'base_ui';
import { MyOrderResp, OrderGoodsResp } from 'network';
import { MyOrderInfo, OrderInfo } from '../models/Index';

export function orderGoodsMapper(orderGoodsList?: Array<OrderGoodsResp>) {
  let goodsList: Array<GoodsOfOrder> = []
  if (!orderGoodsList?.length) {
    return goodsList
  }
  return orderGoodsList.map(item => {
    let goods: GoodsOfOrder = new GoodsOfOrder()
    goods.id = item.id
    goods.name = item.name
    goods.logo = item.logo
    goods.money = item.money
    goods.money2 = item.money2
    goods.discount = item.discount
    goods.num = item.num
    goods.isMust = item.isMust
    goods.specType = item.specType
    goods.spec = item.spec
    goods.combination = item.combination.map(packageSpec => new PackageSpec(packageSpec.specName, packageSpec.specNum))
    return item
  })
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
  orderInfo.storeName = myOrderResp.order.storeName
  orderInfo.storeLogo = myOrderResp.order.storeLogo
  orderInfo.storeTel = myOrderResp.order.storeTel
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