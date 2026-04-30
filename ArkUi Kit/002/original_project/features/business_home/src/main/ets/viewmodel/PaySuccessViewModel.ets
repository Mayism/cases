import { PayRecord, RouterMap, RouterUtil, WindowModel } from 'lib_common';

@ObservedV2
export class PaySuccessViewModel extends WindowModel {
  @Trace payRecord: PayRecord = new PayRecord()

  constructor() {
    super()
    this.getParams();
  }

  getParams() {
    let paramsArr: PayRecord[] = RouterUtil.getParamByName(RouterMap.PAY_SUCCESS_PAGE) as PayRecord[];
    if (paramsArr.length) {
      let routerParam = paramsArr[paramsArr.length - 1];
      this.payRecord = routerParam;
    }
  }

  backHome() {
    RouterUtil.popToName(RouterMap.INDEX_PAGE);
  }

  onBackPressed() {
    RouterUtil.popToName(RouterMap.PARKING_PAYMENT_PAGE);
    return true;
  }
}