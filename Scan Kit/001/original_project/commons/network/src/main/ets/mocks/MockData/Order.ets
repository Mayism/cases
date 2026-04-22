import { Decimal } from '@kit.ArkTS'
import { PointRecord } from '../../../../../Index'
import {
  CarGoodsInfoResp,
  CouponItem,
  CouponRule,
  DishesTypeResp,
  GoodsResp,
  GoodsSpecResp,
  MyCarResp,
  MyOrderResp,
  OffsetInfo,
  OrderGoodsResp,
  OrderInfoResp,
  OrderTableResp,
  SpecCatalogResp,
} from '../../types/Order'
import { AddCarReq, AddDnOrderReq, CommonReq, GoodsReq, MyOrderReq } from '../../types/Request'
import { getTableInfoResp, rechargeTierList } from './Store'
import { consumeMoney, getPointList, insertPointRecord, lockedPoint, rechargeMoney, unlockedPoint } from './User'

const specJson1 =
  `[{"specId":"1","specName":"奶油","specValId":"11","specVal":[{"specValId":"11","specValName":"动物奶油","specValLogo":"","specValNum":"1"},{"specValId":"12","specValName":"植物奶油","specValLogo":"","specValNum":"1"}]},{"specId":"2","specName":"糖类选择","specValId":"22","specVal":[{"specValId":"21","specValName":"蔗糖","specValLogo":"","specValNum":"1"},{"specValId":"22","specValName":"赤鲜糖醇（0糖）","specValLogo":"","specValNum":"1"}]},{"specId":"3","specName":"尺寸","specValId":"31","specVal":[{"specValId":"31","specValName":"6寸","specValLogo":"","specValNum":"1"},{"specValId":"32","specValName":"9寸","specValLogo":"","specValNum":"1"},{"specValId":"33","specValName":"12寸","specValLogo":"","specValNum":"1"}]}]`
const specJson2 =
  `[{"specId":"1","specName":"招牌菜品  （必选）","specValId":"11","specVal":[{"specValId":"11","specValName":"黄金炙烤谷饲战斧牛排","specValLogo":"CateringOrderTemplate/good_spec_logo1.png","specValNum":"2"}]},{"specId":"2","specName":"特色配菜 3选 1","specValId":"23","specVal":[{"specValId":"21","specValName":"蔬菜沙拉","specValLogo":"CateringOrderTemplate/good_spec_logo2.png","specValNum":"1"},{"specValId":"22","specValName":"酸橘汁配虾仁和橙子双拼","specValLogo":"CateringOrderTemplate/good_spec_logo3.png","specValNum":"1"},{"specValId":"23","specValName":"豌豆炒虾仁","specValLogo":"CateringOrderTemplate/good_spec_logo4.png","specValNum":"1"}]},{"specId":"3","specName":"主食  2选 1","specValId":"32","specVal":[{"specValId":"31","specValName":"意大利面","specValLogo":"CateringOrderTemplate/good_spec_logo5.png","specValNum":"2"},{"specValId":"32","specValName":"披萨","specValLogo":"CateringOrderTemplate/good_spec_logo6.png","specValNum":"1"}]},{"specId":"4","specName":"甜品  4选 1","specValId":"43","specVal":[{"specValId":"41","specValName":"蜂蜜柚子茶","specValLogo":"CateringOrderTemplate/good_spec_logo7.png","specValNum":"1"},{"specValId":"42","specValName":"鲜榨果汁（口味备注，默认随机）...","specValLogo":"CateringOrderTemplate/good_spec_logo8.png","specValNum":"2"},{"specValId":"43","specValName":"冰橙美式咖啡","specValLogo":"CateringOrderTemplate/good_spec_logo9.png","specValNum":"2"},{"specValId":"44","specValName":"柠檬红茶","specValLogo":"CateringOrderTemplate/good_spec_logo10.png","specValNum":"1"}]}]`
const goodsMustJson =
  `{"id": "99","name": "纸巾","logo": "CateringOrderTemplate/good_logo_cutlery.png","bigImg": ["CateringOrderTemplate/good_logo_cutlery.png"],"money": 2,"money2": 2,"content": "纸巾","sales": 200,"specType": 1,"details": "餐具","num": 200,"isMust": 1,"spec": [],"boxMoney": 0  }`
