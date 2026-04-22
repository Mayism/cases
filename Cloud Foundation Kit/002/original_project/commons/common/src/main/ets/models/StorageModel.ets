import { Type, window } from '@kit.ArkUI';
import { CarGoodsInfoResp, MyCarResp, UserInfoResp } from 'network';
import { Constants, OrderTypeEnum } from '../constants/Common';
import { getAnonymousTel } from '../utils/Utils';

// 应用信息
@ObservedV2
export class AppInfoModel {
  appId: string = '';
  packageName: string = '';
  @Trace telephone: string = '';
  @Trace bannerList: string[] = []
  @Trace imgBaseUrl: string = ''
  @Trace localCity: string = Constants.DEFAULT_CITY
  @Trace preloadFinished: boolean = false
}

export class TableInfo {
  id: string = '';
  tableName: string = '';
  typeName: string = '';
  num: number = 0;
  status: number = 0;
}


export class Reduction {
  id: string = ''
  name: string = ''
  full: number = 0
  reduction: number = 0

  constructor(id: string = '', name: string = '', full: number = 0, reduction: number = 0) {
    this.id = id;
    this.name = name;
    this.full = full;
    this.reduction = reduction;
  }
}

export class RechargeTier {
  id: string = ''
  name: string = ''
  payMoney: number = 0
  realMoney: number = 0
  desc: string = ''
  type: number = 0
}

export class StoreQueueInfo {
  used: number = 0;
  min: number = 0;
  mid: number = 0;
  max: number = 0;
  now: number = 0;
}

@ObservedV2
export class StoreInfo {
  id: string = ''
  @Trace name: string = ''
  address: string = ''
  // 营业开始时间
  @Trace time1: string = ''
  // 营业结束时间
  @Trace time2: string = ''
  @Trace tel: string = ''
  // 促销信息
  @Trace announcement: string = ''
  @Trace logo: string = ''
  // 位置坐标
  @Trace coordinates: string = ''
  // 营业执照
  @Trace businessLicense: string = ''
  // 食品经营许可证
  @Trace foodLicense: string = ''
  @Trace environment: Array<string> = []
  @Trace isRest: number = 0
  // 距离
  @Trace distance: number = 0
  @Trace distanceStr: string = ''
  // 新用户满减金额
  @Trace xyhMoney: number = 0
  // 备注口味：多个以;；分隔
  @Trace taste: string = ''
  @Type(Reduction) @Trace reductionList: Array<Reduction> = []
  rechargeTier: Array<RechargeTier> = []
  privateRoom: Array<number> = []
  diningHall: Array<number> = []
  maxCount: number = 0
  needQueue: boolean = false
  queueInfo: StoreQueueInfo = new StoreQueueInfo()

  constructor(id: string = '', name: string = '', address: string = '', time1: string = '', time2: string = '',
    tel: string = '', announcement: string = '', logo: string = '', coordinates: string = '',
    businessLicense: string = '', foodLicense: string = '', environment: Array<string> = [], isRest: number = 0,
    xyhMoney: number = 0, taste: string = '', reductionList: Array<Reduction> = [],
    rechargeTier: Array<RechargeTier> = []) {
    this.id = id
    this.name = name
    this.address = address
    this.time1 = time1
    this.time2 = time2
    this.tel = tel
    this.announcement = announcement
    this.logo = logo
    this.coordinates = coordinates
    this.businessLicense = businessLicense
    this.foodLicense = foodLicense
    this.environment = environment
    this.isRest = isRest
    this.xyhMoney = xyhMoney
    this.taste = taste
    this.reductionList = reductionList
    this.rechargeTier = rechargeTier
  }
}

// 店铺信息
@ObservedV2
export class StoreInfoModel {
  @Trace storeId: string = '';
  @Trace tableId: string = ''
  @Trace tableInfo: TableInfo = new TableInfo()
  @Trace preorderTime: string = '立即就餐'
  @Trace dinerNum: ResourceStr = ''
  @Trace orderType: number = OrderTypeEnum.DINE_IN
  @Trace distance: number = 0
  @Trace isRest: boolean = false
  @Trace qrCodeFlag: boolean = false
  @Type(TableInfo) @Trace tableList: Array<TableInfo> = [];
  @Trace storeInfo: StoreInfo = new StoreInfo()
  @Type(StoreInfo) @Trace storeList: Array<StoreInfo> = []
}

