import { JSON } from '@kit.ArkTS';
import { CommonReq } from '../models/RequestModel';
import {
  BaseResponse,
  IPayRecord,
  IWallet,
  PayRecord,
  PlateNumber,
  ShoppingMall,
  StoreGuide,
  UserInfo,
  Wallet
} from '../models/ResponseModel';

export class MockData {
  static resultSuccess: BaseResponse = new BaseResponse(0, 'success', undefined)
  static resultFailed: BaseResponse = new BaseResponse(1, 'failed', undefined)
  static plateNumberList: Array<PlateNumber> = [new PlateNumber('1', '苏A55WW2', '1'),
    new PlateNumber('2', '苏A55WW33', '2'),
    new PlateNumber('3', '苏A55WW44', '3')]
  static payRecordList: PayRecord[] = [
    new PayRecord({
      plate: '苏DDDDDD',
      money: '7.5',
      carStatue: 0,
      payStatue: 3,
      address: '商场停车场',
      parkingTime: 3000,
      entryTime: new Date('2025-05-25').getTime(),
      exitTime: new Date('2025-05-25').getTime(),
      payTime: new Date('2025-05-25').getTime(),
    } as IPayRecord),
    new PayRecord({
      plate: '苏DDDDDD',
      money: '7.5',
      carStatue: 0,
      payStatue: 3,
      address: '商场停车场',
      parkingTime: 3000,
      entryTime: new Date('2025-04-25').getTime(),
      exitTime: new Date('2025-04-25').getTime(),
      payTime: new Date('2025-04-25').getTime(),
    } as IPayRecord),
    new PayRecord({
      plate: '苏DDDDDD',
      money: '7.5',
      carStatue: 0,
      payStatue: 3,
      address: '商场停车场',
      parkingTime: 3000,
      entryTime: new Date('2025-03-25').getTime(),
      exitTime: new Date('2025-03-25').getTime(),
      payTime: new Date('2025-03-25').getTime(),
    } as IPayRecord),
  ];
  static plateNumberId: number = 3
  static plateNum: number = 999

  static get getShoppingMallInfo(): BaseResponse<ShoppingMall> {
    let result: ShoppingMall = new ShoppingMall('1', '商场模板', this.plateNum.toString(), '00000000000')
    this.plateNum--
    return new BaseResponse(0, 'success', result)
  };

  static get queryPlateNumber(): BaseResponse<Array<PlateNumber>> {
    return new BaseResponse(0, 'success', this.plateNumberList)
  };

  static addPlateNumber = (params: CommonReq): BaseResponse => {
    if (this.plateNumberList.some(item => item.plate === params.plate)) {
      return this.resultFailed
    }
    this.plateNumberId++
    let plateNumber =
      new PlateNumber(this.plateNumberId.toString(), params.plate, params.type as string, params.plateKind)
    this.plateNumberList.splice(0, 0, plateNumber)
    return this.resultSuccess;
  };
  static deletePlateNumber = (params: CommonReq) => {
    let plateNumber = this.plateNumberList.find(item => item.id === params.id)
    if (plateNumber) {
      this.plateNumberList = this.plateNumberList.filter(item => item.id !== params.id)
      return this.resultSuccess
    } else {
      return this.resultFailed
    }
  };
  static userInfo: UserInfo;

  static get getUserInfo(): UserInfo {
    if (!this.userInfo) {
      this.userInfo = new UserInfo()
      this.userInfo.id = '1'
      this.userInfo.name = '华为用户'
      this.userInfo.totalScore = ''
    }
    return this.userInfo
  }

  static get getUserInfoResp(): BaseResponse<UserInfo> {
    return new BaseResponse(0, 'success', this.getUserInfo)
  }

  static get getOpenLogin(): BaseResponse<UserInfo> {
    this.userInfo.userTel = '10000000001'
    return new BaseResponse(0, 'success', this.userInfo)
  }

  static get getCloseLogin(): UserInfo {
    this.userInfo.userTel = ''
    return this.userInfo
  }

  static getPayDetail = (params: CommonReq) => {
    let platePayment: PayRecord = new PayRecord()
    platePayment.plate = params.plate
    platePayment.address = '商场停车场'
    platePayment.entryTime = new Date().getTime()
    platePayment.parkingTime = 3890
    platePayment.money = '7.5'
    return new BaseResponse(0, 'success', platePayment)
  }
  // 生成&支付订单
  static payOrder = (params: CommonReq) => {
    let platePayment: PayRecord = new PayRecord({
      plate: params.plate,
      address: '商场停车场',
      entryTime: new Date().getTime(),
      exitTime: new Date().getTime(),
      parkingTime: 3890,
      money: params.extraPay.toString(),
      payStatue: 3,
      carStatue: 3,
    } as IPayRecord)
    this.payRecordList.splice(0, 0, platePayment);
    return this.resultSuccess
  }