const goods1: GoodsResp = {
  id: '1',
  name: '圆形面包',
  logo: 'CateringOrderTemplate/good_logo1.png',
  bigImg: ['CateringOrderTemplate/good_logo1-1.png', 'CateringOrderTemplate/good_logo1-2.png',
    'CateringOrderTemplate/good_logo1-3.png'],
  money: 16.4,
  money2: 16.4,
  content: '圆形奶油面包',
  sales: 200,
  specType: 2,
  details: 'CateringOrderTemplate/good_logo1-1.png',
  num: 200,
  isMust: 0,
  spec: [],
  boxMoney: 1,
  discount: '',
}
const goods2: GoodsResp = {
  id: '2',
  name: '冰橙美式咖啡',
  logo: 'CateringOrderTemplate/good_logo2.png',
  bigImg: ['CateringOrderTemplate/good_logo2.png'],
  money: 25,
  money2: 25,
  content: '冰橙美式咖啡',
  sales: 200,
  specType: 1,
  details: 'CateringOrderTemplate/good_logo2.png',
  num: 200,
  isMust: 0,
  spec: [],
  boxMoney: 1,
  discount: '',
}
const goods3: GoodsResp = {
  id: '3',
  name: '四色马卡龙',
  logo: 'CateringOrderTemplate/good_logo2.png',
  bigImg: ['CateringOrderTemplate/good_logo2.png'],
  money: 58,
  money2: 58,
  content: '四色马卡龙',
  sales: 200,
  specType: 1,
  details: 'CateringOrderTemplate/good_logo2.png',
  num: 200,
  isMust: 0,
  spec: [],
  boxMoney: 1,
  discount: '',
}
const goods4: GoodsResp = {
  id: '4',
  name: '圆形面包',
  logo: 'CateringOrderTemplate/good_logo1.png',
  bigImg: ['CateringOrderTemplate/good_logo1.png'],
  money: 13,
  money2: 13,
  content: '圆形奶油面包',
  sales: 200,
  specType: 1,
  details: 'CateringOrderTemplate/good_logo1.png',
  num: 200,
  isMust: 0,
  spec: [],
  boxMoney: 1,
  discount: '',
}
const goodsPkg1: GoodsResp = {
  id: '5',
  name: '初见欢双人餐',
  logo: 'CateringOrderTemplate/good_pkg_logo1.png',
  bigImg: ['CateringOrderTemplate/good_pkg_logo1.png'],
  money: 75.4,
  money2: 116.0,
  discount: '6.5',
  content: '周一至周日|免预约|随时退',
  sales: 200,
  specType: 3,
  details: '',
  num: 200,
  isMust: 0,
  spec: [],
  boxMoney: 1,
}
const goodsPkg2: GoodsResp = {
  id: '6',
  name: '招牌三文鱼寿司单人餐',
  logo: 'CateringOrderTemplate/good_pkg_logo2.png',
  bigImg: ['CateringOrderTemplate/good_pkg_logo2.png'],
  money: 59.9,
  money2: 92.2,
  discount: '6.5',
  content: '周一至周日|免预约|随时退',
  sales: 200,
  specType: 3,
  details: '',
  num: 200,
  isMust: 0,
  spec: [],
  boxMoney: 1,
}
const goodsPkg3: GoodsResp = {
  id: '7',
  name: '大吉大利，今晚吃鸡双人吃鸡套餐',
  logo: 'CateringOrderTemplate/good_pkg_logo3.png',
  bigImg: ['CateringOrderTemplate/good_pkg_logo3.png'],
  money: 59.9,
  money2: 92.2,
  discount: '6.5',
  content: '圆形奶油面包',
  sales: 200,
  specType: 3,
  details: '',
  num: 200,
  isMust: 0,
  spec: [],
  boxMoney: 1,
}
const goods5: GoodsResp = {
  id: '8',
  name: '圆形面包',
  logo: 'CateringOrderTemplate/good_logo1.png',
  bigImg: ['CateringOrderTemplate/good_logo1-1.png', 'CateringOrderTemplate/good_logo1-2.png',
    'CateringOrderTemplate/good_logo1-3.png'],
  money: 5,
  money2: 16.4,
  content: '圆形奶油面包',
  sales: 200,
  specType: 4,
  details: 'CateringOrderTemplate/good_logo1-1.png',
  num: 200,
  isMust: 0,
  spec: [],
  boxMoney: 1,
  discount: '',
}
const goods6: GoodsResp = {
  id: '9',
  name: '冰橙美式咖啡',
  logo: 'CateringOrderTemplate/good_logo2.png',
  bigImg: ['CateringOrderTemplate/good_logo2.png'],
  money: 5,
  money2: 25,
  content: '冰橙美式咖啡',
  sales: 200,
  specType: 4,
  details: 'CateringOrderTemplate/good_logo2.png',
  num: 200,
  isMust: 0,
  spec: [],
  boxMoney: 1,
  discount: '',
}

