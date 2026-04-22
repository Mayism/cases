import { CommonUrl, Constants, MustGoodsController, MyCarModel } from 'common/Index';
import { AppStorageV2 } from '@kit.ArkUI';
import * as API from '../../api/Index';
import { CarGoodsInfoResp, DishesTypeResp } from 'network';
import { SheetHeaderComp } from 'base_ui';
import { UtilLog } from '@hw-agconnect/util-log';

const TAG = '[MyCarListComp]'

@ComponentV2
export struct MyCarListComp {
  @Local myCarModel: MyCarModel = AppStorageV2.connect(MyCarModel) as MyCarModel
  @Local mustGoodsCtrl: MustGoodsController =
    AppStorageV2.connect(MustGoodsController, () => new MustGoodsController())!
  @Event close: () => void = () => {
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
      }.width(Constants.FULL_SIZE).height(Constants.FULL_SIZE).backgroundColor($r('sys.color.mask_fourth'))
      .onClick(() => {
        this.close()
      })

      Column() {
        SheetHeaderComp({ title: '已购商品', close: this.close })
        Column({ space: 12 }) {
          Row() {
            Row() {
              SymbolGlyph($r('sys.symbol.trash')).fontSize(24).fontColor([$r('sys.color.icon_secondary'), '#000000'])
              Text($r('app.string.clear_car')).fontSize($r('sys.float.Body_M'))
                .fontColor($r('sys.color.font_secondary')).margin({ left: 8 })
            }.onClick(() => {
              API.clearCar().then(() => {
                this.mustGoodsCtrl.cleanCar()
              })
            })
          }
          .width(Constants.FULL_SIZE)
          .justifyContent(FlexAlign.End).padding({ left: 12, right: 12 })

          Divider()
          List({ space: 8 }) {
            ForEach(this.myCarModel.myCar.goodsList, (carGoodsInfo: CarGoodsInfoResp) => {
              ListItem() {
                CarCard({ carGoodsInfo: carGoodsInfo })
              }
            }, (carGoodsInfo: CarGoodsInfoResp) => `${carGoodsInfo.id}-${carGoodsInfo.num}`) // 购物车占位
            ListItem() {
              Row().width(Constants.FULL_SIZE).height(60)
            }
          }
          .width(Constants.FULL_SIZE)
          .layoutWeight(1)
          .padding({ left: 12, right: 12 })
          .scrollBar(BarState.Off)
          .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        }
        .width(Constants.FULL_SIZE)
        .padding({ top: 12 })
        .layoutWeight(1)
        .constraintSize({ maxWidth: Constants.FULL_SIZE })
        .backgroundColor($r('sys.color.background_primary'))
        .borderRadius({ topLeft: 12, topRight: 12 })
      }
      .width(Constants.FULL_SIZE)
      .height(330)
      .padding({ top: 8, left: 16, right: 16 })
      .backgroundColor($r('sys.color.background_secondary'))
      .borderRadius({ topLeft: 32, topRight: 32 })
    }

  }
}

@ComponentV2
struct CarCard {
  @Local myCarModel: MyCarModel = AppStorageV2.connect(MyCarModel) as MyCarModel
  @Local mustGoodsCtrl: MustGoodsController =
    AppStorageV2.connect(MustGoodsController, () => new MustGoodsController())!
  @Consumer('dishesList') dishesList: Array<DishesTypeResp> = []
  @Param @Require carGoodsInfo: CarGoodsInfoResp

  build() {
    Row() {
      Row() {
        Image(`${CommonUrl.CLOUD_STORAGE_URL}${this.carGoodsInfo.logo}`).width(60).height(60)
        Column() {
          Column() {
            Text(this.carGoodsInfo.name)
              .fontSize($r('sys.float.Body_M'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)
            Text() {
              Span($r('app.string.selected'))
              Span(this.carGoodsInfo.spec?.split(',').join(' | ')).margin({ left: 2 })
            }
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_secondary'))
            .margin({ top: 2 })
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          }.alignItems(HorizontalAlign.Start).layoutWeight(1)

          Text() {
            Span($r('app.string.currency_symbol'))
              .fontSize($r('sys.float.Caption_M'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
            Span(`${Number(this.carGoodsInfo.money)}`)
              .fontSize($r('sys.float.Body_M'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
          }.margin({ top: 6 })
        }
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceBetween)
        .height(60)
        .layoutWeight(1)
      }.layoutWeight(1)

      Row() {
        Image($r('app.media.ic_subtract')).width(24).onClick(() => {
          if (this.carGoodsInfo?.id && this.carGoodsInfo?.num) {
            API.updateMyCar(this.carGoodsInfo?.id, Number(this.carGoodsInfo?.num) - 1)
          }
        })
        Text(this.carGoodsInfo.num.toString())
          .margin({ left: 12, right: 12 })
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Medium)
        Image($r('app.media.add_car')).width(24).onClick(() => {
          if (this.carGoodsInfo?.id && this.carGoodsInfo?.num) {
            API.updateMyCar(this.carGoodsInfo?.id, Number(this.carGoodsInfo?.num) + 1)
          } else {
            UtilLog.error(TAG, `GoodInfo not in disheList: ${JSON.stringify(this.carGoodsInfo.goodsId)}.`);
            return
          }
        })
      }.justifyContent(FlexAlign.End)
    }.width(Constants.FULL_SIZE).justifyContent(FlexAlign.SpaceBetween).alignItems(VerticalAlign.Bottom)
  }
}