import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { UtilLog } from '@hw-agconnect/util-log';
import { Decimal } from '@kit.ArkTS';
import { AppStorageV2 } from '@kit.ArkUI';
import { BIND_SHEET_STYLE } from 'base_ui';
import {
  CarGoodsInfo,
  CommonUrl,
  Constants,
  GoodsSpecEnum,
  MustGoodsController,
  MyCarModel,
  PackageSpec,
  RouterMap,
  RouterModule,
} from 'common/Index';
import { GoodsSpecResp, SpecCatalogResp, SpecItemResp } from 'network';
import * as API from '../../api/Index';
import { Goods } from '../../models/Index';

const TAG = '[GoodInfoComp]'

// 子列表
@ComponentV2
export struct GoodInfoComp {
  @Local myCarModel: MyCarModel = AppStorageV2.connect(MyCarModel) as MyCarModel
  @Local mustGoodsCtrl: MustGoodsController =
    AppStorageV2.connect(MustGoodsController, () => new MustGoodsController())!
  @Param @Require item: Goods = new Goods();
  @Local carGoodsInfo: CarGoodsInfo = new CarGoodsInfo();
  @Local goodNum: string = '1';
  @Local goodSpecList: Array<SpecCatalogResp> = [];
  @Local sumPrice: number = this.item.money ?? 0;
  @Local selectSpecArr: Array<PackageSpec> = [];
  @Local selectSpecInfo?: GoodsSpecResp = undefined;
  @Local goodSinglePrice: number = 0;
  @Local specSheetFlag: boolean = false;
  @Local showGoodContent: boolean = true;
  @Local goodTextWidth: number = 0;
  private scroller: Scroller = new Scroller();

  @Monitor('myCarModel.myCar.money')
  myCarChange(monitor: IMonitor) {
    if (monitor.value()?.now !== undefined) {
      let carGoodsInfo = this.myCarModel.myCar.goodsList?.find((item: CarGoodsInfo) => item.goodsId === this.item.id)!;
      UtilLog.info(TAG, `CarGoodsInfo: ${JSON.stringify(carGoodsInfo)}.`);
      if (carGoodsInfo) {
        this.carGoodsInfo.update(carGoodsInfo)
      } else {
        this.carGoodsInfo.goodsId = this.item.id
        this.carGoodsInfo.num = 0
      }
      UtilLog.info(TAG, `this CarGoodsInfo: ${JSON.stringify(this.carGoodsInfo)}.`);
    }
  }

  goodChange() {
    let nameWidth: number = this.getUIContext().getMeasureUtils().measureText({
      textContent: this.item.name,
      fontSize: '14px',
    })
    if (nameWidth > this.goodTextWidth) {
      this.showGoodContent = false;
    } else {
      this.showGoodContent = true;
    }
  }

  goGoodDetail() {
    RouterModule.push(RouterMap.GOODS_DETAIL_PAGE, { 'goodsId': this.item.id } as Record<string, string>);
  }