class CommonRules {
  // 满减-低
  static readonly RULE1_LOW: CouponRule = {
    amountRuleNo: '1',
    amountRuleDesc: '满减',
    discountMode: '0',
    discountType: '0',
    fullAmount: '1000',
    discountAmount: '100',
    discountCoefficient: '',
  }
  // 满减-高
  static readonly RULE1_HIGH: CouponRule = {
    amountRuleNo: '1',
    amountRuleDesc: '满减',
    discountMode: '0',
    discountType: '0',
    fullAmount: '2000',
    discountAmount: '250',
    discountCoefficient: '',
  }
  // 立减
  static readonly RULE2: CouponRule = {
    amountRuleNo: '2',
    amountRuleDesc: '立减',
    discountMode: '0',
    discountType: '1',
    fullAmount: '',
    discountAmount: '15',
    discountCoefficient: '',
  }
}

// 核销单 === 已使用
const OFFSET_INFO: OffsetInfo = {
  offsetID: '',
  couponCollectionTime: '',
  couponOffsetTime: '',
  offsetOrder: '',
  couponStatus: '',
}
const couponsOri: CouponItem[] =
  [
    // 生效-待使用-活动期间-满减-低
    {
      couponID: '1',
      couponName: '优惠券名称',
      validityPeriodMode: '0',
      startTime: '2025-1-1',
      endTime: '2035-1-1',
      status: '2',
      amountRule: CommonRules.RULE1_LOW,
      distributionQuantity: '-1',
      repeatedPickup: '0',
      categoryGroup: '',
      brandGroup: '',
      catalogGroup: '',
      productGroup: '',
      recipientLimits: '2',
      specifiedSubGroup: [],
      specifiedPickupScenario: [{ key: 0, value: '新用户注册' }],
      createdTime: '',
      lastUpdateTime: '',
    },
    // 生效-待使用-活动期间-满减-高
    {
      couponID: '100',
      couponName: '优惠券名称',
      validityPeriodMode: '0',
      startTime: '2025-1-1',
      endTime: '2035-1-1',
      status: '2',
      amountRule: CommonRules.RULE1_HIGH,
      distributionQuantity: '-1',
      repeatedPickup: '0',
      categoryGroup: '',
      brandGroup: '',
      catalogGroup: '',
      productGroup: '',
      recipientLimits: '2',
      specifiedSubGroup: [],
      specifiedPickupScenario: [{ key: 0, value: '新用户注册' }],
      createdTime: '',
      lastUpdateTime: '',
    },
    // 生效-待使用-活动期间-立减
    {
      couponID: '2',
      couponName: '优惠券名称',
      validityPeriodMode: '0',
      startTime: '2025-1-1',
      endTime: '2035-1-1',
      status: '2',
      amountRule: CommonRules.RULE2,
      distributionQuantity: '-1',
      repeatedPickup: '0',
      categoryGroup: '',
      brandGroup: '',
      catalogGroup: '',
      productGroup: '',
      recipientLimits: '2',
      specifiedSubGroup: [],
      specifiedPickupScenario: [{ key: 0, value: '新用户注册' }],
      createdTime: '',
      lastUpdateTime: '',
    },
    // 生效-待使用-活动期前-满减
    {
      couponID: '4',
      couponName: '优惠券名称',
      validityPeriodMode: '0',
      startTime: '2030-1-1',
      endTime: '2035-1-1',
      status: '2',
      amountRule: CommonRules.RULE1_LOW,
      distributionQuantity: '-1',
      repeatedPickup: '0',
      categoryGroup: '',
      brandGroup: '',
      catalogGroup: '',
      productGroup: '',
      recipientLimits: '2',
      specifiedSubGroup: [],
      specifiedPickupScenario: [{ key: 0, value: '新用户注册' }],
      createdTime: '',
      lastUpdateTime: '',
    },
    // 生效-待使用-活动期前-立减
    {
      couponID: '5',
      couponName: '优惠券名称',
      validityPeriodMode: '0',
      startTime: '2030-1-1',
      endTime: '2035-1-1',
      status: '2',
      amountRule: CommonRules.RULE2,
      distributionQuantity: '-1',
      repeatedPickup: '0',
      categoryGroup: '',
      brandGroup: '',
      catalogGroup: '',
      productGroup: '',
      recipientLimits: '2',
      specifiedSubGroup: [],
      specifiedPickupScenario: [{ key: 0, value: '新用户注册' }],
      createdTime: '',
      lastUpdateTime: '',
    },
    // 生效-已使用-满减
    {
      couponID: '7',
      couponName: '优惠券名称',
      validityPeriodMode: '0',
      startTime: '2025-1-1',
      endTime: '2035-1-1',
      status: '2',
      amountRule: CommonRules.RULE1_LOW,
      distributionQuantity: '-1',
      repeatedPickup: '0',
      categoryGroup: '',
      brandGroup: '',
      catalogGroup: '',
      productGroup: '',
      recipientLimits: '2',
      specifiedSubGroup: [],
      specifiedPickupScenario: [{ key: 0, value: '新用户注册' }],
      createdTime: '',
      lastUpdateTime: '',
    },
    // 生效-已使用-立减
    {
      couponID: '8',
      couponName: '优惠券名称',
      validityPeriodMode: '0',
      startTime: '2025-1-1',
      endTime: '2035-1-1',
      status: '2',
      amountRule: CommonRules.RULE2,
      distributionQuantity: '-1',
      repeatedPickup: '0',
      categoryGroup: '',
      brandGroup: '',
      catalogGroup: '',
      productGroup: '',
      recipientLimits: '2',
      specifiedSubGroup: [],
      specifiedPickupScenario: [{ key: 0, value: '新用户注册' }],
      createdTime: '',
      lastUpdateTime: '',
    },
    // 生效-已过期-满减
    {
      couponID: '10',
      couponName: '优惠券名称',
      validityPeriodMode: '0',
      startTime: '2025-1-1',
      endTime: '2025-2-1',
      status: '2',
      amountRule: CommonRules.RULE1_LOW,
      distributionQuantity: '-1',
      repeatedPickup: '0',
      categoryGroup: '',
      brandGroup: '',
      catalogGroup: '',
      productGroup: '',
      recipientLimits: '2',
      specifiedSubGroup: [],
      specifiedPickupScenario: [{ key: 0, value: '新用户注册' }],
      createdTime: '',
      lastUpdateTime: '',
    },
    // 生效-已过期-立减
    {
      couponID: '11',
      couponName: '优惠券名称',
      validityPeriodMode: '0',
      startTime: '2025-1-1',
      endTime: '2025-2-1',
      status: '2',
      amountRule: CommonRules.RULE2,
      distributionQuantity: '-1',
      repeatedPickup: '0',
      categoryGroup: '',
      brandGroup: '',
      catalogGroup: '',
      productGroup: '',
      recipientLimits: '2',
      specifiedSubGroup: [],
      specifiedPickupScenario: [{ key: 0, value: '新用户注册' }],
      createdTime: '',
      lastUpdateTime: '',
    },
  ]
