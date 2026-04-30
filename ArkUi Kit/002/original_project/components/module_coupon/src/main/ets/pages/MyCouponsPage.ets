import { CommonConstants } from '../commonlib/Index'
import { CouponItem } from '../network/Index'
import { CouponCard } from '../components/CouponCardComp'
import { TabComp } from '../components/TabComp'
import { MY_TAB_BAR } from '../constants/Index'
import { ScenarioStatus } from '../types'
import { getCouponList, getScenarioStatus } from '../utils'

@ComponentV2
export struct MyCoupons {
  // 立即使用的回调
  @Event clickUseNow: () => void = () => {
  };
  @Local myCouponsAll: CouponItem[] = [];
  @Local refreshing: boolean[] = [];
  private tabBar: string[] = [];
  private currentIndex: number = 0;
  @Provider() pageStack: NavPathStack = new NavPathStack();

  @Computed
  get contentData() {
    const data: Array<CouponItem[]> = [[], [], [], []];
    this.myCouponsAll.forEach(item => {
      const status = getScenarioStatus(item, 0);
      if (status === ScenarioStatus.HAS_USED) {
        data[3].push(item);
      } else if (status === ScenarioStatus.EXPIRE) {
        data[2].push(item);
      } else {
        data[1].push((item));
      }
    })
    data[0] = [...data[1], ...data[2], ...data[3]];
    return data;
  }

  aboutToAppear() {
    this.tabBar = MY_TAB_BAR;
    this.refreshing = Array.from<boolean>({ length: this.tabBar.length }).fill(false);
    getCouponList().then((res) => {
      this.myCouponsAll = res;
    })
  }

  build() {
    Column() {
      TabComp({
        tabBar: this.tabBar,
        index: this.currentIndex,
        contentUi: (index: number) => {
          this.contentBuilder(index);
        },
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  contentBuilder(index: number) {
    if (this.contentData[index].length) {
      this.tabContentBuilder(index)
    } else {
      this.emptyBuilder()
    }
  }

  @Builder
  tabContentBuilder(index: number) {
    Refresh({ refreshing: this.refreshing[index] }) {
      List({ space: 12 }) {
        ForEach(this.contentData[index], (item: CouponItem) => {
          ListItem() {
            CouponCard({
              coupon: item,
              clickUseNow: () => {
                this.clickUseNow();
              }
            })
          }
        }, (item: CouponItem, index) => JSON.stringify(item) + '_' + index)

      }
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.FULL_HEIGHT)
      .scrollBar(BarState.Off)
    }
    .onStateChange(status => {
      if (status === RefreshStatus.Refresh) {
        this.refreshing[index] = true;
      }
    })
    .onRefreshing(() => {
      getCouponList().then((res) => {
        this.myCouponsAll = res;
        this.refreshing[index] = false;
      })
    })
    .align(Alignment.Top)
  }

  @Builder
  emptyBuilder() {
    Column() {
      Column() {
        Image($r('app.media.ic_no_record')).width(160)
        Text('暂无停车券').fontSize(12).fontColor($r('sys.color.font_secondary')).margin({ top: 12 })
      }.width('100%')
    }
    .justifyContent(FlexAlign.Center)
    .layoutWeight(1)
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
  }
}
