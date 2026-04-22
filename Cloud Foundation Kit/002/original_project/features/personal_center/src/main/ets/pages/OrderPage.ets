import { CalenderUtil, CommonListItem, CommonPage, Constants, CONTAINER_STYLE, RouterMap, RouterModule } from 'common';
import { BookOrderDetail, QueueOrderDetail } from 'network';
import { OrderVM } from '../viewmodels/OrderVM';

@ComponentV2
export struct OrderPage {
  vm: OrderVM = OrderVM.instance;
  loadingColor = $r('app.color.brand_red');

  aboutToAppear(): void {
    const params: Record<string, number> =
      RouterModule.getNavParam(RouterMap.ORDER_LIST_PAGE) as Record<string, number>;
    this.vm.index = params?.index || 0;
    CalenderUtil.init(this.getUIContext().getHostContext()!);
  }

  build() {
    CommonPage({
      title: '我的预约/排号',
      topUi: () => {
        this.navBarBuilder()
      },
      mainUi: () => {
        this.orderMainUiBuilder();
      },
      onShow: () => {
        this.vm.getAllOrders();
      },
    })
  }

  @Builder
  orderMainUiBuilder() {
    /** 订单区 **/
    if (!this.vm.init) {
      this.listBuilder()
    } else {
      LoadingProgress().size({ width: 72, height: 72 }).color($r('sys.color.icon_on_primary')).margin({ top: 160 })
    }
    Blank().layoutWeight(1)
  }

  @Builder
  navBarBuilder() {
    /** 导航区 **/
    Row({ space: 12 }) {
      this.navBarItemBuilder(0, '订座')
      this.navBarItemBuilder(1, '排号')
    }.justifyContent(FlexAlign.Start).width('calc(100% - 32vp)').margin({ bottom: 12 })
  }

  @Builder
  listBuilder() {
    if (this.vm.index) {
      if (this.vm.queueList.length) {
        this.queueListBuilder()
      } else {
        this.nullBuilder(1)
      }
    } else {
      if (this.vm.bookList.length) {
        this.bookListBuilder()
      } else {
        this.nullBuilder(0)
      }
    }
  }

  @Builder
  nullBuilder(index: number) {
    Column() {
      Image(index ? $r('app.media.bg_queue_empty') : $r('app.media.bg_book_empty'))
        .width(179)
        .height(126)
        .margin({ top: 64 })
      Text(`暂无${index ? '排号' : '订座'}记录`)
        .fontSize(14)
        .margin({ top: 25, bottom: 12 })
        .fontColor($r('sys.color.font_tertiary'))
      Button(index ? '去排号' : '去订座')
        .width(145)
        .height(40)
        .backgroundColor($r('app.color.brand_red'))
        .fontColor($r('sys.color.font_on_primary'))
        .onClick(() => {
          RouterModule.push(index ? RouterMap.QUEUE_PAGE : RouterMap.BOOK_PAGE);
        })
    }
  }

  @Builder
  endBuilder() {
    Row() {
      Row({ space: 8 }) {
        Text().layoutWeight(1).height(1).backgroundColor($r('sys.color.comp_divider'))
        Text('暂无其他')
          .fontColor($r('sys.color.font_tertiary'))
          .fontSize(14)
          .textAlign(TextAlign.Center)
        Text().layoutWeight(1).height(1).backgroundColor($r('sys.color.comp_divider'))
      }.width('calc(100% - 24vp)')
    }.width(Constants.FULL_SIZE).justifyContent(FlexAlign.Center)
  }

  @Builder
  navBarItemBuilder(index: number, text: string) {
    Text(text)
      .fontColor(index === this.vm.index ? $r('app.color.system_color_background_white') : $r('sys.color.font_primary'))
      .backgroundColor(index === this.vm.index ? $r('app.color.brand_red') : '#E6E8E9')
      .width(73)
      .height(36)
      .fontWeight(FontWeight.Medium)
      .textAlign(TextAlign.Center)
      .borderRadius($r('app.string.border_radius_16'))
      .onClick(() => {
        this.vm.index = index;
      })
  }

