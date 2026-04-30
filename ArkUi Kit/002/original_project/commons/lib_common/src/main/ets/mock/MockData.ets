import { JSON } from '@kit.ArkTS';
import { CommonReq } from '../models/RequestModel';
import {
  BaseResponse,
  IPayRecord,
  IWallet,
  PayRecord,
  PlateNumber,
  ShoppingMall,
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