const myCoupons: CouponItem[] = [
  // 生效-待使用-活动期前-满减
  {
    couponID: '4',
    couponName: '优惠券名称',
    validityPeriodMode: '0',
    startTime: '2030-1-1',
    endTime: '2035-1-1',
    status: '2',
    amountRule: CommonRules.RULE1_LOW,
    distributionQuantity: '-1',
    repeatedPickup: '0',
    categoryGroup: '',
    brandGroup: '',
    catalogGroup: '',
    productGroup: '',
    recipientLimits: '2',
    specifiedSubGroup: [],
    specifiedPickupScenario: [{ key: 0, value: '新用户注册' }],
    createdTime: '',
    lastUpdateTime: '',
  },
  // 生效-已使用-满减
  {
    couponID: '7',
    couponName: '优惠券名称',
    validityPeriodMode: '0',
    startTime: '2025-1-1',
    endTime: '2035-1-1',
    status: '2',
    amountRule: CommonRules.RULE1_LOW,
    distributionQuantity: '-1',
    repeatedPickup: '0',
    categoryGroup: '',
    brandGroup: '',
    catalogGroup: '',
    productGroup: '',
    recipientLimits: '2',
    specifiedSubGroup: [],
    specifiedPickupScenario: [{ key: 0, value: '新用户注册' }],
    createdTime: '',
    lastUpdateTime: '',
    offsetInfo: OFFSET_INFO,
  },
  // 生效-已使用-立减
  {
    couponID: '8',
    couponName: '优惠券名称',
    validityPeriodMode: '0',
    startTime: '2025-1-1',
    endTime: '2035-1-1',
    status: '2',
    amountRule: CommonRules.RULE2,
    distributionQuantity: '-1',
    repeatedPickup: '0',
    categoryGroup: '',
    brandGroup: '',
    catalogGroup: '',
    productGroup: '',
    recipientLimits: '2',
    specifiedSubGroup: [],
    specifiedPickupScenario: [{ key: 0, value: '新用户注册' }],
    createdTime: '',
    lastUpdateTime: '',
    offsetInfo: OFFSET_INFO,
  },
  // 生效-已过期-满减
  {
    couponID: '10',
    couponName: '优惠券名称',
    validityPeriodMode: '0',
    startTime: '2025-1-1',
    endTime: '2025-2-1',
    status: '2',
    amountRule: CommonRules.RULE1_LOW,
    distributionQuantity: '-1',
    repeatedPickup: '0',
    categoryGroup: '',
    brandGroup: '',
    catalogGroup: '',
    productGroup: '',
    recipientLimits: '2',
    specifiedSubGroup: [],
    specifiedPickupScenario: [{ key: 0, value: '新用户注册' }],
    createdTime: '',
    lastUpdateTime: '',
  },
  // 生效-已过期-立减
  {
    couponID: '11',
    couponName: '优惠券名称',
    validityPeriodMode: '0',
    startTime: '2025-1-1',
    endTime: '2025-2-1',
    status: '2',
    amountRule: CommonRules.RULE2,
    distributionQuantity: '-1',
    repeatedPickup: '0',
    categoryGroup: '',
    brandGroup: '',
    catalogGroup: '',
    productGroup: '',
    recipientLimits: '2',
    specifiedSubGroup: [],
    specifiedPickupScenario: [{ key: 0, value: '新用户注册' }],
    createdTime: '',
    lastUpdateTime: '',
  }]

