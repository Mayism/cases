import { common } from '@kit.AbilityKit';
import { AppStorageV2 } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import {
  BaseResponse,
  CAR_STATUE,
  ContextUtils,
  EmitUtils,
  FormatUtils,
  GlobalUtils,
  HttpRequest,
  HttpRequestApi,
  Logger,
  PaymentRouter,
  PayRecord,
  PAY_STATUE,
  RouterMap,
  RouterUtil,
  WindowModel
} from 'lib_common';
import { GlobalCouponUtils } from 'module_coupon';
import { GlobalPointUtils } from 'module_points';

const TAG: string = '[PayDetailViewModel]';

@ObservedV2
export class PayDetailViewModel extends WindowModel {
  @Trace payRecord: PayRecord = new PayRecord()
  @Trace plate: string = ''
  @Trace showPointSheet: boolean = false;
  @Trace showCouponSheet: boolean = false;
  @Trace showPayIntroSheet: boolean = false;
  @Trace tempSelectPayPoint: string = '';
  // 选择xx积分抵扣
  @Trace selectPayPoint: string = '';
  // 选择的优惠券id
  @Trace selectedCouponID: string = '';
  // 选择的优惠券面额
  @Trace selectedCouponMoney: number = 0;
  // 是否开启钱包支付
  @Trace useWallet: boolean = false;
  // 使用钱包的额度
  @Trace useWalletMoney: number = 0;
  @Trace globalInfo: GlobalUtils = AppStorageV2.connect(GlobalUtils, () => new GlobalUtils())!;
  @Trace globalPointInfo: GlobalPointUtils = AppStorageV2.connect(GlobalPointUtils, () => new GlobalPointUtils())!;
  @Trace globalCouponInfo: GlobalCouponUtils = AppStorageV2.connect(GlobalCouponUtils, () => new GlobalCouponUtils())!;

  getParams() {
    let paramsArr: PaymentRouter[] = RouterUtil.getParamByName(RouterMap.PAY_DETAIL_PAGE) as PaymentRouter[];
    if (paramsArr.length) {
      let routerParam = paramsArr[paramsArr.length - 1];
      this.plate = routerParam?.plate ?? '';
      HttpRequest.getPayDetail(this.plate).then(res => {
        this.payRecord = res
      })
    }
  }

  getPayText(item: PayRecord): ResourceStr {
    if (item.payStatue === PAY_STATUE.PENDING_PAYMENT) {
      return `待支付：${item.money}`
    } else {
      return `已支付：${item.money}`
    }
  }

  getPayTextColor(item: PayRecord): ResourceStr {
    if (item.payStatue === PAY_STATUE.PENDING_PAYMENT) {
      return $r('sys.color.multi_color_08')
    } else if (item.payStatue === PAY_STATUE.PAYMENT_COMPLETED && item.carStatue === CAR_STATUE.PENDING_EXIT) {
      return $r('sys.color.multi_color_04')
    } else {
      return $r('sys.color.font_secondary')
    }
  }

  getPointSelectText() {
    if (this.selectPayPoint) {
      return `-${this.selectPayPoint}`;
    }
    if (this.globalPointInfo.myPoints >= 800) {
      return '2方案可用';
    }
    if (this.globalPointInfo.myPoints >= 400) {
      return '1方案可用';
    }
    return '积分不足';
  }

  get getPointSelectTextFg() {
    if (this.selectPayPoint) {
      return $r('sys.color.multi_color_08');
    }
    return $r('sys.color.font_secondary');
  }

  getCouponSelectText() {
    if (this.selectedCouponMoney) {
      return `-${this.selectedCouponMoney}`;
    }
    return `${this.globalCouponInfo.validCouponListCount}张可用`
  }

  get getCouponSelectTextFg() {
    if (this.selectedCouponMoney) {
      return $r('sys.color.multi_color_08');
    }
    return $r('sys.color.font_secondary');
  }

  getActualPayMoney() {
    let total = 7.5;
    let selectPointMoney = this.selectPayPoint !== '' ? Number(this.selectPayPoint) / 100 : 0;
    let leftMoney = total - selectPointMoney - this.selectedCouponMoney;
    if (leftMoney < 0) {
      leftMoney = 0;
    }

    if (this.useWallet) {
      this.useWalletMoney = this.globalInfo.myWallet >= leftMoney ? leftMoney : this.globalInfo.myWallet;
    } else {
      this.useWalletMoney = 0;
    }
    return FormatUtils.formatCurrency(leftMoney - this.useWalletMoney);
  }

  get enableWallet() {
    return this.globalInfo.myWallet > 0;
  }

  handleCouponPay() {
    if (this.selectedCouponID) {
      this.globalCouponInfo.consumeCoupon(this.selectedCouponID);
    }
  }

  handlePointPay() {
    if (this.selectPayPoint) {
      const point = Number(this.selectPayPoint);
      this.globalPointInfo.consumePoint(point);
    }
  }

  handleWalletPay() {
    if (this.enableWallet && this.useWallet) {
      EmitUtils.sendEmit('onConsumeWallet', { data: { money: this.useWalletMoney } });
    }
  }

  handleSuccess() {
    ContextUtils.showToast({ message: '模拟支付成功~' });
    const actualPayRecord = new PayRecord();
    actualPayRecord.plate = this.plate
    actualPayRecord.address = '商场停车场'
    actualPayRecord.entryTime = new Date().getTime()
    actualPayRecord.parkingTime = 3890
    actualPayRecord.money = this.getActualPayMoney()
    RouterUtil.pushPathByName(RouterMap.PAY_SUCCESS_PAGE, actualPayRecord);
  }

  payOrder(context: common.UIAbilityContext) {
    // 拉华为支付
    HttpRequest.getPurchase(context).finally(() => {
      HttpRequestApi.payOrder(this.plate, this.getActualPayMoney()).then((resp: BaseResponse) => {
        this.handleCouponPay();
        this.handlePointPay();
        this.handleWalletPay();
        this.handleSuccess();
      }).catch((e: BusinessError) => {
        Logger.error(TAG, `getHuaweiPayInfo error: ${JSON.stringify(e)}.`);
        ContextUtils.showToast({ message: $r('app.string.pay_failed_msg', JSON.stringify(e)) })
      })
    })
  }
}