  static get getPayRecordList(): BaseResponse<PayRecord[]> {
    return new BaseResponse(0, 'success', this.payRecordList)
  }

  static modifyUserInfo = (params: CommonReq): BaseResponse<UserInfo> => {
    this.userInfo.name = params.name
    return new BaseResponse(0, 'success', this.getUserInfo)
  }

  static get getMyWalletList(): BaseResponse<Wallet[]> {
    let walletList: IWallet[] = [
      {
        name: '停车缴费',
        time: new Date('2025-06-04').getTime(),
        action: 2,
        money: '15'
      },
      {
        name: '充值',
        time: new Date('2025-06-03').getTime(),
        action: 1,
        money: '180'
      },
      {
        name: '停车缴费',
        time: new Date('2025-06-02').getTime(),
        action: 2,
        money: '15'
      },
      {
        name: '充值',
        time: new Date('2025-06-01').getTime(),
        action: 1,
        money: '50'
      },
      {
        name: '停车缴费',
        time: new Date('2025-05-20').getTime(),
        action: 2,
        money: '30'
      },
      {
        name: '充值',
        time: new Date('2025-05-18').getTime(),
        action: 1,
        money: '80'
      },
      {
        name: '停车缴费',
        time: new Date('2025-05-16').getTime(),
        action: 2,
        money: '10'
      },
      {
        name: '充值',
        time: new Date('2025-05-14').getTime(),
        action: 1,
        money: '20'
      },
    ]
    return new BaseResponse(0, 'success', walletList.map(v => new Wallet(v)))
  }

  static get getService(): BaseResponse<string> {
    let json: string = `<h3 class="text-2xl font-bold mb-5">雨伞租借说明：</h3>
    <p>本商场在雨天免费为客户提供出借雨伞的服务，凡需要借用雨伞的客户，须在顾客服务中心进行相应个人资料的登记，收取50元押金，便可免费获得借用雨伞。顾客凭押金收据归还雨伞，退还押金。</p>

    <h3 class="text-xl font-bold mt-8 mb-3">轮椅/童车租借说明：</h3>
    <p>本商场为带孩子的客户及残疾人提供免费出借童车、轮椅的服务。凡需要借童车、轮椅的客户，须在顾客服务中心进行相应个人资料的登记，收取押金400元，便可免费获得借用童车、轮椅。顾客凭押金收据还车，退还押金。</p>`
    return new BaseResponse(0, 'success', json)
  }