export const getCouponsResp = (): Array<CouponItem> => {
  return couponsOri
}

export const getLqCoupons = (params: CommonReq) => {
  let coupon = getCouponsResp().find(item => item.couponID === params.couponId)
  if (coupon) {
    myCoupons.push(coupon)
    return 1
  } else {
    return 0
  }

}

export const getMyCoupons = (): CouponItem[] => {
  return myCoupons
}

export const getIsNew = (): number => {
  // 1 新用户 2老用户
  return 1
}

export const getGoodsMust = (): GoodsResp => {
  return JSON.parse(goodsMustJson)
}

const getAllGoodsList = (): Array<GoodsResp> => {
  return [getGoodsMust(), goods1, goods2, goods3, goods4, goods5, goods6, goodsPkg1, goodsPkg2, goodsPkg3]
}


export const getGoodsSpec = (): Array<SpecCatalogResp> => {
  let goodsSpecList: SpecCatalogResp[] = JSON.parse(specJson1) as SpecCatalogResp[]
  return goodsSpecList
}

const getGoodsList = (): Array<GoodsResp> => {
  const goodsList: Array<GoodsResp> = [goods1, goods2, goods3, goods4]
  return goodsList
}

const getGoodPkgList = (): Array<GoodsResp> => {
  const goodsList: Array<GoodsResp> = [goodsPkg1, goodsPkg2, goodsPkg3]
  return goodsList
}

