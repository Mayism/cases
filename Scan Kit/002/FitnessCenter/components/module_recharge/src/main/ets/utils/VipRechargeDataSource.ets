import { VipRechargeItem } from '../utils/VipRechargeItem';
import { BasicDataSource } from '../utils/BasicDataSource';
import { RechargeConfig } from '../constant/Constant'
export class VipRechargeDataSource extends BasicDataSource {
  private dataArray: VipRechargeItem[] = [];

  public initData(configs: RechargeConfig[]) {
    this.dataArray = configs.map(config =>
    new VipRechargeItem(config.payNumber, config.discounts)
    );
    this.notifyDataReload();
  }
  public getIndex(inputItem: VipRechargeItem): number {
    return this.dataArray.findIndex(item => {
      item.getPayNumber() === inputItem.getPayNumber() && item.getDiscounts() === inputItem.getDiscounts()
    })
  }

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): VipRechargeItem {
    return this.dataArray[index];
  }

  public pushData(data: VipRechargeItem): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public updateAllData(): void {
    this.dataArray = this.dataArray.map((item: VipRechargeItem) => {
      return item;
    });
    this.notifyDataReload();
  }
}