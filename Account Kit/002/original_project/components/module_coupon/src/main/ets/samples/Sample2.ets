import { SelectCoupons } from '../pages/SelectCouponsPage';

@Entry
@ComponentV2
struct Sample2 {
  @Local selectedCouponID: string = '';
  @Local selectedCouponMoney: number = 0;
  @Local showCouponSheet: boolean = false;

  @Builder
  selectCouponBuilder() {
    Column() {
      SelectCoupons({
        selectIdParam: this.selectedCouponID,
        onSelect: (id: string, money: number) => {
          this.selectedCouponID = id;
          this.selectedCouponMoney = money;
          this.showCouponSheet = false;
        },
      })
    }
    .padding(10)
  }

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Text(`选择的优惠券ID：  ${this.selectedCouponID}`)
        Text(`选择的优惠券面额： ${this.selectedCouponMoney}`)
        Button('选择')
          .width('100%')
          .onClick(() => {
            this.showCouponSheet = true;
          })
          .bindSheet($$this.showCouponSheet, this.selectCouponBuilder(), {
            height: SheetSize.MEDIUM,
            preferType: SheetType.CENTER,
            title: {
              title: '选择优惠券',
            },
          })
      }
      .padding(12)
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .height('100%')
    .width('100%')
    .title('选择优惠券')
  }
}