export class BaseResponse<T = undefined> {
  code: number
  msg: string
  data: T

  constructor(status: number, msg: string, data: T) {
    this.code = status
    this.msg = msg
    this.data = data
  }
}

@ObservedV2
export class PlateNumber {
  id: string = ''
  // 车牌号
  @Trace plate: string = ''
  // 蓝牌1、绿牌2、黄牌3
  type: string = ''
  // 普通车牌1、特殊车牌2
  kind: number = 1

  constructor(id: string = '', plate: string = '', type: string = '', kind: number = 1) {
    this.id = id
    this.plate = plate
    this.type = type
    this.kind = kind
  }
}

@ObservedV2
export class ShoppingMall {
  id: string = ''
  @Trace name: string = ''
  @Trace plateNum: string = ''
  @Trace tel: string = ''

  constructor(id: string = '', name: string = '', plateNum: string = '', tel: string = '') {
    this.id = id
    this.name = name
    this.plateNum = plateNum
    this.tel = tel
  }
}

@ObservedV2
export class UserInfo {
  id: string = ''
  @Trace name: string = ''
  @Trace totalScore: string = ''
  @Trace userTel?: string = ''
  membershipCode: string = ''

  constructor(id: string = '', name: string = '', totalScore: string = '', userTel: string = '',
    membershipCode: string = '') {
    this.id = id
    this.name = name
    this.totalScore = totalScore
    this.userTel = userTel
    this.membershipCode = membershipCode
  }
}

export interface IPayRecord {
  id?: string
  plate: string
  money: string
  carStatue: number
  payStatue: number
  address: string
  parkingTime: number
  entryTime: number
  exitTime?: number
  payTime?: number
}

@ObservedV2
export class PayRecord implements IPayRecord {
  @Trace id: string = ''
  plate: string = ''
  @Trace money: string = ''
  @Trace carStatue: number = 1
  @Trace payStatue: number = 1
  address: string = ''
  @Trace parkingTime: number = 0
  entryTime: number = 0
  @Trace exitTime: number = 0
  @Trace payTime: number = 0

  constructor(item?: IPayRecord) {
    if (!item) {
      return;
    }
    this.id = new Date().getTime().toString();
    this.plate = item.plate;
    this.money = item.money;
    this.carStatue = item.carStatue;
    this.payStatue = item.payStatue;
    this.address = item.address;
    this.parkingTime = item.parkingTime;
    this.entryTime = item.entryTime;
    this.exitTime = item.exitTime ?? 0;
    this.payTime = item.payTime ?? 0;
  }
}

export interface IWallet {
  id?: string
  name: string
  time: number
  action: number
  money: string
}

@ObservedV2
export class Wallet {
  // 索引
  id: string = ''
  // 名称
  name: string = ''
  // 生成时间
  time: number = 0
  // 充值1、支出2
  action: number = 1
  // 金额
  money: string = ''

  constructor(item: IWallet) {
    this.id = item.id ?? new Date().getTime().toString();
    this.name = item.name
    this.time = item.time
    this.action = item.action
    this.money = item.money
  }
}


//店铺导购
@ObservedV2
export class StoreGuide {
  id: string = ''
  @Trace logo: string = ''
  @Trace name: string = ''
  @Trace bigImage: string = ''
  @Trace location: string = ''
  @Trace floor: string = ''
  @Trace tag: string = ''
  @Trace tel: string = ''
  @Trace introduce: string = ''

  constructor(id: string = '', logo: string = '', name: string = '', bigImage: string = '', location: string = '',
    floor: string = '',
    tag: string = '', tel: string = '', introduce: string = '') {
    this.id = id
    this.logo = logo
    this.name = name
    this.bigImage = bigImage
    this.location = location
    this.floor = floor
    this.tag = tag
    this.tel = tel
    this.introduce = introduce
  }
}

// 导购分类
@ObservedV2
export class GuideTag {
  id: string = ''
  name: string = ''
  @Trace num: number = 0

  constructor(id: string = '', name: string = '', num: number = 0) {
    this.id = id
    this.name = name
    this.num = num
  }
}

