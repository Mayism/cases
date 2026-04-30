import { BaseViewModel } from 'lib_common';

@ObservedV2
export class RechargeWalletViewModel extends BaseViewModel {
  @Trace serialNumber: string = ''
  @Trace key: string = ''
}
