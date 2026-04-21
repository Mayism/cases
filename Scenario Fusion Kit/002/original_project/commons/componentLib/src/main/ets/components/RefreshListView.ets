import { NewsData, NewsDataSource, RouterMap, RouterModule } from 'commonlib';
import { NewsCard } from './NewsCard';

export class RefreshListController {
  resetScroll: () => void = () => {};
  changeRefreshState: () => void = () => {};
}

@ComponentV2
export struct RefreshListView {
  @Param newsData: NewsDataSource = new NewsDataSource();
  @Param isLoadingMore: boolean = false;
  @Param changeFontSize: number = 0;
  @Param refreshListController: RefreshListController = new RefreshListController();

  @Local offsetY: number = 0;
  @Local isRefreshing: boolean = false;

  @Builder
  defaultBuilder() {}
  @BuilderParam customSwiperBuilder: () => void = this.defaultBuilder

  @Event loadMore: (start: number, end: number) => void = (start: number, end: number) => {}
  @Event refresh: () => void = () => {}

  private listScroller: ListScroller = new ListScroller();

  aboutToAppear() {
    this.refreshListController.resetScroll = (): void => this.resetScroll()
    this.refreshListController.changeRefreshState = (): void => this.changeRefreshState()
  }

  resetScroll() {
    this.listScroller.scrollToIndex(0, true)
    this.offsetY = 0
  }

  changeRefreshState() {
    this.isRefreshing = false
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing, builder: this.customRefreshComponent }) {
      List({ space: 24, scroller: this.listScroller }) {
        if (this.customSwiperBuilder) {
          ListItem() {
            this.customSwiperBuilder()
          }
          .backgroundColor($r('app.color.bgc'))
          .borderRadius(16)
          .onClick(() => {
            RouterModule.push({ url: RouterMap.NEWS_DETAIL, param: null });
          })
        }

        LazyForEach(this.newsData, (item: NewsData, index: number) => {
          ListItem() {
            NewsCard({
              newsTitle: item.newsTitle,
              newsContent: item.newsContent,
              newsTime: item.newsTime,
              newsImage: item.newsImage,
              changeFontSize: this.changeFontSize,
            })
          }
          .onClick(() => {
            RouterModule.push({ url: RouterMap.NEWS_DETAIL, param: item });
          })
        }, (item: NewsData) => JSON.stringify(item))

        ListItem() {
          this.footer()
        }
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .onScrollIndex((start: number, end: number) => {
        // 当达到列表末尾时，触发新数据加载。
        this.loadMore?.(start, end)
      })
      .scrollBar(BarState.Off)
      // 开启边缘滑动效果。
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .onScrollFrameBegin((offset: number, state: ScrollState) => {
        this.offsetY = offset
        return { offsetRemain: offset }
      })
    }
    .layoutWeight(1)
    .onRefreshing(() => {
      this.refresh?.()
    })
    .pullToRefresh(true)
    .refreshOffset(64)

  }

  @Builder
  customRefreshComponent() {
    Row() {
      LoadingProgress().color($r('sys.color.icon_secondary')).width(32).height(32)
    }
    .height(32)
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  footer() {
    Row() {
      LoadingProgress().height(32).width(32)
      Text('加载中')
    }.width('100%')
    .height(64)
    .justifyContent(FlexAlign.Center)
    // 当不处于加载中状态时隐藏组件。
    .visibility(this.isLoadingMore ? Visibility.Visible : Visibility.Hidden)
  }
}