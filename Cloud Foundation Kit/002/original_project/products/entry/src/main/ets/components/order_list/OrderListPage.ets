import { UtilLog } from '@hw-agconnect/util-log';
import { emitter } from '@kit.BasicServicesKit';
import { Constants, EmitterEvent, NavHeaderBar, OrderStateEnum } from 'common/Index';
import { MyOrderResp } from 'network';
import * as API from '../../api/Index';
import { orderInfoMapper } from '../../mapper/Index';
import { MyOrderInfo } from '../../models/Index';
import { OrderCard } from './OrderCard';

@ComponentV2
export struct OrderListPage {
  @Local title: Resource = $r('app.string.order_list')
  @Local currentState: OrderStateEnum = OrderStateEnum.All;
  @Local orderList: Array<MyOrderInfo> = [];
  scroller: Scroller = new Scroller()
  @Local pageNum: number = 0

  aboutToAppear(): void {
    this.getMyOrder()
    try {
      emitter.on(EmitterEvent.REFRESH_ORDER_LIST, () => {
        this.getMyOrder()
      })
    } catch (e) {
      UtilLog.error('emitter failed.', e)
    }
  }

  build() {
    NavDestination() {
      Column() {
        NavHeaderBar({ hasBackButton: false, title: this.title })
        Column() {
          Tabs({ index: this.currentState }) {
            TabContent() {
              this.tabOrderList()
            }.tabBar(this.tabBuilder(OrderStateEnum.All, $r('app.string.all')))

            TabContent() {
              this.tabOrderList()
            }.tabBar(this.tabBuilder(OrderStateEnum.noFinished, $r('app.string.not_complete')))

            TabContent() {
              this.tabOrderList()
            }.tabBar(this.tabBuilder(OrderStateEnum.finished, $r('app.string.completed')))

            TabContent() {
              this.tabOrderList()
            }.tabBar(this.tabBuilder(OrderStateEnum.AfterSales, $r('app.string.other')))
          }
          .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
            this.currentState = targetIndex
          })
          .width(Constants.FULL_SIZE)
          .barHeight(50)
          .layoutWeight(1)
          .onChange((index) => {
            this.currentState = index;
            this.getMyOrder()
          })
        }.justifyContent(FlexAlign.Start).layoutWeight(1)
      }
      .height(Constants.FULL_SIZE)
      .width(Constants.FULL_SIZE)
      .backgroundColor($r('sys.color.background_secondary'))
    }.hideTitleBar(true)
  }

  @Builder
  tabBuilder(index: number, name: Resource) {
    Column() {
      Text(name)
        .fontColor(this.currentState === index ? $r('sys.color.multi_color_09') : $r('sys.color.font_secondary'))
        .fontSize($r('sys.float.Body_L'))
        .fontWeight(FontWeight.Medium)
      if (this.currentState === index) {
        Row()
          .width(42)
          .height(0)
          .borderWidth({ bottom: 2 })
          .borderColor($r('sys.color.multi_color_09'))
          .margin({ top: 4 })
      }
    }
    .width(Constants.FULL_SIZE)
    .height(50)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .padding({ top: 12, bottom: 12 })
    .backgroundColor($r('sys.color.comp_background_primary'))
  }

  @Builder
  tabOrderList() {
    List({ space: 12 }) {
      ForEach(this.orderList, (item: MyOrderInfo) => {
        OrderCard({
          orderItem: item, getMyOrder: () => {
            this.getMyOrder()
          },
        })
      }, (item: MyOrderInfo) => JSON.stringify(item))
    }
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .height(Constants.FULL_SIZE)
    .contentStartOffset(12)
    .contentEndOffset(12)
    .constraintSize({ maxHeight: Constants.FULL_SIZE })
  }

  getMyOrder() {
    let tabIndex = [this.currentState]
    if (this.currentState === OrderStateEnum.All) {
      tabIndex = [OrderStateEnum.noFinished, OrderStateEnum.finished, OrderStateEnum.AfterSales]
    }
    API.getMyOrder(this.pageNum, tabIndex).then((resp: Array<MyOrderResp>) => {
      this.orderList = resp.map(item => orderInfoMapper(item))
    })
  }
}