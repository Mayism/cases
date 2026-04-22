import { CategoryItem, ItemInfo, StoreItem, SubCategoryItem } from '../types/Index';
import { Constants, LayoutType } from '../common/Constant';
import { GridRowColSetting } from '../common/GridRowColSetting';
import { BasicDataSource } from '../common/BasicDataSource';

@ComponentV2
export struct CategoryList {
  // 分类列表
  @Param categoryTabs: CategoryItem[] = [];
  // 子列表
  @Param productList: StoreItem[] = []
  // 一级选中索引初始值
  @Param initIndex: number = 0;
  // 控制布局方式
  @Param layoutType: LayoutType = LayoutType.GRID;
  @Param themeColor: ResourceColor = '#0A59F7';
  @Param tabBarScroller: Scroller = new Scroller();
  @Param subBarScroller: Scroller = new Scroller();
  @Param scroller: Scroller = new Scroller();
  @BuilderParam itemBuilderParam: (item: StoreItem) => void = this.itemBuilder;
  @Local dataSource: BasicDataSource = new BasicDataSource()
  @Local curIndex: number = this.initIndex;
  @Local curSubIndex: number = 0;
  @Local curItemIndex: number = 0;
  @Local curAllList: ItemInfo[][] = [];
  @Local curSectionList: ItemInfo[] = [];
  @Local breakpoint: string = 'sm';
  @Local scrollStatus: boolean = false;
  @Event onTabClick: (tab: CategoryItem) => void = () => {
  }
  @Event onItemClick: (itemDetail: StoreItem) => void = () => {
  }

  build() {
    Row() {
      GridRow(GridRowColSetting.DEFAULT_GRID_ROW_OPTIONS) {
        GridCol({ span: GridRowColSetting.TITLE_COL_SPAN }) {
          Row() {
            List({ scroller: this.tabBarScroller }) {
              ForEach(this.categoryTabs, (item: CategoryItem, index: number) => {
                ListItem() {
                  this.tabBarItemBuilder(item, index)
                }
              }, (item: CategoryItem) => JSON.stringify(item.id))
            }
            .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
            .layoutWeight(1)
            .height(Constants.FULL_PERCENT)
            .listDirection(Axis.Vertical)
            .scrollBar(BarState.Off)
            .backgroundColor('rgba(0, 0, 0, 0.1)')
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ top: Constants.PADDING_S })
        }

        GridCol({ span: GridRowColSetting.SUBTITLE_COL_SPAN }) {
          Column() {
            this.productListBuilder()
          }
          .layoutWeight(1)
        }
      }
      .onBreakpointChange((bp: string) => {
        this.breakpoint = bp;
      })
    }
    .width(Constants.FULL_PERCENT)
    .height(Constants.FULL_PERCENT)
  }

  // 一级分类列表
  @Builder
  tabBarItemBuilder(item: CategoryItem, index: number) {
    Row() {
      Text(item.label)
        .fontSize($r('sys.float.Body_M'))
        .fontWeight(this.curIndex === index ? FontWeight.Bold : FontWeight.Regular)
        .fontColor($r('sys.color.font_primary'))
        .textAlign(TextAlign.Center)
        .maxLines(Constants.FONT_LINES)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width(Constants.FULL_PERCENT)
    }
    .backgroundColor(this.curIndex === index ? '#F1F3F5' : Color.Transparent)
    .justifyContent(FlexAlign.Start)
    .width(Constants.FULL_PERCENT)
    .height(Constants.TITLE_HEIGHT)
    .onClick(() => {
      this.curIndex = index;
      this.curSubIndex = 0;
      this.curItemIndex = 0;
      this.subBarScroller.scrollToIndex(this.curSubIndex)
      this.scroller.scrollToIndex(this.curItemIndex)
      this.onTabClick(item);
    })
  }

  @Builder
  productListBuilder() {
    List({ space: Constants.SPACE_L, scroller: this.scroller }) {
      ForEach(this.productList, (gridItem: StoreItem) => {
        ListItem() {
          Column() {
            this.itemBuilderParam(gridItem)
          }
        }
        .onClick(() => {
          this.onItemClick(gridItem)
        })
      }, (gridItem: StoreItem) => JSON.stringify(gridItem))
    }
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
    .listDirection(Axis.Vertical)
    .layoutWeight(1)
    .height(Constants.FULL_PERCENT)
    .scrollBar(BarState.Off)
    .sticky(StickyStyle.None)
    .onScrollIndex((start: number) => {
      if (!this.scrollStatus) {
        this.curSubIndex = start
        this.subBarScroller.scrollToIndex(start, true)
      }
    })
    .margin({
      top: Constants.PADDING_L,
      right: GridRowColSetting.getPageMargin(this.breakpoint),
    })
  }

  @Builder
  itemBuilder(item: StoreItem) {
    Row() {
      Row() {
        Image($r('app.media.store'))
          .width(24)
          .margin({ right: 8 })
        Text(item.name)
          .fontSize($r('sys.float.Body_M'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
          .textAlign(TextAlign.Start)
          .margin({ left: 8 })
      }

      Text(item.distance)
        .width(36)
        .fontSize($r('sys.float.Body_M'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)

    Text(item.address)
      .width('100%')
      .fontSize($r('sys.float.Body_M'))
      .fontWeight(FontWeight.Medium)
      .fontColor($r('sys.color.font_secondary'))
      .textAlign(TextAlign.Start)
      .margin({ top: 8 })
  }
}