  build() {
    Row() {
      // 基础URL拼接返回的imageURL地址
      Image(`${CommonUrl.CLOUD_STORAGE_URL}${this.item?.logo}`).width(82).height(82).borderRadius(8).onClick(() => {
        this.goGoodDetail();
      });
      Column() {
        Column() {
          Text(this.item?.name)
            .fontSize($r('sys.float.Body_M'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis });
          if (this.showGoodContent) {
            Text(this.item?.content)
              .fontSize($r('sys.float.Caption_M'))
              .lineHeight(14)
              .fontColor($r('sys.color.font_secondary'))
              .margin({ top: 2 })
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis });
          }
          Text(Number(this.item?.sales) > 100 ? $r('app.string.sales_more') :
            $r('app.string.month_sale', this.item?.sales))
            .fontSize($r('sys.float.Caption_M'))
            .lineHeight(14)
            .fontColor($r('sys.color.font_secondary'))
            .margin({ top: 2 });
        }.alignItems(HorizontalAlign.Start).onClick(() => {
          this.goGoodDetail();
        });

        Row() {
          Row() {
            Text() {
              Span($r('app.string.currency_symbol'))
                .fontSize($r('sys.float.Caption_S'))
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_primary'))
              Span(`${Number(this.item?.money)}`)
                .fontSize($r('sys.float.Body_M'))
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_primary'))
            };

            if (this.item.specType === GoodsSpecEnum.PACKAGE_TYPE) {
              Text($r('app.string.discount', this.item.discount))
                .fontSize($r('sys.float.Caption_L'))
                .fontColor($r('sys.color.multi_color_09'))
                .padding({
                  left: 4,
                  right: 4,
                  top: 2,
                  bottom: 2,
                })
                .borderWidth(1)
                .borderColor($r('sys.color.multi_color_09'))
                .borderRadius(4)
                .margin({ left: 4 });
              Text($r('app.string.currency_symbol_post_params', this.item?.money2))
                .fontSize($r('sys.float.Caption_S'))
                .fontColor($r('sys.color.font_primary'))
                .lineHeight(14)
                .margin({ left: 4 })
                .decoration({
                  type: TextDecorationType.LineThrough,
                  color: $r('sys.color.font_secondary'),
                });
            }

          };


          if (this.item?.specType === GoodsSpecEnum.NORMAL) {
            Row() {
              Image($r('app.media.ic_subtract'))
                .width(24)
                .height(24)
                .onClick(() => {
                  if (this.carGoodsInfo?.id && this.carGoodsInfo?.num && this.carGoodsInfo?.num !== 0) {
                    this.carGoodsInfo.num--
                    API.updateMyCar(this.carGoodsInfo.id, this.carGoodsInfo.num)
                  }
                })
                .visibility(this.carGoodsInfo.num !== 0 ? Visibility.Visible : Visibility.Hidden);
              Text(this.carGoodsInfo.num.toString())
                .margin({ left: 8, right: 8 })
                .fontSize($r('sys.float.Body_M'))
                .fontColor($r('sys.color.font_secondary'))
                .fontWeight(FontWeight.Medium)
                .visibility(this.carGoodsInfo.num !== 0 ? Visibility.Visible :
                  Visibility.Hidden);
              Image($r('app.media.add_car')).width(24).height(24).onClick(() => {
                this.carGoodsInfo.num++
                API.addCar(this.item)
              });
            }.padding({ right: 1 });

          } else {
            Row() {
              Text(this.item?.specType === GoodsSpecEnum.PACKAGE_TYPE ? $r('app.string.select_package') :
                $r('app.string.select_spec'))
                .fontSize($r('sys.float.Caption_M'))
                .fontColor($r('sys.color.background_primary'))
                .padding({
                  top: 4,
                  bottom: 4,
                  left: 8,
                  right: 8,
                });
            }
            .borderRadius(14)
            .backgroundColor($r('sys.color.multi_color_09'))
            .onClick(() => {
              if (this.item?.specType === GoodsSpecEnum.PACKAGE_TYPE) {
                this.goGoodDetail();
                return;
              }
              API.getGoodInfo(this.item.id).then((resp: Goods) => {
                this.goodSpecList = resp.spec ?? [];
                this.selectSpecArr = this.goodSpecList.map((item: SpecCatalogResp) => {
                  let goodSpec = item.specVal.find((spec: SpecItemResp) => item.specValId === spec.specValId);
                  let result: PackageSpec = {
                    specName: goodSpec?.specValName ?? item.specVal[0].specValName,
                    specNum: Number(goodSpec?.specValNum ?? 0),
                  };
                  return result;
                });
                API.getGoodSpec(this.item.id, this.selectSpecArr).then((resp) => {
                  this.selectSpecInfo = resp;
                  this.goodSinglePrice = Number(resp.money);
                  this.sumPrice = new Decimal(this.goodSinglePrice).mul(this.goodNum).toNumber();
                });
                this.goodNum = '1'
                this.specSheetFlag = true;
              });
            });

          }
        }.margin({ top: 6 }).width(Constants.FULL_SIZE).height(22).justifyContent(FlexAlign.SpaceBetween);

      }
      .layoutWeight(1)
      .height(Constants.FULL_SIZE)
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ left: 5.5, top: 1, bottom: 1 })
      .alignItems(HorizontalAlign.Start)
      .onAreaChange((oldValue, newValue) => {
        if (newValue.width && oldValue.width !== newValue.width) {
          this.goodTextWidth = Number(newValue.width);
          this.goodChange();
        }
      });
    }
    .alignItems(VerticalAlign.Top)
    .width(Constants.FULL_SIZE)
    .height(80)
    .backgroundColor(this.item.isMust === Constants.GOODS_MUST && this.mustGoodsCtrl.showMustGoods ? '#0FF9A01E' :
      '#FFFFFF')
    .justifyContent(FlexAlign.SpaceBetween)
    .bindSheet($$this.specSheetFlag, this.specSheet(), {
      detents: [462, 463],
      backgroundColor: $r('sys.color.background_fourth'),
      blurStyle: BlurStyle.Thick,
      preferType: SheetType.CENTER,
      title: { title: '' },
    });
  }

  @Builder
  specSheet() {
    Column() {
      Row() {
        Image(`${CommonUrl.CLOUD_STORAGE_URL}${this.item.logo}`).width(80).height(80);
        Column() {
          Column() {
            Text(this.item.name)
              .fontSize($r('sys.float.Subtitle_L'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
              .lineHeight(20);
            Text() {
              Span($r('app.string.selected'));
              Span(this.selectSpecArr.map(item => item.specName).join(' | '));
            }
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_secondary'))
            .margin({ top: 2 })
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis });
          }.alignItems(HorizontalAlign.Start)

          Text() {
            Span($r('app.string.currency_symbol'))
              .fontSize($r('sys.float.Caption_M'))
              .fontColor($r('sys.color.multi_color_09'))
            Span(`${Number(this.sumPrice)}`)
              .fontSize($r('sys.float.Subtitle_L'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.multi_color_09'))
          }
        }.alignItems(HorizontalAlign.Start).margin({ left: 8 }).justifyContent(FlexAlign.SpaceBetween).height(80)
      }.width(Constants.FULL_SIZE).justifyContent(FlexAlign.Start).padding({ left: 12, right: 12 })

      Scroll(this.scroller) {
        Column() {
          ForEach(this.goodSpecList, (goodSpec: SpecCatalogResp, index: number) => {
            Column() {
              Text(goodSpec.specName)
                .fontSize($r('sys.float.Body_M'))
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_primary'))
              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(goodSpec.specVal, (item: SpecItemResp) => {
                  Row() {
                    Text(item.specValName)
                      .fontSize($r('sys.float.Caption_M'))
                      .fontWeight(FontWeight.Medium)
                      .fontColor(this.selectSpecArr[index].specName === item.specValName ?
                        $r('sys.color.font_on_primary') :
                        $r('sys.color.font_primary'))
                  }
                  .padding({
                    left: 12,
                    right: 12,
                    top: 4,
                    bottom: 4,
                  })
                  .margin({ right: 8, bottom: 8 })
                  .backgroundColor(this.selectSpecArr[index].specName === item.specValName ?
                    $r('sys.color.multi_color_09') : $r('sys.color.comp_background_tertiary'))
                  .borderRadius(12)
                  .onClick(() => {
                    let pkgSpec: PackageSpec = {
                      specName: item.specValName,
                      specNum: Number(item.specValNum),
                    };
                    this.selectSpecArr[index] = pkgSpec;
                    API.getGoodSpec(this.item.id, this.selectSpecArr).then((resp) => {
                      this.selectSpecInfo = resp;
                      this.goodSinglePrice = Number(resp.money);
                      this.sumPrice = new Decimal(this.goodSinglePrice).mul(this.goodNum).toNumber();
                    });
                  });
                }, (item: SpecItemResp) => item.specValId);
              }.margin({ top: 12 })

            }.alignItems(HorizontalAlign.Start).margin({ top: 20 });
          }, (goodSpec: SpecCatalogResp) => goodSpec.specId);
          Row() {
            Text($r('app.string.good_number'))
              .fontSize($r('sys.float.Body_S'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))

            Row() {
              Image($r('app.media.ic_subtract')).width(24).onClick(() => {
                if (Number(this.goodNum) > 1) {
                  this.goodNum = `${Number(this.goodNum) - 1}`;
                  this.sumPrice = new Decimal(this.goodSinglePrice).mul(this.goodNum).toNumber();
                }
              });
              Text(this.goodNum)
                .fontSize($r('sys.float.Body_M'))
                .fontColor($r('sys.color.font_secondary'))
                .fontWeight(FontWeight.Medium)
                .margin({ left: 8, right: 8 })
              Image($r('app.media.add_car')).width(24).onClick(() => {
                this.goodNum = `${Number(this.goodNum) + 1}`;
                this.sumPrice = new Decimal(this.goodSinglePrice).mul(this.goodNum).toNumber();
              });
            }
          }.width(Constants.FULL_SIZE).margin({ top: 20 }).justifyContent(FlexAlign.SpaceBetween).height(43)
        };
      }
      .layoutWeight(1)
      .padding({ top: 12, left: 12, right: 12 })
      .scrollBar(BarState.Off);

      Row() {
        Button($r('app.string.add_car'))
          .fontSize($r('sys.float.Body_M'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_on_primary'))
          .margin(2)
          .width(Constants.FULL_SIZE)
          .constraintSize({ maxWidth: Constants.FULL_SIZE })
          .backgroundColor($r('sys.color.multi_color_09'))
          .onClick(() => {
            if (!this.selectSpecInfo) {
              UtilLog.info(TAG, `add car empty.`);
              return;
            }
            API.addCarSpec(this.selectSpecInfo, this.item.id, Number(this.goodNum)).then(() => {
              promptAction.showToast({ message: '添加成功！' });
              if (this.selectSpecInfo?.isMust === Constants.GOODS_MUST) {
                this.mustGoodsCtrl.addIsMust();
              }
              this.goodNum = '1';
              this.specSheetFlag = false;
            });
          });
      }.margin({ top: 24, bottom: 32 })
      .padding({ top: 16 })
    }
    .attributeModifier(BIND_SHEET_STYLE)
  }
}