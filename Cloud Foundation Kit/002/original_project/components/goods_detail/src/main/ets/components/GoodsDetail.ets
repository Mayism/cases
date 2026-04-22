import { Decimal } from '@kit.ArkTS';
import { BUY_NOTE_LIST, Constants, GoodsSpecEnum } from '../constants/Index';
import { BuyNote, Goods, PackageSpecResp, SpecCatalogResp, SpecItemResp } from '../models/Index';
import { BreakpointNameEnum, BreakpointType, GridRowColSetting } from '../utils/GridRowColSetting';

@ComponentV2
export struct GoodsDetail {
  @Param breakpoint: string = '';
  @Param goodsInfo: Goods = new Goods();
  @Param goodSpecList: Array<SpecCatalogResp> = [];
  @Param selectSpecArr: Array<PackageSpecResp> = [];
  @Param goodSinglePrice: number = 0;
  @Local goodNum: number = 1;
  @Local swiperIndex: number = 0;
  @Local showMore: boolean = false;
  @Local expandMore: boolean = false;
  @Local textSize?: SizeOptions = undefined;
  private scroller: Scroller = new Scroller();
  private indicatorController: IndicatorComponentController = new IndicatorComponentController();

  @Computed
  get sumPrice() {
    return new Decimal(this.goodSinglePrice).mul(this.goodNum).toNumber();
  }

  @Event clickAddCarCb: (goodNum: number) => void = () => {
  }
  @Event getSelectSpec: (item: SpecItemResp, index: number) => void = () => {
  }