  static get getStoreGuide(): BaseResponse<Array<StoreGuide>> {
    let json1: StoreGuide =
      JSON.parse('{"id":"1","logo":"ShoppingMall/ic_logo1.png","name":"哇哇运动","bigImage":"ShoppingMall/img_store_1.png","location":"5F-501","floor":"5F","tag":"运动,儿童","tel":"000-00000000","introduce":"创立于2025年的新生代运动品牌，以\\"WOW EFFECT\\"为核心理念，致力于为18-35岁都市青年提供兼具功能性与潮流感的运动装备。品牌名\\"哇哇\\"取自消费者体验产品时下意识的赞叹声，中文命名既体现本土化特色又暗含国际化的\\"WOW\\"惊喜感。"}') as StoreGuide
    let json2: StoreGuide =
      JSON.parse('{"id":"2","logo":"ShoppingMall/ic_logo2.png","name":"绮梦纱","bigImage":"ShoppingMall/img_store_2.png","location":"5F-502","floor":"5F","tag":"服装","tel":"000-00000000","introduce":"品牌创立1997年，是十大中国时尚品牌之一，作为国际化服装品牌，融合欧陆文化与东方美学，注重高质感面料与复调设计。‌定位‌：西班牙轻奢品牌，涵盖商务、休闲、旅行等多场景服饰。设计‌：女装系列以巴黎风情为主，如雪纺裙与黑白印花半裙；男装强调优雅剪裁，搭配摩登配饰提升整体质感‌8。"}') as StoreGuide
    let json3: StoreGuide =
      JSON.parse('{"id":"3","logo":"ShoppingMall/ic_logo3.png","name":"有滋有味","bigImage":"ShoppingMall/img_store_3.png","location":"5F-503","floor":"5F","tag":"餐饮","tel":"000-00000000","introduce":"创立于2023年的新派川味连锁品牌，以“古法新作”为核心理念，将传统川菜二十四味型与现代餐饮标准完美融合。品牌名称取自《论语》“食不厌精，脍不厌细”，主打“一锅承百味，一味见乾坤”的沉浸式餐饮体验。\\n四川，湖南有专属原材料种植基地，实现：花椒/辣椒品类检测溯源 、每日凌晨3点冷链直达各门店 、中央厨房标准化出品控制。"}') as StoreGuide
    let json4: StoreGuide =
      JSON.parse('{"id":"4","logo":"ShoppingMall/ic_logo1.png","name":"哇哇运动","bigImage":"ShoppingMall/img_store_1.png","location":"5F-504","floor":"5F","tag":"儿童","tel":"000-00000000","introduce":"创立于2025年的新生代运动品牌，以\\"WOW EFFECT\\"为核心理念，致力于为18-35岁都市青年提供兼具功能性与潮流感的运动装备。品牌名\\"哇哇\\"取自消费者体验产品时下意识的赞叹声，中文命名既体现本土化特色又暗含国际化的\\"WOW\\"惊喜感。"}') as StoreGuide
    let json5: StoreGuide =
      JSON.parse('{"id":"5","logo":"ShoppingMall/ic_logo2.png","name":"绮梦纱","bigImage":"ShoppingMall/img_store_2.png","location":"5F-505","floor":"5F","tag":"母婴,儿童","tel":"000-00000000","introduce":"品牌创立1997年，是十大中国时尚品牌之一，作为国际化服装品牌，融合欧陆文化与东方美学，注重高质感面料与复调设计。‌定位‌：西班牙轻奢品牌，涵盖商务、休闲、旅行等多场景服饰。设计‌：女装系列以巴黎风情为主，如雪纺裙与黑白印花半裙；男装强调优雅剪裁，搭配摩登配饰提升整体质感‌8。"}') as StoreGuide
    let json6: StoreGuide =
      JSON.parse('{"id":"6","logo":"ShoppingMall/ic_logo3.png","name":"有滋有味","bigImage":"ShoppingMall/img_store_3.png","location":"5F-506","floor":"5F","tag":"母婴","tel":"000-00000000","introduce":"创立于2023年的新派川味连锁品牌，以“古法新作”为核心理念，将传统川菜二十四味型与现代餐饮标准完美融合。品牌名称取自《论语》“食不厌精，脍不厌细”，主打“一锅承百味，一味见乾坤”的沉浸式餐饮体验。\\n四川，湖南有专属原材料种植基地，实现：花椒/辣椒品类检测溯源 、每日凌晨3点冷链直达各门店 、中央厨房标准化出品控制。"}') as StoreGuide
    let json7: StoreGuide =
      JSON.parse('{"id":"7","logo":"ShoppingMall/ic_logo1.png","name":"哇哇运动","bigImage":"ShoppingMall/img_store_1.png","location":"5F-507","floor":"5F","tag":"运动","tel":"000-00000000","introduce":"创立于2025年的新生代运动品牌，以\\"WOW EFFECT\\"为核心理念，致力于为18-35岁都市青年提供兼具功能性与潮流感的运动装备。品牌名\\"哇哇\\"取自消费者体验产品时下意识的赞叹声，中文命名既体现本土化特色又暗含国际化的\\"WOW\\"惊喜感。"}') as StoreGuide
    let json8: StoreGuide =
      JSON.parse('{"id":"8","logo":"ShoppingMall/ic_logo2.png","name":"绮梦纱","bigImage":"ShoppingMall/img_store_2.png","location":"5F-508","floor":"5F","tag":"服装","tel":"000-00000000","introduce":"品牌创立1997年，是十大中国时尚品牌之一，作为国际化服装品牌，融合欧陆文化与东方美学，注重高质感面料与复调设计。‌定位‌：西班牙轻奢品牌，涵盖商务、休闲、旅行等多场景服饰。设计‌：女装系列以巴黎风情为主，如雪纺裙与黑白印花半裙；男装强调优雅剪裁，搭配摩登配饰提升整体质感‌8。"}') as StoreGuide
    let json9: StoreGuide =
      JSON.parse('{"id":"9","logo":"ShoppingMall/ic_logo3.png","name":"有滋有味","bigImage":"ShoppingMall/img_store_3.png","location":"5F-509","floor":"5F","tag":"娱乐","tel":"000-00000000","introduce":"创立于2023年的新派川味连锁品牌，以“古法新作”为核心理念，将传统川菜二十四味型与现代餐饮标准完美融合。品牌名称取自《论语》“食不厌精，脍不厌细”，主打“一锅承百味，一味见乾坤”的沉浸式餐饮体验。\\n四川，湖南有专属原材料种植基地，实现：花椒/辣椒品类检测溯源 、每日凌晨3点冷链直达各门店 、中央厨房标准化出品控制。"}') as StoreGuide

    let json10: StoreGuide =
      JSON.parse('{"id":"10","logo":"ShoppingMall/ic_logo1.png","name":"哇哇运动","bigImage":"ShoppingMall/img_store_1.png","location":"4F-401","floor":"4F","tag":"娱乐","tel":"000-00000000","introduce":"创立于2025年的新生代运动品牌，以\\"WOW EFFECT\\"为核心理念，致力于为18-35岁都市青年提供兼具功能性与潮流感的运动装备。品牌名\\"哇哇\\"取自消费者体验产品时下意识的赞叹声，中文命名既体现本土化特色又暗含国际化的\\"WOW\\"惊喜感。"}') as StoreGuide
    let json11: StoreGuide =
      JSON.parse('{"id":"11","logo":"ShoppingMall/ic_logo2.png","name":"绮梦纱","bigImage":"ShoppingMall/img_store_2.png","location":"4F-402","floor":"4F","tag":"服装","tel":"000-00000000","introduce":"品牌创立1997年，是十大中国时尚品牌之一，作为国际化服装品牌，融合欧陆文化与东方美学，注重高质感面料与复调设计。‌定位‌：西班牙轻奢品牌，涵盖商务、休闲、旅行等多场景服饰。设计‌：女装系列以巴黎风情为主，如雪纺裙与黑白印花半裙；男装强调优雅剪裁，搭配摩登配饰提升整体质感‌8。"}') as StoreGuide
    let json12: StoreGuide =
      JSON.parse('{"id":"12","logo":"ShoppingMall/ic_logo3.png","name":"有滋有味","bigImage":"ShoppingMall/img_store_3.png","location":"4F-403","floor":"4F","tag":"餐饮","tel":"000-00000000","introduce":"创立于2023年的新派川味连锁品牌，以“古法新作”为核心理念，将传统川菜二十四味型与现代餐饮标准完美融合。品牌名称取自《论语》“食不厌精，脍不厌细”，主打“一锅承百味，一味见乾坤”的沉浸式餐饮体验。\\n四川，湖南有专属原材料种植基地，实现：花椒/辣椒品类检测溯源 、每日凌晨3点冷链直达各门店 、中央厨房标准化出品控制。"}') as StoreGuide


    let json13: StoreGuide =
      JSON.parse('{"id":"13","logo":"ShoppingMall/ic_logo1.png","name":"哇哇运动","bigImage":"ShoppingMall/img_store_1.png","location":"3F-301","floor":"3F","tag":"精品","tel":"000-00000000","introduce":"创立于2025年的新生代运动品牌，以\\"WOW EFFECT\\"为核心理念，致力于为18-35岁都市青年提供兼具功能性与潮流感的运动装备。品牌名\\"哇哇\\"取自消费者体验产品时下意识的赞叹声，中文命名既体现本土化特色又暗含国际化的\\"WOW\\"惊喜感。"}') as StoreGuide
    let json14: StoreGuide =
      JSON.parse('{"id":"14","logo":"ShoppingMall/ic_logo2.png","name":"绮梦纱","bigImage":"ShoppingMall/img_store_2.png","location":"3F-302","floor":"3F","tag":"服装","tel":"000-00000000","introduce":"品牌创立1997年，是十大中国时尚品牌之一，作为国际化服装品牌，融合欧陆文化与东方美学，注重高质感面料与复调设计。‌定位‌：西班牙轻奢品牌，涵盖商务、休闲、旅行等多场景服饰。设计‌：女装系列以巴黎风情为主，如雪纺裙与黑白印花半裙；男装强调优雅剪裁，搭配摩登配饰提升整体质感‌8。"}') as StoreGuide
    let json15: StoreGuide =
      JSON.parse('{"id":"15","logo":"ShoppingMall/ic_logo3.png","name":"有滋有味","bigImage":"ShoppingMall/img_store_3.png","location":"3F-303","floor":"3F","tag":"餐饮","tel":"000-00000000","introduce":"创立于2023年的新派川味连锁品牌，以“古法新作”为核心理念，将传统川菜二十四味型与现代餐饮标准完美融合。品牌名称取自《论语》“食不厌精，脍不厌细”，主打“一锅承百味，一味见乾坤”的沉浸式餐饮体验。\\n四川，湖南有专属原材料种植基地，实现：花椒/辣椒品类检测溯源 、每日凌晨3点冷链直达各门店 、中央厨房标准化出品控制。"}') as StoreGuide


    let json16: StoreGuide =
      JSON.parse('{"id":"16","logo":"ShoppingMall/ic_logo1.png","name":"哇哇运动","bigImage":"ShoppingMall/img_store_1.png","location":"2F-201","floor":"2F","tag":"娱乐","tel":"000-00000000","introduce":"创立于2025年的新生代运动品牌，以\\"WOW EFFECT\\"为核心理念，致力于为18-35岁都市青年提供兼具功能性与潮流感的运动装备。品牌名\\"哇哇\\"取自消费者体验产品时下意识的赞叹声，中文命名既体现本土化特色又暗含国际化的\\"WOW\\"惊喜感。"}') as StoreGuide
    let json17: StoreGuide =
      JSON.parse('{"id":"17","logo":"ShoppingMall/ic_logo2.png","name":"绮梦纱","bigImage":"ShoppingMall/img_store_2.png","location":"2F-202","floor":"2F","tag":"服装","tel":"000-00000000","introduce":"品牌创立1997年，是十大中国时尚品牌之一，作为国际化服装品牌，融合欧陆文化与东方美学，注重高质感面料与复调设计。‌定位‌：西班牙轻奢品牌，涵盖商务、休闲、旅行等多场景服饰。设计‌：女装系列以巴黎风情为主，如雪纺裙与黑白印花半裙；男装强调优雅剪裁，搭配摩登配饰提升整体质感‌8。"}') as StoreGuide
    let json18: StoreGuide =
      JSON.parse('{"id":"18","logo":"ShoppingMall/ic_logo3.png","name":"有滋有味","bigImage":"ShoppingMall/img_store_3.png","location":"2F-203","floor":"2F","tag":"餐饮","tel":"000-00000000","introduce":"创立于2023年的新派川味连锁品牌，以“古法新作”为核心理念，将传统川菜二十四味型与现代餐饮标准完美融合。品牌名称取自《论语》“食不厌精，脍不厌细”，主打“一锅承百味，一味见乾坤”的沉浸式餐饮体验。\\n四川，湖南有专属原材料种植基地，实现：花椒/辣椒品类检测溯源 、每日凌晨3点冷链直达各门店 、中央厨房标准化出品控制。"}') as StoreGuide

    let json19: StoreGuide =
      JSON.parse('{"id":"19","logo":"ShoppingMall/ic_logo1.png","name":"哇哇运动","bigImage":"ShoppingMall/img_store_1.png","location":"1F-101","floor":"1F","tag":"娱乐","tel":"000-00000000","introduce":"创立于2025年的新生代运动品牌，以\\"WOW EFFECT\\"为核心理念，致力于为18-35岁都市青年提供兼具功能性与潮流感的运动装备。品牌名\\"哇哇\\"取自消费者体验产品时下意识的赞叹声，中文命名既体现本土化特色又暗含国际化的\\"WOW\\"惊喜感。"}') as StoreGuide
    let json20: StoreGuide =
      JSON.parse('{"id":"20","logo":"ShoppingMall/ic_logo2.png","name":"绮梦纱","bigImage":"ShoppingMall/img_store_2.png","location":"1F-102","floor":"1F","tag":"服装","tel":"000-00000000","introduce":"品牌创立1997年，是十大中国时尚品牌之一，作为国际化服装品牌，融合欧陆文化与东方美学，注重高质感面料与复调设计。‌定位‌：西班牙轻奢品牌，涵盖商务、休闲、旅行等多场景服饰。设计‌：女装系列以巴黎风情为主，如雪纺裙与黑白印花半裙；男装强调优雅剪裁，搭配摩登配饰提升整体质感‌8。"}') as StoreGuide
    let json21: StoreGuide =
      JSON.parse('{"id":"21","logo":"ShoppingMall/ic_logo3.png","name":"有滋有味","bigImage":"ShoppingMall/img_store_3.png","location":"1F-103","floor":"1F","tag":"餐饮","tel":"000-00000000","introduce":"创立于2023年的新派川味连锁品牌，以“古法新作”为核心理念，将传统川菜二十四味型与现代餐饮标准完美融合。品牌名称取自《论语》“食不厌精，脍不厌细”，主打“一锅承百味，一味见乾坤”的沉浸式餐饮体验。\\n四川，湖南有专属原材料种植基地，实现：花椒/辣椒品类检测溯源 、每日凌晨3点冷链直达各门店 、中央厨房标准化出品控制。"}') as StoreGuide

    let json22: StoreGuide =
      JSON.parse('{"id":"22","logo":"ShoppingMall/ic_logo1.png","name":"哇哇运动","bigImage":"ShoppingMall/img_store_1.png","location":"B1-101","floor":"B1","tag":"娱乐","tel":"000-00000000","introduce":"创立于2025年的新生代运动品牌，以\\"WOW EFFECT\\"为核心理念，致力于为18-35岁都市青年提供兼具功能性与潮流感的运动装备。品牌名\\"哇哇\\"取自消费者体验产品时下意识的赞叹声，中文命名既体现本土化特色又暗含国际化的\\"WOW\\"惊喜感。"}') as StoreGuide
    let json23: StoreGuide =
      JSON.parse('{"id":"23","logo":"ShoppingMall/ic_logo2.png","name":"绮梦纱","bigImage":"ShoppingMall/img_store_2.png","location":"B1-102","floor":"B1","tag":"服装","tel":"000-00000000","introduce":"品牌创立1997年，是十大中国时尚品牌之一，作为国际化服装品牌，融合欧陆文化与东方美学，注重高质感面料与复调设计。‌定位‌：西班牙轻奢品牌，涵盖商务、休闲、旅行等多场景服饰。设计‌：女装系列以巴黎风情为主，如雪纺裙与黑白印花半裙；男装强调优雅剪裁，搭配摩登配饰提升整体质感‌8。"}') as StoreGuide
    let json24: StoreGuide =
      JSON.parse('{"id":"24","logo":"ShoppingMall/ic_logo3.png","name":"有滋有味","bigImage":"ShoppingMall/img_store_3.png","location":"B1-103","floor":"B1","tag":"餐饮","tel":"000-00000000","introduce":"创立于2023年的新派川味连锁品牌，以“古法新作”为核心理念，将传统川菜二十四味型与现代餐饮标准完美融合。品牌名称取自《论语》“食不厌精，脍不厌细”，主打“一锅承百味，一味见乾坤”的沉浸式餐饮体验。\\n四川，湖南有专属原材料种植基地，实现：花椒/辣椒品类检测溯源 、每日凌晨3点冷链直达各门店 、中央厨房标准化出品控制。"}') as StoreGuide


    return new BaseResponse(0, 'success', [json1, json2, json3, json4, json5, json6, json7, json8, json9,
      json10, json11, json12, json13, json14, json15, json16, json17, json18, json19, json20, json21,
      json22, json23, json24
    ]
    )
  }

