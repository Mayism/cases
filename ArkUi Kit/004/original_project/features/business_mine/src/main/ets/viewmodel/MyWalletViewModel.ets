import { intl } from '@kit.LocalizationKit';
import { AppStorageV2 } from '@kit.ArkUI';
import { BaseViewModel, Constants, GlobalUtils, HttpRequest, IWallet, Wallet } from 'lib_common';

// 全部0、充值1、支出2
export enum WalletType {
  ALL = 0,
  IN,
  OUT,
}

@ObservedV2
export class MyWalletViewModel extends BaseViewModel {
  @Trace actionType: number = 0
  @Trace allWalletList: Array<Wallet> = []
  @Trace walletList: Array<Wallet> = []
  @Trace searchMonth: string[] = ['2025年', '6月']
  @Trace selectMonth: string[] = ['2025年', '6月']
  @Trace datePickerSheet: boolean = false
  private years: string[] = Constants.YEAR_PICKER
  private months: string[] = Constants.MONTH_PICKER
  multi: string[][] = [this.years, this.months]
  private scientificFormat: intl.NumberFormat = new intl.NumberFormat('zh-CN', { minimumFractionDigits: 2, });
  private static _instance: MyWalletViewModel;
  @Trace globalInfo: GlobalUtils = AppStorageV2.connect(GlobalUtils, () => new GlobalUtils())!;

  static get instance() {
    if (!MyWalletViewModel._instance) {
      MyWalletViewModel._instance = new MyWalletViewModel();
    }
    return MyWalletViewModel._instance;
  }

  constructor() {
    super();
    this.getMyWalletList();
  }

  getMyWalletList() {
    HttpRequest.getMyWalletList().then(res => {
      this.allWalletList = res
      this.filterWalletListByMonth();
    })
  }

  filterWalletListByMonth() {
    this.walletList = this.allWalletList.filter(v => {
      const year = new Date(v.time).getFullYear();
      const month = new Date(v.time).getMonth() + 1;
      if (this.searchMonth[0].slice(0, -1) === year.toString() &&
        this.searchMonth[1].slice(0, -1) === month.toString()) {
        return true;
      }
      return false;
    })
  }

  getAmount() {
    return this.scientificFormat.format(this.globalInfo.myWallet);
  }

  // 钱包充值,输入序列号
  chargeWallet() {
    const newItem: IWallet = {
      name: '充值',
      time: new Date().getTime(),
      action: 1,
      money: '100'
    };
    this.allWalletList.splice(0, 0, new Wallet(newItem));
    this.globalInfo.myWallet += 100;
    this.filterWalletListByMonth();
  }

  // 钱包消费
  consumeWallet(money: number) {
    const newItem: IWallet = {
      name: '停车缴费',
      time: new Date().getTime(),
      action: 2,
      money: money.toString(),
    };
    this.allWalletList.splice(0, 0, new Wallet(newItem));
    this.globalInfo.myWallet -= money;
    this.filterWalletListByMonth();
  }
}
