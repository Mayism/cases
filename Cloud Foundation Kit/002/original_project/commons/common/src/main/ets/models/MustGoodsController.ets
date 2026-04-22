import { UtilLog } from '@hw-agconnect/util-log'

@ObservedV2
export class MustGoodsController {
  // 购物车内必选商品数量
  private isMust: number = 0
  // 商铺必选商品数量
  @Trace shopIsMust: number = 0
  // 是否提交
  @Trace isChecked: boolean = false
  @Trace isNeedMustGoods: boolean = false
  @Trace showMustGoods: boolean = false

  addIsMust(num?: number) {
    if (num) {
      this.isMust = this.isMust + num
    } else {
      this.isMust++
    }
    UtilLog.info(`addIsMust isMust: ${JSON.stringify(this.isMust)}.`);
    this.change()
  }

  clickSubmit() {
    this.isChecked = true
    this.change()
  }

  changeShopIsMustGoods() {
    this.shopIsMust++
    this.change()
  }

  change() {
    this.isNeedMustGoods = this.shopIsMust > 0 && this.isMust <= 0
    this.showMustGoods = this.isChecked && this.isNeedMustGoods
  }

  cleanCar() {
    this.isChecked = false
    this.isMust = 0
    this.change()
  }

  goMustGoods = () => {
    UtilLog.info(`MustGoodsController goMustGoods.`);
  }
}