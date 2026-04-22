import { Decimal } from '@kit.ArkTS';
import { CLOUD_STORAGE_URL, GOODS_MUST, GoodSpecEnum } from '../constants/Index';
import { CarGoodsInfo, GoodsOfOrder, PackageSpec } from '../models/Index';

@ComponentV2
export struct GoodsComp {
  @Param goodsList: CarGoodsInfo[] | GoodsOfOrder[] = [];

  @Computed
  get carMustGoodsList() {
    return this.goodsList.filter(item => item.isMust === GOODS_MUST)
  }

  @Computed
  get carAddGoodsList() {
    return this.goodsList.filter(item => item.specType === GoodSpecEnum.ADD_GOODS)
  }

  @Computed
  get carPgkGoodsList() {
    return this.goodsList.filter(item => item.specType === GoodSpecEnum.PACKAGE_TYPE)
  }

  @Computed
  get carGoodsList() {
    return this.goodsList.filter(item => ![GoodSpecEnum.PACKAGE_TYPE, GoodSpecEnum.ADD_GOODS].includes(item.specType) &&
      item.isMust !== GOODS_MUST)
  }

  @Styles
  cardStyle(){
    .width($r('app.string.full_size'))
    .constraintSize({ maxWidth: $r('app.string.full_size') })
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
    .padding({
      left: 12,
      right: 12,
      top: 16,
      bottom: 16,
    })
  }