  static get getPrivacyInfo(): BaseResponse<string> {
    let json: string = `<h2 class="text-2xl font-bold mb-5">商场模板隐私声明</h1>
    <p>商场模板是用于商场的元服务模板。本隐私声明由我们为处理您的个人信息而制定。</p>
    <p>我们非常重视您的个人信息和隐私保护，将会按照法律要求和业界成熟的安全标准，为您的个人信息提供相应的安全保护措施。</p>

    <h3 class="text-xl font-bold mt-8 mb-3">1. 我们如何收集和使用您的个人信息</h2>
    <p>我们仅在有合法性基础的情形下才会使用您的个人信息。根据适用的法律，我们可能会基于您的同意、为履行/订立您与我们的合同所必需、履行法定义务所必需等合法性基础，使用您的个人信息。</p>

    <h4 class="text-lg font-bold mt-6 mb-2">1.1 我们提供下列服务时会处理必要的个人信息。</h3>
    <p>为了实现应用功能，在获取您的同意后我们需要收集您的精确位置信息、大致位置信息、用户标识符、账号信息、图片。</p>

    <h3 class="text-xl font-bold mt-8 mb-3">2. 设备权限调用</h2>
    <p>位置 （获取设备位置信息、获取设备模糊位置信息）</p>`
    return new BaseResponse(0, 'success', json)
  }
}