export const getDishesList = (): Array<DishesTypeResp> => {
  const dishesList: Array<DishesTypeResp> =
    [{ id: '1', typeName: '热销', goods: getGoodsList() }, { id: '2', typeName: '新品推荐', goods: getGoodsList() },
      { id: '3', typeName: '美味套餐', goods: getGoodPkgList() }, { id: '4', typeName: '甜点', goods: getGoodsList() },
      { id: '5', typeName: '风味套餐集结号', goods: getGoodPkgList() },
      { id: '6', typeName: '必选菜品', goods: [getGoodsMust()] },
      { id: '7', typeName: '菜单名称1', goods: getGoodsList() },
      { id: '8', typeName: '菜单名称2', goods: getGoodsList() },
      { id: '9', typeName: '菜单名称3', goods: getGoodsList() },
      { id: '10', typeName: '菜单名称4', goods: getGoodsList() },
      { id: '11', typeName: '菜单名称5', goods: getGoodsList() },
      { id: '12', typeName: '菜单名称6', goods: getGoodsList() }]
  return dishesList
}

export const getGoodsInfoResp = (goodsId: string): GoodsResp | undefined => {
  let goods = getAllGoodsList().find(item => item.id === goodsId)
  if (goods?.specType === 2) {
    let spec = JSON.parse(specJson1) as SpecCatalogResp[]
    goods.spec = spec
  } else if (goods?.specType === 3) {
    let spec = JSON.parse(specJson2) as SpecCatalogResp[]
    goods.spec = spec
  }
  return goods
}

let myCar: MyCarResp = {
  boxMoney: 0,
  goodsList: [],
  num: 0,
  money: 0,
}
let myCarId: number = 0

export const cleanCar = () => {
  myCar.boxMoney = 0
  myCar.money = 0
  myCar.num = 0
  myCar.goodsList = []
  return 1
}

export const getMyCar = (): MyCarResp => {
  return myCar;
}

export const addCar = (params: AddCarReq) => {
  let goods = getAllGoodsList().find(item => item.id === params.goodsId)
  let carGoodTemp = myCar.goodsList?.find(item => item.goodsId === params.goodsId && item.spec === params.spec)
  if (carGoodTemp) {
    carGoodTemp.num = new Decimal(carGoodTemp.num || 0).add(new Decimal(params.num!)).toNumber()
    myCar.money = new Decimal(myCar.money || 0).add(new Decimal(params.money!).mul(params.num!)).toNumber()
  } else {
    let carGood: CarGoodsInfoResp = {
      id: `${myCarId}`,
      goodsId: params.goodsId,
      num: params.num,
      specType: params.specType,
      spec: params.spec,
      combination: params.combination,
      money: params.money,
      money2: goods?.money2 || 0,
      discount: goods?.discount || '',
      boxMoney: params.boxMoney,
      logo: goods?.logo || '',
      name: goods?.name || '',
      isMust: goods?.isMust || 0,
    }
    if (!myCar.goodsList) {
      myCar.goodsList = []
    }
    myCar.goodsList?.push(carGood)
    let boxMoney = 0
    let money = 0
    myCar.goodsList?.forEach(item => {
      boxMoney = new Decimal(boxMoney).add(item.boxMoney || 0).toNumber()
      money = new Decimal(money).add(new Decimal(item.money || 0).mul(item.num || 0)).toNumber()
    })
    myCar.num = myCar.goodsList?.length
    myCar.boxMoney = boxMoney
    myCar.money = money
    myCarId++
  }

  return 1
}

