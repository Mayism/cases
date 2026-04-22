import { Reduction, StoreInfo } from 'common';
import { GoodsResp, StoreInfoResp } from 'network';
import { Goods } from '../models/Index';

export function goodsInfoMapper(goodsResp: GoodsResp): Goods {
  let goods: Goods = new Goods()
  goods.id = goodsResp.id;
  goods.name = goodsResp.name;
  goods.logo = goodsResp.logo;
  goods.bigImg = goodsResp.bigImg;
  goods.money = goodsResp.money;
  goods.money2 = goodsResp.money2;
  goods.discount = goodsResp.discount;
  goods.content = goodsResp.content;
  goods.sales = goodsResp.sales;
  goods.specType = goodsResp.specType;
  goods.details = goodsResp.details;
  goods.num = goodsResp.num;
  goods.isMust = goodsResp.isMust;
  goods.spec = goodsResp.spec;
  goods.boxMoney = goodsResp.boxMoney
  return goods;
}

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