  build() {
    Column() {
      Scroll(this.scroller) {
        Column() {
          Column({ space: 12 }) {
            Column() {
              Swiper() {
                ForEach(this.goodsInfo?.bigImg, (item: string) => {
                  Image(`${Constants.CLOUD_STORAGE_URL}${item}`).width('100%').height(300);
                }, (item: string) => `${item}`)
              }
              .prevMargin(new BreakpointType({
                [BreakpointNameEnum.SM]: 0,
                [BreakpointNameEnum.MD]: 180,
                [BreakpointNameEnum.LG]: 180,
                [BreakpointNameEnum.XL]: 180,
              }).getValue(this.breakpoint))
              .nextMargin(new BreakpointType({
                [BreakpointNameEnum.SM]: 0,
                [BreakpointNameEnum.MD]: 180,
                [BreakpointNameEnum.LG]: 180,
                [BreakpointNameEnum.XL]: 180,
              }).getValue(this.breakpoint))
              .itemSpace(20)
              .loop(true)
              .autoPlay(true)
              .vertical(false)
              .indicator(this.breakpoint === BreakpointNameEnum.SM ?
                new DotIndicator().selectedColor($r('sys.color.multi_color_09')) : this.indicatorController)
              .interval(2000)
              .borderRadius(this.breakpoint === BreakpointNameEnum.SM ? 0 : 20)
              .onChange((index) => {
                this.swiperIndex = index;
              })

              Row() {
                IndicatorComponent(this.indicatorController)
                  .initialIndex(0)
                  .style(
                    new DotIndicator()
                      .itemWidth(6)
                      .itemHeight(6)
                      .selectedItemWidth(12)
                      .selectedItemHeight(6)
                      .color($r('sys.color.comp_background_secondary'))
                      .selectedColor($r('sys.color.multi_color_09')))
                  .loop(true)
                  .count(this.goodsInfo?.bigImg.length)
                  .vertical(true)
              }
              .width('100%')
              .height(32)
              .padding({ top: 12, bottom: 12 })
              .justifyContent(FlexAlign.Center)
              .margin({ top: 4 })
              .visibility(this.breakpoint === BreakpointNameEnum.SM ? Visibility.None : Visibility.Visible)

              Column() {
                Row() {
                  Text(this.goodsInfo?.name)
                    .fontSize($r('sys.float.Subtitle_L'))
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('sys.color.font_primary'))
                    .layoutWeight(1)
                  Text() {
                    Span($r('app.string.currency_symbol'))
                      .fontSize($r('sys.float.Caption_M'))
                      .fontWeight(FontWeight.Medium)
                    Span(this.goodsInfo?.money.toString())
                      .fontSize($r('sys.float.Subtitle_L'))
                      .fontWeight(FontWeight.Medium)
                  }.fontColor($r('sys.color.multi_color_09'));
                }.width('100%')
                .justifyContent(FlexAlign.SpaceBetween);

                Row() {
                  Text(Number(this.goodsInfo?.sales) > 100 ? $r('app.string.sales_more') :
                    $r('app.string.month_sale', this.goodsInfo?.sales))
                    .fontSize($r('sys.float.Caption_M'))
                    .fontColor($r('sys.color.font_tertiary'))
                    .margin({ top: 4 });
                  if (this.goodsInfo?.specType === GoodsSpecEnum.PACKAGE_TYPE) {
                    Row() {
                      Text($r('app.string.discount', this.goodsInfo.discount))
                        .fontSize($r('sys.float.Caption_S'))
                        .fontColor($r('sys.color.multi_color_09'))
                        .padding({ left: 5, right: 5 })
                        .borderWidth(1)
                        .borderColor($r('sys.color.multi_color_09'))
                        .borderRadius(4)
                        .margin({ top: 3, bottom: 3 });
                      Text($r('app.string.currency_symbol_post_params', this.goodsInfo?.money2))
                        .fontSize($r('sys.float.Caption_S'))
                        .fontColor($r('sys.color.font_primary'))
                        .margin({ left: 6 })
                        .decoration({
                          type: TextDecorationType.LineThrough,
                          color: $r('sys.color.font_secondary'),
                        });
                    };
                  }
                }.width('100%').justifyContent(FlexAlign.SpaceBetween);
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .backgroundColor($r('sys.color.background_primary'))
              .margin(this.breakpoint === BreakpointNameEnum.SM ? 0 : {
                left: GridRowColSetting.getPageMargin(this.breakpoint),
                right: GridRowColSetting.getPageMargin(this.breakpoint),
              })
              .constraintSize({ maxWidth: '100%' })
              .borderRadius(this.breakpoint === BreakpointNameEnum.SM ? 0 : 20)
              .padding({
                left: GridRowColSetting.getPageMargin(this.breakpoint),
                right: GridRowColSetting.getPageMargin(this.breakpoint),
                top: 12,
                bottom: 12,
              });

            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)

            if (this.goodsInfo?.specType === GoodsSpecEnum.SPEC_TYPE) {
              this.goodSpecComp();
              this.goodDetailComp();
            } else if (this.goodsInfo?.specType === GoodsSpecEnum.PACKAGE_TYPE) {
              this.goodPkgComp();
            } else {
              this.goodDetailComp();
            }
          };
        };
      }
      .backgroundColor($r('sys.color.background_secondary'))
      .layoutWeight(1)
      .edgeEffect(EdgeEffect.Spring)
      .scrollBar(BarState.Off)
      .align(Alignment.Top);

      Column() {
        Row() {
          Column() {
            Text() {
              Span($r('app.string.currency_symbol'))
                .fontSize($r('sys.float.Caption_M'))
                .fontColor($r('sys.color.font_primary'))
              Span(`${Number(this.sumPrice)}`)
                .fontSize($r('sys.float.Subtitle_L'))
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_primary'))
            };

            Text() {
              Span($r('app.string.selected'));
              Span(this.selectSpecArr.map(item => item?.specName).join('/'));
            }
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_secondary'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis });
          }.alignItems(HorizontalAlign.Start).layoutWeight(1);

          Row() {
            Image($r('app.media.ic_subtract')).width(24).onClick(() => {
              if (Number(this.goodNum) > 1) {
                this.goodNum = this.goodNum - 1;
              }
            });
            Text(this.goodNum.toString())
              .margin({ left: 12, right: 12 })
              .fontSize($r('sys.float.Body_L'))
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Medium)
            Image($r('app.media.add_car')).width(24).onClick(() => {
              this.goodNum = this.goodNum + 1;
            });
          }.alignItems(VerticalAlign.Center);
        }.width('100%').justifyContent(FlexAlign.SpaceBetween);

        Row() {
          Text($r('app.string.add_car'))
            .fontSize($r('sys.float.Body_M'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_on_primary'))
        }
        .borderRadius(18)
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .constraintSize({ maxWidth: 448 })
        .margin({ top: 12 })
        .padding({ top: 8, bottom: 8 })
        .backgroundColor($r('sys.color.multi_color_09'))
        .onClick(() => {
          this.clickAddCarCb(this.goodNum);
        });
      }
      .width('100%')
      .constraintSize({ maxWidth: '100%' })
      .padding({
        left: 18,
        right: 18,
        top: 12,
        bottom: 8,
      })
      .justifyContent(FlexAlign.Start);
    }
    .width('100%')
  }

  @Builder
  goodDetailComp() {
    // 商品详情
    Column() {
      Text($r('app.string.good_details'))
        .fontSize($r('sys.float.Body_L'))
        .fontColor($r('sys.color.font_primary'))
      Image(`${Constants.CLOUD_STORAGE_URL}${this.goodsInfo?.details}`).width('100%').margin({ top: 16 })
    }
    .width('100%')
    .padding({
      left: 12,
      right: 12,
      top: 16,
      bottom: 16,
    })
    .borderRadius(16)
    .alignItems(HorizontalAlign.Start)
    .margin({
      left: GridRowColSetting.getPageMargin(this.breakpoint),
      right: GridRowColSetting.getPageMargin(this.breakpoint), bottom: 12,
    })
    .constraintSize({ maxWidth: '100%' })
    .backgroundColor($r('sys.color.background_primary'));
  }

  @Builder
  goodSpecComp() {
    Column({ space: 8 }) {
      ForEach(this.goodSpecList, (goodSpec: SpecCatalogResp, index: number) => {
        Row() {
          Text(goodSpec.specName)
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
            .width(64)
            .margin({ top: 10, bottom: 10, right: 10 });
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(goodSpec.specVal, (item: SpecItemResp) => {
              Row() {
                Text(item.specValName)
                  .fontSize($r('sys.float.Body_S'))
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.selectSpecArr[index]?.specName === item.specValName ?
                    $r('sys.color.font_on_primary') :
                    $r('sys.color.font_secondary'))
              }
              .padding({
                left: 12,
                right: 12,
                top: 8,
                bottom: 8,
              })
              .margin({ right: 8, bottom: 8 })
              .backgroundColor(this.selectSpecArr[index]?.specName === item.specValName ?
                $r('sys.color.multi_color_09') : $r('sys.color.background_primary'))
              .borderRadius(20)
              .border(this.selectSpecArr[index]?.specName === item.specValName ?
                { width: 0 } : { width: 1, color: '#66000000' })
              .onClick(() => {
                if (this.selectSpecArr && this.selectSpecArr[index]) {
                  this.getSelectSpec(item, index)

                }

              });
            }, (item: SpecItemResp) => item.specValId);
          }.margin({ left: 8 });
        }.alignItems(VerticalAlign.Top);
      }, (goodSpec: SpecCatalogResp) => goodSpec.specId);
    }
    .width('100%')
    .padding({
      left: 12,
      right: 12,
      top: 16,
      bottom: 16,
    })
    .borderRadius(16)
    .margin({
      left: GridRowColSetting.getPageMargin(this.breakpoint),
      right: GridRowColSetting.getPageMargin(this.breakpoint),
    })
    .constraintSize({ maxWidth: '100%' })
    .justifyContent(FlexAlign.Start)
    .backgroundColor($r('sys.color.background_primary'));
  }

  @Builder
  goodPkgComp() {
    Column({ space: 12 }) {
      Text($r('app.string.package_details'))
        .fontSize($r('sys.float.Body_L'))
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Medium)
      Column() {
        ForEach(this.goodSpecList, (goodSpec: SpecCatalogResp, index: number) => {
          Column() {
            Row() {
              Column()
                .width(2)
                .height(14)
                .backgroundColor($r('sys.color.multi_color_09'))
                .borderRadius(2);
              Text(`${goodSpec.specName}`)
                .fontSize($r('sys.float.Body_M'))
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_primary'))
                .margin({ left: 8 });
            }.width('100%');

            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(goodSpec.specVal, (item: SpecItemResp) => {
                Column() {
                  Image(`${Constants.CLOUD_STORAGE_URL}${item.specValLogo}`).width(88).height(80).borderRadius(8);
                  Text(item.specValName)
                    .fontSize($r('sys.float.Caption_M'))
                    .height(26)
                    .fontColor(this.selectSpecArr[index].specName === item.specValName ?
                      $r('sys.color.multi_color_09') :
                      $r('sys.color.font_secondary'))
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .margin({ top: 6 })
                    .width('100%');
                  Text(`x${item.specValNum}`)
                    .fontSize($r('sys.float.Caption_L'))
                    .fontColor(this.selectSpecArr[index].specName === item.specValName ?
                      $r('sys.color.multi_color_09') :
                      $r('sys.color.font_secondary'))
                    .width('100%')
                    .textAlign(TextAlign.End);
                }
                .width(100)
                .height(140)
                .padding(6)
                .margin({ right: 6, bottom: 12 })
                .backgroundColor(this.selectSpecArr[index].specName === item.specValName ? '#1AED6F21' :
                  $r('sys.color.background_secondary'))
                .borderRadius(8)
                .border(this.selectSpecArr[index].specName === item.specValName ?
                  { width: 1, color: $r('sys.color.multi_color_09') } : { width: 0 })
                .onClick(() => {
                  this.getSelectSpec(item, index)

                });
              }, (item: SpecItemResp) => item.specValId);
            };

          }.justifyContent(FlexAlign.Start).alignItems(HorizontalAlign.Start);
        }, (goodSpec: SpecCatalogResp) => goodSpec.specId);
      }
      .width('100%')
      .constraintSize({ maxWidth: '100%' })
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('sys.color.background_primary'))
      .borderRadius(16)
      .padding({
        left: 12,
        right: 12,
        top: 16,
        bottom: 16,
      })

      Text($r('app.string.buy_notes'))
        .fontSize($r('sys.float.Body_L'))
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Medium)
      Column() {
        List({ space: 12 }) {
          ForEach(BUY_NOTE_LIST, (item: BuyNote) => {
            ListItem() {
              this.buyNoteCard(item);
            };
          }, (item: BuyNote) => JSON.stringify(item.noteTitle));
        }.divider({ strokeWidth: 1, startMargin: 28 });
      }
      .width('100%')
      .constraintSize({ maxWidth: '100%' })
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('sys.color.background_primary'))
      .borderRadius(16)
      .padding({
        left: 12,
        right: 12,
        top: 16,
        bottom: 16,
      })
    }.alignItems(HorizontalAlign.Start)
    .margin({
      top: 12,
      bottom: 12,
      left: GridRowColSetting.getPageMargin(this.breakpoint),
      right: GridRowColSetting.getPageMargin(this.breakpoint),
    })
  }

  @Builder
  buyNoteCard(item: BuyNote) {
    Row() {
      Image(item.icon).width(16).margin({ top: 2 });
      Column() {
        Text(item.noteTitle)
          .fontSize($r('sys.float.Body_S'))
          .fontColor($r('sys.color.font_primary'))
          .margin({ bottom: 2 })
        ForEach(item.noteDesc, (str: ResourceStr, index: number) => {
          if (index === 1 && !this.expandMore) {
            Text(str)
              .fontSize($r('sys.float.Caption_M'))
              .fontColor($r('sys.color.font_secondary'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .onAreaChange((newValue: Area) => {
                this.textSize = this.getUIContext().getMeasureUtils().measureTextSize({
                  textContent: str,
                  fontSize: $r('sys.float.Caption_M'),
                })
                if (item.noteDesc.length > 2 ||
                  (this.textSize?.width && newValue.width &&
                    this.getUIContext().px2vp(Number(this.textSize?.width)) > newValue.width)) {
                  this.showMore = true
                }
              })
          } else if (index < 2 || this.expandMore) {
            Text(str)
              .fontSize($r('sys.float.Caption_M'))
              .fontColor($r('sys.color.font_secondary'))
          }
        }, (str: ResourceStr) => JSON.stringify(str));

        if (item.noteDesc.length > 1 && this.showMore) {
          Row() {
            Text($r('app.string.show_more')).fontSize($r('sys.float.Caption_S')).fontColor($r('sys.color.font_primary'))
            Image(this.expandMore ? $r('app.media.ic_up') : $r('app.media.ic_down'))
              .width(16)
              .height(16)
              .margin({ left: 8 })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ top: 12 })
          .onClick(() => {
            this.expandMore = !this.expandMore
          })
        }

      }.alignItems(HorizontalAlign.Start).margin({ left: 12 }).layoutWeight(1)
    }.width('100%').alignItems(VerticalAlign.Top);
  }
}