  build() {
    Column({ space: 12 }) {
      Text('订单详情').fontSize($r('sys.float.Subtitle_L')).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary')).margin({ top: 12 })
      if (this.carPgkGoodsList.length) {
        // 套餐详情
        Column() {
          List({ space: 16 }) {
            ForEach(this.carPgkGoodsList, (goodInfo: CarGoodsInfo | GoodsOfOrder) => {
              ListItem() {
                this.goodsPkgCard(goodInfo);
              };
            }, (goodInfo: CarGoodsInfo | GoodsOfOrder) => `${goodInfo.id}${goodInfo.num}${goodInfo.spec}`);
          };
        }.cardStyle();
      }
      if (this.carGoodsList.length) {
        // 单品详情
        Column() {
          List({ space: 16 }) {
            ForEach(this.carGoodsList, (goodInfo: CarGoodsInfo | GoodsOfOrder) => {
              ListItem() {
                this.goodsCard(goodInfo);
              };
            }, (goodInfo: CarGoodsInfo | GoodsOfOrder) => `${goodInfo.id}${goodInfo.num}${goodInfo.spec}`);
          };
        }.cardStyle();
      }
      if (this.carAddGoodsList.length) {
        // 超值加购详情
        Column({ space: 12 }) {
          Text('超值加购')
            .fontSize($r('sys.float.Body_M'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
          List({ space: 16 }) {
            ForEach(this.carAddGoodsList, (goodInfo: CarGoodsInfo | GoodsOfOrder) => {
              ListItem() {
                this.goodsCard(goodInfo);
              };
            }, (goodInfo: CarGoodsInfo | GoodsOfOrder) => `${goodInfo.id}${goodInfo.num}${goodInfo.spec}`);
          }.edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true });
        }.cardStyle().alignItems(HorizontalAlign.Start);
      }
      if (this.carMustGoodsList.length) {
        // 必选品详情
        Column() {
          Text($r('app.string.must_good'))
            .fontSize($r('sys.float.Body_M'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
          List({ space: 16 }) {
            ForEach(this.carMustGoodsList, (goodInfo: CarGoodsInfo | GoodsOfOrder) => {
              ListItem() {
                this.goodsCard(goodInfo);
              };
            }, (orderInfo: CarGoodsInfo | GoodsOfOrder) => orderInfo.id.toString());
          }.margin({ top: 12 });
        }.cardStyle().alignItems(HorizontalAlign.Start);
      }
    }.alignItems(HorizontalAlign.Start);

  }

  @Builder
  goodsPkgCard(goodsInfo: CarGoodsInfo | GoodsOfOrder) {
    Column() {
      Row() {
        Row() {
          Image(`${CLOUD_STORAGE_URL}${goodsInfo.logo}`).width(50).height(50).borderRadius(8)
          Column() {
            Text(goodsInfo.name)
              .fontSize($r('sys.float.Body_M'))
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Medium)
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis });

            Row() {
              Text(`x`)
                .fontSize($r('sys.float.Caption_M'))
                .fontColor($r('sys.color.font_secondary'))
              Text(`${goodsInfo.num}`)
                .fontSize($r('sys.float.Caption_L'))
                .fontColor($r('sys.color.font_secondary'))
            }.alignItems(VerticalAlign.Bottom)
          }
          .height(50)
          .margin({ left: 8 })
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.SpaceBetween);
        }.layoutWeight(1);

        Row() {
          Text($r('app.string.currency_symbol_post_params',
            new Decimal(goodsInfo.money2).mul(goodsInfo.num!).toNumber()))
            .fontSize($r('sys.float.Caption_S'))
            .fontColor($r('sys.color.font_primary'))
            .decoration({
              type: TextDecorationType.LineThrough,
              color: $r('sys.color.font_secondary'),
            });
          Text($r('app.string.discount', goodsInfo.discount))
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
            .margin({ left: 4, right: 4 });
          Text() {
            Span($r('app.string.currency_symbol'))
              .fontSize($r('sys.float.Caption_S'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
            Span(new Decimal(goodsInfo.money).mul(new Decimal(goodsInfo.num)).toString())
              .fontSize($r('sys.float.Body_M'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
          };
        }.height(50).alignItems(VerticalAlign.Bottom);
      }.width($r('app.string.full_size')).justifyContent(FlexAlign.SpaceBetween);

      Column() {
        List({ space: 8 }) {
          ForEach(goodsInfo.combination, (item: PackageSpec) => {
            ListItem() {
              Row() {
                Text(item.specName).fontSize($r('sys.float.Caption_L')).fontColor($r('sys.color.font_primary'))
                Text(`x${item.specNum}`).fontSize($r('sys.float.Caption_L')).fontColor($r('sys.color.font_secondary'))
              }.width($r('app.string.full_size')).justifyContent(FlexAlign.SpaceBetween);
            };
          }, (item: PackageSpec) => JSON.stringify(item));
        };
      }.margin({ top: 12 })
    };
  }

  @Builder
  goodsCard(goodsInfo: CarGoodsInfo | GoodsOfOrder) {
    Row() {
      Row() {
        Image(`${CLOUD_STORAGE_URL}${goodsInfo.logo}`).width(50).height(50).borderRadius(8);
        Column() {
          Column() {
            Text(goodsInfo.name)
              .fontSize($r('sys.float.Body_M'))
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Medium)
            Text(goodsInfo.spec?.split(',').join(' | '))
              .fontSize($r('sys.float.Caption_M'))
              .fontColor($r('sys.color.font_secondary'))
              .margin({ top: 4 })
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis });
          }.alignItems(HorizontalAlign.Start)

          Text(`x${goodsInfo.num}`)
            .fontSize($r('sys.float.Caption_L'))
            .fontColor($r('sys.color.font_secondary'))
            .margin({ top: 4 });
        }.height(50).margin({ left: 8 }).alignItems(HorizontalAlign.Start).justifyContent(FlexAlign.SpaceBetween)
      }.layoutWeight(1);

      Row() {
        if (goodsInfo.specType === GoodSpecEnum.ADD_GOODS) {
          Text() {
            Span($r('app.string.currency_symbol')).fontSize(8)
            Span(new Decimal(goodsInfo.money2).mul(new Decimal(goodsInfo.num)).toString()).fontSize(12)
          }.fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary')).margin({ right: 4 }).decoration({
            type: TextDecorationType.LineThrough,
            color: $r('sys.color.font_secondary'),
          });
        }
        Text() {
          Span($r('app.string.currency_symbol'))
            .fontSize($r('sys.float.Caption_S'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
          Span(new Decimal(goodsInfo.money).mul(new Decimal(goodsInfo.num)).toString())
            .fontSize($r('sys.float.Body_M'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
        };
      }.height(48).alignItems(VerticalAlign.Bottom);
    }.width($r('app.string.full_size')).justifyContent(FlexAlign.SpaceBetween);
  }
}