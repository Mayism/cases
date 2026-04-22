import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { CommonListItem, CommonPage, CommonShow, Constants, RouterMap, RouterModule } from 'common';
import { OrderUtil } from 'network';
import { QueueVM } from '../../viewmodels/QueueVM';

@ComponentV2
export struct QueueResPage {
  vm: QueueVM = QueueVM.instance;

  aboutToAppear(): void {
    const orderId: number = RouterModule.getNavParam(RouterMap.QUEUE_RES_PAGE) as number;
    this.vm.order = OrderUtil.getQueueOrderById(orderId);
    if (this.vm.order?.wait && this.vm.order.wait < 0) {
      promptAction.showToast({ message: '排号已过期' });
      RouterModule.pop();
    }
  }

  build() {
    CommonPage({
      title: '取号排队',
      mainUi: () => {
        this.queueResMainUiBuilder();
      },
      bottomUi: () => {
        this.queueResBottomUiBuilder();
      },
    })
  }

  @Builder
  queueResMainUiBuilder() {
    /** 排号信息 **/
    if (this.vm.order) {
      Column({ space: 24 }) {
        CommonShow({ title: '排队成功！' })
        Column() {
          Text(`当前叫号：${this.vm.type +
          this.vm.order!.now}号 \n我的号码：${this.vm.type}${this.vm.order!.mine}号`)
            .fontColor($r('sys.color.font_primary'))
            .fontWeight(FontWeight.Bold)
            .fontSize($r('sys.float.Title_S'))
            .lineHeight(30)
        }
        .width(Constants.FULL_SIZE)
        .padding({ top: 12, bottom: 12 })

        Column() {
          Row() {
            Image(`${this.vm.appInfoModel.imgBaseUrl}${this.vm.order!.store.logo}`).width(32)
            Column({ space: 8 }) {
              Text(this.vm.order!.store.name).fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Medium)
              Text(this.vm.order!.store.address).fontSize(10).fontColor($r('sys.color.font_secondary'))
            }.layoutWeight(1).margin({ left: $r('app.string.margin_8') }).alignItems(HorizontalAlign.Start)
          }.padding({ left: 12, right: 12 }).height(56)

          Divider()
          CommonListItem({ desc: '就餐时间', value: this.vm.order!.time }).padding({ left: 12, right: 12 }).height(54)
          CommonListItem({ desc: '就餐人数', value: this.vm.order!.count + '人' })
            .padding({ left: 12, right: 12 })
            .height(54)
          Divider()
          this.queueInfoBuilder();
        }.borderRadius(20).padding({ top: 4, right: 4 }).backgroundColor($r('sys.color.background_primary'))

        Blank().layoutWeight(1)
      }
    }
  }

  @Builder
  queueInfoBuilder() {
    Column() {
      Row() {
        Text('等待桌数')
          .layoutWeight(1)
          .fontSize($r('sys.float.Subtitle_M'))
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Medium)
        Text(this.vm.order!.wait + '桌').fontSize($r('sys.float.Body_M')).fontColor($r('sys.color.font_secondary'))
      }.height(54)
    }.padding({ left: 12, right: 12 })
  }

  @Builder
  queueResBottomUiBuilder() {
    Row({ space: 16 }) {
      Button('取消排号')
        .fontColor($r('sys.color.font_primary'))
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .layoutWeight(1)
        .onClick(() => {
          this.vm.cancelQueueOrder(this.vm.order!.orderId);
        })
      Button('刷新页面')
        .fontColor($r('sys.color.font_on_primary'))
        .backgroundColor($r('sys.color.multi_color_09'))
        .layoutWeight(1)
        .onClick(async () => {
          this.vm.refreshQueueOrder();
        })
    }
    .width(Constants.FULL_SIZE).height(56)
    .justifyContent(FlexAlign.Center)
    .padding({ left: 12, right: 12 })
  }
}

@Builder
export function queueResPageBuilder() {
  QueueResPage()
}