export const getUpdCar = (params: CommonReq) => {
  let carGood = myCar.goodsList?.find(item => item.id === params.id)
  if (carGood) {
    let numOri: number = Number(carGood.num)
    // 购物车商品数量为0，返回失败
    if (numOri === 0) {
      return 0
    }
    let num = new Decimal(params.num).sub(numOri).toNumber()
    // 购物车商品数量为1，减少时需要移除商品
    if (numOri === 1 && num < 0) {
      myCar.goodsList = myCar.goodsList?.filter(item => item.id !== params.id)
    }
    carGood.num = params.num
    let boxMoney = 0
    let money = 0
    myCar.goodsList?.forEach(item => {
      boxMoney = new Decimal(boxMoney).add(item.boxMoney || 0).toNumber()
      money = new Decimal(money).add(new Decimal(item.money || 0).mul(item.num || 0)).toNumber()
    })
    myCar.num = myCar.goodsList?.length
    myCar.boxMoney = boxMoney
    myCar.money = money
    return 1
  } else {
    return 0
  }
}

export const getGoodsSpecInfo = (params: CommonReq): GoodsSpecResp | undefined => {
  let goods = getAllGoodsList().find(item => item.id === params.goodsId)
  let money = 0
  if (params.spec.indexOf('12寸') >= 0) {
    money = Number(new Decimal(goods?.money || 0).mul(2).toFixed(1))
  } else if (params.spec.indexOf('9寸') >= 0) {
    money = Number(new Decimal(goods?.money || 0).mul(1.5).toFixed(1))
  } else {
    money = goods?.money || 0
  }
  let result: GoodsSpecResp = {
    money: money,
    spec: params.spec,
    combination: params.combination,
    goodsId: params.goodsId,
    specType: goods?.specType || 0,
    boxMoney: goods?.boxMoney || 0,
    isMust: goods?.isMust || 0,
    id: '',
    money2: 0,
    discount: '',
    number: 0,
  }
  return result
}

// 订单
let orderList: Array<MyOrderResp> = []
let orderId: number = 1

export const getMyOrder = (params: MyOrderReq): Array<MyOrderResp> => {
  let result = orderList.filter(item => params.state.includes(item.order.state))
  return result.sort((a: MyOrderResp, b: MyOrderResp) => new Decimal(a.order?.id || 0).sub(b.order?.id || 0)
    .toNumber() > 0 ? -1 : 1)
};

export const getOrderInfo = (params: CommonReq) => {
  let order = orderList.find(item => item.order?.id === params.orderId)
  return order
};

export const cancelOrder = (params: CommonReq) => {
  let order = orderList.find(item => item.order?.id === params.orderId)
  if (order?.order?.state) {
    if (Number(order?.order?.state) === 1) {
      order.order.state = 3
      if (order.order.redeemedPoint) {
        unlockedPoint(150)
      }
      return 1
    } else {
      return 2
    }
  } else {
    return 0
  }
}

export const addOrder = (params: AddDnOrderReq) => {
  let date = new Date()
  let year = date.getFullYear()
  let month = `${date.getMonth() + 1}`.padStart(2, '0')
  let day = `${date.getDate()}`.padStart(2, '0')
  let hour = `${date.getHours()}`.padStart(2, '0')
  let minutes = `${date.getMinutes()}`.padStart(2, '0')
  let seconds = `${date.getSeconds()}`.padStart(2, '0')
  let orderModel: OrderInfoResp = {
    id: orderId + '',
    orderNum: new Date().getTime() + '',
    time: `${year}-${month}-${day} ${hour}:${minutes}:${seconds}`,
    money: params.money,
    reductionMoney: params.reductionMoney,
    boxMoney: params.boxMoney,
    mjMoney: params.mjMoney,
    xyhMoney: params.xyhMoney,
    note: params.note,
    payType: params.payType,
    orderType: params.orderType,
    tableware: params.tableware.toString(),
    yhqMoney: params.yhqMoney,
    couponId: params.couponId,
    redeemedPoint: params.redeemedPoint,
    state: 1,
    oid: `${80000 + orderId}`,
    payTime: '',
    storeTel: params.storeTel || '',
    storeName: params.storeName || '',
    storeLogo: params.storeLogo || '',
    storeAddress: params.storeAddress || '',
    lat: '',
    lng: '',
    rechargeId: params.rechargeId || '',
    preorderTime: params.preorderTime || '',
    preorderPhone: params.preorderPhone || '',
  }
  let sz: Array<GoodsReq> = JSON.parse(params.sz)
  let goodsList = sz.map((item: GoodsReq) => {
    let temp = getAllGoodsList().find(i => i.id === item.id)
    let goods: OrderGoodsResp = {
      id: item.id,
      logo: item.img,
      money: item.money,
      money2: temp?.money2 ?? 0,
      discount: temp?.discount ?? '',
      name: item.name,
      num: item.num,
      isMust: temp?.isMust ?? 0,
      specType: temp?.specType ?? 0,
      spec: item.spec,
      combination: item.combination,
    }
    return goods
  })
  let table = getTableInfoResp().find(item => item.id === params.tableId)
  let temp: OrderTableResp = {
    id: table?.id ?? '',
    name: table?.tableName ?? '',
    typeName: table?.typeName ?? '',
  }
  let order: MyOrderResp = {
    order: orderModel,
    goods: goodsList,
    table: temp,
  }
  // 华为支付如果有积分抵扣，需要锁定积分
  if (params.payType === 1 && params.redeemedPoint) {
    lockedPoint(150)
  }
  // 钱包支付，状态直接改为已支付
  if (params.payType === 2 && !params.rechargeId) {
    order.order.state = 2
    consumeMoney(params.money)
    if (order.order.redeemedPoint) {
      let point: PointRecord = {
        id: getPointList().length + 1,
        action: 2,
        changePoint: 150,
        time: new Date().getTime(),
      }
      insertPointRecord(point)
    }
    let point: PointRecord = {
      id: getPointList().length + 1,
      action: 1,
      changePoint: order.order.money,
      time: new Date().getTime(),
    }
    insertPointRecord(point)
  }
  orderList.push(order)
  orderId++
  cleanCar()
  return orderModel.id
}