// 用户头像持久化
@ObservedV2
export class WindowModel {
  @Trace windowTopHeight: number = 38.77;
  @Trace windowBottomHeight: number = 28;
  @Trace fullScreen: boolean = false;
  @Trace windowStage?: window.WindowStage = undefined;

  getWindowTopHeight(): number {
    return this.windowTopHeight || 38.77;
  }

  getWindowBottomHeight(): number {
    return this.windowBottomHeight || 28;
  }
}

@ObservedV2
export class FormCard {
  @Trace id: number = 0
  url: string = ''
  @Trace orderId: string = ''
  @Trace index: number = 0
  @Trace isOrderJump: boolean = false
}

// 购物车信息
@ObservedV2
export class MyCarModel {
  @Trace myCar: MyCar = new MyCar()
  @Trace carCheck: Array<string> = []
}

@ObservedV2
export class MyCar {
  @Trace boxMoney: number = 0
  @Trace goodsList: Array<CarGoodsInfo> = []
  @Trace num: number = 0
  @Trace money: number = 0

  constructor(boxMoney: number = 0, num: number = 0, money: number = 0) {
    this.boxMoney = boxMoney
    this.num = num
    this.money = money
  }

  update(item: MyCarResp) {
    this.boxMoney = item.boxMoney
    this.goodsList = item.goodsList.map((item): CarGoodsInfo => {
      let temp = new CarGoodsInfo()
      temp.update(item)
      return temp
    })
    this.num = item.num
    this.money = item.money
  }
}

export class PackageSpec {
  specName: string = ''
  specNum: number = 0
}

@ObservedV2
export class CarGoodsInfo {
  id: string = ''
  goodsId: string = '';
  name: string = ''
  logo: string = ''
  @Trace num: number = 0
  specType: number = 0
  spec: string = ''
  combination: PackageSpec[] = []
  discount: string = ''
  money: number = 0
  money2: number = 0
  boxMoney: number = 0
  isMust: number = 0

  update(item: CarGoodsInfo | CarGoodsInfoResp) {
    this.id = item.id;
    this.goodsId = item.goodsId;
    this.name = item.name;
    this.logo = item.logo;
    this.num = item.num;
    this.specType = item.specType;
    this.spec = item.spec;
    this.combination = item.combination;
    this.discount = item.discount;
    this.money = item.money;
    this.money2 = item.money2;
    this.boxMoney = item.boxMoney;
    this.isMust = item.isMust;
  }
}

@ObservedV2
export class UserInfo implements UserInfoResp {
  id: string = ''
  name: string = ''
  img: string = ''
  openId: string = ''
  unionId: string = ''
  storeId: string = ''
  @Trace totalScore: number = 0
  @Trace wallet: number = 0
  @Trace userTel: string = ''

  constructor(id: string = '', name: string = '', img: string = '', openId: string = '', storeId: string = '',
    totalScore: number = 0, wallet: number = 0, unionId: string = '') {
    this.id = id
    this.name = name
    this.img = img
    this.openId = openId
    this.storeId = storeId
    this.totalScore = totalScore
    this.wallet = wallet
    this.unionId = unionId
  }
}

@ObservedV2
export class UserInfoModel {
  @Trace userInfo: UserInfo = new UserInfo()
  @Trace authCode: string = ''
  @Trace isRelative: boolean = false

  getUserName(): ResourceStr {
    return this.isRelative ? this.userInfo.name : $r('app.string.no_relate')
  }

  getTotalScore(): number {
    return this.isRelative ? this.userInfo.totalScore : 0
  }

  getTel(): string {
    return getAnonymousTel(this.userInfo.userTel)
  }
}

// 用户头像持久化
@ObservedV2
export class UserIconModel {
  @Trace isSaved: boolean = false
  @Trace userIconPath: string = 'userImage.jpg'
}

// 分享参数
@ObservedV2
export class CustomShareParams {
  @Trace id: number = 0;
  @Trace pageName: string = '';
  @Trace goodsId: string = '';
  @Trace goodsName: string = '';
}