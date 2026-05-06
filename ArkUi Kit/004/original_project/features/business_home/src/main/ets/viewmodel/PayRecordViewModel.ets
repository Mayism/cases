import { BaseViewModel, CAR_STATUE, HttpRequest, PayRecord, PAY_STATUE } from 'lib_common';

@ObservedV2
export class PayRecordViewModel extends BaseViewModel {
  @Trace payRecordList: Array<PayRecord> = []

  constructor() {
    super();
    this.getPayRecordList();
  }

  getPayRecordList() {
    HttpRequest.getPayRecordList().then((data) => {
      this.payRecordList = data;
    })
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
}