export const addGoods = (params: CommonReq): number => {
  let order = orderList.find(item => item.order?.id === params.orderId)
  if (order?.order?.state && Number(order?.order?.state) !== 1) {
    return 2
  }
  deleteOrder(params)
  if (order?.order.redeemedPoint) {
    unlockedPoint(150)
  }
  cleanCar()
  order?.goods?.forEach(item => {
    let goods = getAllGoodsList().find(i => i.id === item.id)
    let goodsList: CarGoodsInfoResp = {
      id: `${myCarId}`,
      goodsId: item.id,
      num: item.num,
      specType: item.specType,
      spec: item.spec,
      combination: item.combination,
      money: item.money,
      money2: item.money2,
      discount: item.discount,
      boxMoney: goods?.boxMoney || 0,
      logo: item.logo,
      name: item.name,
      isMust: item.isMust,
    }
    if (!myCar.goodsList) {
      myCar.goodsList = []
    }
    myCar.goodsList?.push(goodsList)
    myCarId++
  })
  let boxMoney = 0
  let money = 0
  myCar.goodsList?.forEach(item => {
    boxMoney = new Decimal(boxMoney).add(item.boxMoney || 0).toNumber()
    money = new Decimal(money).add(new Decimal(item.money || 0).mul(item.num || 0)).toNumber()
  })
  myCar.num = myCar.goodsList?.length
  myCar.money = money
  myCar.boxMoney = boxMoney
  return 1;
}

export const getSnackSizedDeal = (params: CommonReq): Array<GoodsResp> => {
  return [goods5, goods6];
}

export const deleteOrder = (params: CommonReq): number => {
  orderList = orderList.filter(item => item.order?.id !== params.orderId)
  return 1;
}

export const getHuaweiPayInfo = (params: CommonReq) => {
  let order = orderList.find(item => item.order?.id === params.orderId)
  if (order?.order?.state) {
    if (Number(order?.order?.state) === 1) {
      order.order.state = 2
      // 充值
      let rechargeTier = rechargeTierList.find(item => item.id === order?.order.rechargeId)
      if (rechargeTier) {
        rechargeMoney(rechargeTier.id)
        consumeMoney(order.order.money)
      }
      if (order.order.redeemedPoint) {
        let point: PointRecord = {
          id: getPointList().length + 1,
          action: 2,
          changePoint: 150,
          time: new Date().getTime(),
        }
        insertPointRecord(point)
      }
      let point: PointRecord = {
        id: getPointList().length + 1,
        action: 1,
        changePoint: order.order.money,
        time: new Date().getTime(),
      }
      insertPointRecord(point)
      return 1
    } else {
      return 2
    }
  } else {
    return 0
  }
}
