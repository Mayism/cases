import { AppStorageV2 } from '@kit.ArkUI';
import { BreakpointNameEnum, BreakpointType, Constants, MustGoodsController } from 'common/Index';
import { DishesTypeResp } from 'network';
import { Goods } from '../../models/Index';
import { GoodInfoComp } from './GoodInfoComp';

@ComponentV2
export struct OrderListComp {
  @Param breakpoint: string = ''
  // 展示的商品列表
  @Consumer('dishesList') dishesList: Array<DishesTypeResp> = []
  // 原始商品列表
  @Consumer('dishesListOri') dishesListOri: Array<DishesTypeResp> = []
  @Local mustGoodsCtrl: MustGoodsController =
    AppStorageV2.connect(MustGoodsController, () => new MustGoodsController())!
  @Local currentIndex: number = 0;
  @Local index: number = 0
  // 当前搜索关键字
  @Local searchText: string = '';
  private titleItemScroller: Scroller = new Scroller();
  private scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    if (this.mustGoodsCtrl) {
      this.mustGoodsCtrl.goMustGoods = this.goMustGoods
    }
  }

  @Monitor('dishesList')
  dishesListChange(monitor: IMonitor) {
    if (monitor.value()?.now) {
      this.index = this.dishesList.findIndex(item => item.goods?.some(i => i.isMust === Constants.GOODS_MUST))
    }
  }

  goMustGoods = () => {
    if (this.mustGoodsCtrl.isNeedMustGoods && this.index >= 0) {
      // 搜索占据第一个索引，这里需要给index+1
      this.scroller.scrollToIndex(this.index + 1);
    }
  }

  // 下标索引处理
  currentIndexChangeAction(index: number, isClassify: boolean): void {
    if (this.currentIndex !== index) {
      this.currentIndex = index;
      if (isClassify) {
        this.scroller.scrollToIndex(index);
      } else {
        this.titleItemScroller.scrollToIndex(index);
      }
    }
  }

  // 列表头部
  @Builder
  titleHeader(title: string, count: number) {
    Row() {
      Text() {
        Span(`${title}`)
          .fontSize($r('sys.float.Body_M'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
        Span(`（${count}）`)
          .fontSize($r('sys.float.Caption_M'))
          .fontColor($r('sys.color.font_secondary'))
          .padding({ left: 4 })
      }
    }
    .margin({ bottom: 8, top: 8 })
  }

  build() {
    Column() {
      // 列表页
      Row({ space: 8 }) {
        List({ scroller: this.titleItemScroller }) {
          ForEach(this.dishesList, (item: DishesTypeResp, index: number) => {
            ListItem() {
              TitleItem({
                typeName: item.typeName,
                hasIcon: item.id === Constants.GOOD_TYPE_HOT,
                isSelected: this.currentIndex === index,
                onClickAction: () => {
                  if (index !== undefined) {
                    this.currentIndexChangeAction(index + 1, true);
                  }
                },
              })
            }
          }, (item: DishesTypeResp) => item.typeName + this.currentIndex)
          ListItem() {
            Column().width(Constants.FULL_SIZE).height(78)
          }
        }
        .width(new BreakpointType({
          [BreakpointNameEnum.SM]: 92,
          [BreakpointNameEnum.MD]: 188,
          [BreakpointNameEnum.LG]: 188,
          [BreakpointNameEnum.XL]: 188,
        }).getValue(this.breakpoint))
        .height(Constants.FULL_SIZE)
        .listDirection(Axis.Vertical) // 排列方向
        .backgroundColor(Color.White)
        .scrollBar(BarState.Off)
        .divider({ strokeWidth: 1 })
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })

        List({ scroller: this.scroller }) {
          ListItem() {
            Search({ value: $$this.searchText, placeholder: $r('app.string.search_goods') })
              .textFont({ size: $r('sys.float.Body_L') })
              .width(Constants.FULL_SIZE)
              .placeholderFont({ size: $r('sys.float.Body_L') })
              .maxLength(20)
              .margin(0)
              .onChange((value: string) => {
                if (value) {
                  this.dishesList = this.dishesList.map((item) => {
                    item.goods = item.goods.filter(i => i.name?.includes(value))
                    return item
                  })
                } else {
                  this.dishesList = JSON.parse(JSON.stringify(this.dishesListOri))
                }
              })
          }

          ForEach(this.dishesList, (item: DishesTypeResp) => {
            ListItemGroup({
              header: this.titleHeader(item.typeName, item.goods.length),
              space: 10,
            }) {
              ForEach(item.goods, (listItem: Goods) => {
                ListItem() {
                  GoodInfoComp({ item: listItem })
                }
              }, (listItem: Goods) => JSON.stringify(listItem))

            }
          }, (item: DishesTypeResp) => JSON.stringify(item))
          ListItem() {
            Column() {
              Divider().margin({ top: 12 })
              Text($r('app.string.list_bottom'))
                .fontSize(8)
                .fontWeight(300)
                .fontColor($r('sys.color.font_primary'))
                .margin({ top: 8 })
            }.width(Constants.FULL_SIZE).height(106)
          }
        }
        .layoutWeight(1)
        .height(Constants.FULL_SIZE)
        .scrollBar(BarState.Off)
        .sticky(StickyStyle.None)
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        .onScrollIndex((start: number) => this.currentIndexChangeAction(start - 1, false))
      }.layoutWeight(1).margin({ right: 16 })
    }.width(Constants.FULL_SIZE).height(Constants.FULL_SIZE).constraintSize({ maxHeight: Constants.FULL_SIZE })
  }
}

// 标题
@ComponentV2
export struct TitleItem {
  @Param @Require typeName: string;
  @Param hasIcon: boolean = false
  @Param isSelected: boolean = false;
  @Event onClickAction: () => void = () => {
  }

  build() {
    Row() {
      if (this.hasIcon) {
        Image($r('app.media.ic_hot')).width(16)
      }
      Text(this.typeName)
        .fontSize($r('sys.float.Body_S'))
        .fontColor(this.isSelected ? $r('sys.color.multi_color_09') : $r('sys.color.font_secondary'))
        .textAlign(TextAlign.Center)
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.isSelected ? '#0FED6F21' : '#0D979797')
    .width(Constants.FULL_SIZE)
    .height(48)
    .padding({ left: 10, right: 10 })
    .border({ width: { right: this.isSelected ? 0.5 : 0 }, color: $r('sys.color.multi_color_09') })
    .onClick(this.onClickAction)
  }
}

