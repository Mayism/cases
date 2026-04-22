import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import {
  Constants,
  MustGoodsController,
  MyCarModel,
  RouterMap,
  RouterModule,
  StoreInfoModel,
  UserInfoModel,
} from 'common/Index';

@ComponentV2
export struct MyCarComp {
  @Local myCarModel: MyCarModel = AppStorageV2.connect(MyCarModel) as MyCarModel
  @Local storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!;
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!
  @Local mustGoodsCtrl: MustGoodsController =
    AppStorageV2.connect(MustGoodsController, () => new MustGoodsController())!
  @Consumer('orderId') orderId: string = ''
  @Param @Require showCarList: boolean
  @Local buttonStr: Resource = $r('app.string.place_order')
  @Event changeCarListShow: (flag: boolean) => void = () => {
  }

  aboutToAppear(): void {
    this.change()
  }

  @Monitor('myCarModel.myCar.money')
  carChange() {
    this.mustGoodsCtrl.cleanCar()
    this.myCarModel.myCar.goodsList?.forEach(item => {
      if (item.isMust === Constants.GOODS_MUST) {
        this.mustGoodsCtrl.addIsMust(Number(item.num))
      }
    })
    this.mustGoodsCtrl.change()
  }

  @Monitor('orderId','storeModel.storeInfo.id')
  change() {
    if (this.storeModel.isRest) {
      this.buttonStr = $r('app.string.store_rest')
    } else if (this.orderId) {
      this.buttonStr = $r('app.string.add_good')
    } else {
      this.buttonStr = $r('app.string.place_order')
    }
  }

  build() {
    Row() {
      Row() {
        Badge({
          count: this.myCarModel.myCar.goodsList?.length ?? 0,
          style: { fontSize: 10, badgeSize: 16 },
        }) {
          Image($r('app.media.buy_car')).width(36)
        }

        Text() {
          Span($r('app.string.total_price'))
            .fontSize($r('sys.float.Body_M'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
          Span($r('app.string.currency_symbol'))
            .fontSize($r('sys.float.Caption_M'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.multi_color_09'))
          Span(`${Number(this.myCarModel.myCar.money)}`)
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.multi_color_09'))
            .fontWeight(FontWeight.Medium)
        }.margin({ left: 16 })

      }.layoutWeight(1).onClick(() => {
        this.changeCarListShow(!this.showCarList)
      })


      Button(this.buttonStr)
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_on_primary'))
        .backgroundColor($r('sys.color.multi_color_09'))
        .padding({
          left: 11,
          right: 11,
          top: 6,
          bottom: 6,
        })
        .onClick(() => {
          if (this.storeModel.isRest) {
            promptAction.showToast({ message: '小店休息一下~~' })
          } else if (!this.userInfoModel.isRelative) {
            promptAction.showToast({ message: '请先关联账号~' })
            return
          } else if (!this.myCarModel.myCar.goodsList?.length) {
            promptAction.showToast({ message: '请选择商品后下单' })
          } else if (this.mustGoodsCtrl.isNeedMustGoods) {
            this.mustGoodsCtrl.clickSubmit()
            this.mustGoodsCtrl.goMustGoods()
            promptAction.showToast({ message: '请选择必选品' })
          } else {
            this.changeCarListShow(false)
            this.mustGoodsCtrl.clickSubmit()
            RouterModule.push(RouterMap.CONFIRM_ORDER_PAGE)
          }
        })
    }
    .width(Constants.FULL_SIZE)
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('sys.color.background_primary'))
    .justifyContent(FlexAlign.SpaceBetween)
    .shadow({
      radius: 4,
      color: '#0D000000',
      offsetX: 0,
      offsetY: -4,
    })
  }
}