  @Builder
  bookListBuilder() {
    List({ space: 12 }) {
      ForEach(this.vm.bookList, (order: BookOrderDetail) => {
        ListItem() {
          Column({ space: 10 }) {
            Column() {
              Row() {
                Image(`${this.vm.appInfoModel.imgBaseUrl}${order.store.logo}`).width(32).borderRadius(8)
                Column({ space: 4 }) {
                  Text(order.store.name)
                    .fontColor($r('sys.color.font_primary'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize($r('sys.float.Body_L'))
                  Text(order.store.address)
                    .fontSize($r('sys.float.Caption_M'))
                    .fontColor($r('sys.color.font_secondary'))
                }
                .layoutWeight(1)
                .margin({ left: 16 })
                .alignItems(HorizontalAlign.Start)
              }.height(56).padding({ top: 4, left: 12, right: 12 })

              Divider()

              CommonListItem({ desc: '预约时间', value: order.time })
              CommonListItem({ desc: '就餐人数', value: order.count + '人' })
              CommonListItem({ desc: '预约包间', value: order.room ? '是' : '否' })
              Divider().margin({ top: 12, bottom: 12 })
              CommonListItem({ desc: '订座人', value: order.name })
              CommonListItem({ desc: '联系电话', value: order.phone })
              CommonListItem({
                desc: '特殊需求',
                value: `${order.decoration}${order.decoration && order.tableWares.length ? '/' :
                  ''}${order.tableWares.join('/')}`,
              })
              CommonListItem({ desc: '备注', value: order.tips })
            }
            .onClick(() => {
              RouterModule.push(RouterMap.BOOK_RES_PAGE, order.orderId);
            })

            Divider().margin({ top: 12, bottom: 12 })

            Row({ space: 12 }) {
              Button('添加日程', { controlSize: ControlSize.SMALL })
                .fontColor($r('sys.color.font_on_primary'))
                .backgroundColor($r('sys.color.multi_color_09'))
                .enabled(!this.vm.schedule.includes(order.orderId))
                .onClick(() => {
                  CalenderUtil.addCalenderEvent(order);
                  if (!this.vm.schedule.includes(order.orderId)) {
                    this.vm.schedule.push(order.orderId)
                  }
                })
              Button('取消预订', { controlSize: ControlSize.SMALL })
                .fontColor($r('sys.color.font_on_primary'))
                .backgroundColor($r('sys.color.multi_color_09'))
                .onClick(async () => {
                  this.vm.cancelBookOrder(order.orderId);
                })
            }
            .width(Constants.FULL_SIZE)
            .height(56)
            .justifyContent(FlexAlign.End)
          }.alignItems(HorizontalAlign.End)
        }.attributeModifier(CONTAINER_STYLE)
      }, (order: BookOrderDetail, index) => JSON.stringify(order) + '_' + index)

      ListItem() {
        this.endBuilder()
      }
    }
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
    .nestedScroll({ scrollForward: NestedScrollMode.PARENT_FIRST, scrollBackward: NestedScrollMode.PARENT_FIRST })
  }

  @Builder
  queueListBuilder() {
    List({ space: 12 }) {
      ForEach(this.vm.queueList, (order: QueueOrderDetail) => {
        ListItem() {
          Column({ space: 24 }) {
            Column({ space: 4 }) {
              Text(`当前叫号：${order.now}\n我的号码：${order.mine}`)
                .fontSize($r('sys.float.Title_S'))
                .fontWeight(FontWeight.Bold)
                .fontColor($r('sys.color.font_primary'))
                .lineHeight(30)
                .margin({ top: 20})
              Column() {
                Row() {
                  Image(`${this.vm.appInfoModel.imgBaseUrl}${order.store.logo}`).width(32).borderRadius(8)
                  Column({ space: 4 }) {
                    Text(order.store.name)
                      .fontColor($r('sys.color.font_primary'))
                      .fontWeight(FontWeight.Medium)
                      .fontSize($r('sys.float.Body_L'))
                    Text(order.store.address)
                      .fontSize($r('sys.float.Caption_M'))
                      .fontColor($r('sys.color.font_secondary'))
                  }
                  .layoutWeight(1)
                  .margin({ left: 16 })
                  .alignItems(HorizontalAlign.Start)
                }.height(56).padding({ left: 12, right: 12 })

                Divider()
                Column() {
                  CommonListItem({ pic: $r('app.media.ic_book_order_people'), desc: '就餐时间', value: order.time })
                    .height(56)
                  CommonListItem({
                    pic: $r('app.media.ic_book_order_people'),
                    desc: '就餐人数',
                    value: order.count + '人',
                  }).height(56).margin({ top: 2 })
                  Divider().margin({ top: 12, bottom: 12 })
                  CommonListItem({
                    pic: $r('app.media.ic_queue_order_tips'),
                    desc: '等待桌数',
                    value: order.wait.toString(),
                  }).height(56).margin({ top: 2 })
                }.padding({ left: 12, right: 12 })
              }.padding({ top: 4, bottom: 4 })
            }
            .onClick(() => {
              RouterModule.push(RouterMap.QUEUE_RES_PAGE, order.orderId);
            })
            Row({ space: 16 }) {
              Button('取消')
                .fontColor($r('sys.color.font_primary'))
                .backgroundColor($r('sys.color.comp_background_tertiary'))
                .layoutWeight(1)
                .onClick(() => {
                  this.vm.cancelQueueOrder(order.orderId);
                })
              Button('刷新')
                .fontColor($r('sys.color.font_on_primary'))
                .backgroundColor($r('sys.color.multi_color_09'))
                .layoutWeight(1)
                .onClick(async () => {
                  this.vm.refreshQueueOrder(order.orderId);
                })
            }
            .width(Constants.FULL_SIZE)
            .justifyContent(FlexAlign.Center)
            .padding({ left: 12, right: 12, bottom: 16 })
          }.alignItems(HorizontalAlign.End)
        }.width(Constants.FULL_SIZE)
        .borderRadius($r('app.string.border_radius_16'))
        .backgroundColor($r('app.color.system_color_background_white'))
      }, (order: QueueOrderDetail, index) => JSON.stringify(order) + '_' + index)
    }
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
    .nestedScroll({ scrollForward: NestedScrollMode.PARENT_FIRST, scrollBackward: NestedScrollMode.PARENT_FIRST })

  }
}

@Extend(Text)
function btnStyle() {
  .height(40)
  .width(144)
  .borderRadius(20)
  .textAlign(TextAlign.Center)
  .fontWeight(FontWeight.Medium)
  .fontColor($r('app.color.brand_red'))
  .border({ color: $r('app.color.brand_red'), width: 1 })
}

@Builder
export function orderPageBuilder() {
  OrderPage()
}