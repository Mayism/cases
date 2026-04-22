import {
  CalenderUtil,
  CommonListItem,
  CommonPage,
  CommonShow,
  Constants,
  getAnonymousTel,
  RouterMap,
  RouterModule,
} from 'common';
import { OrderUtil } from 'network';
import { BookVM } from '../../viewmodels/BookVM';

@ComponentV2
export struct BookResPage {
  vm: BookVM = BookVM.instance;

  aboutToAppear(): void {
    CalenderUtil.init(this.getUIContext().getHostContext()!);
    const orderId: number = RouterModule.getNavParam(RouterMap.BOOK_RES_PAGE) as number;
    this.vm.order = OrderUtil.getBookOrderById(orderId);
    if (!this.vm.orderSchedules.includes(orderId) && OrderUtil.checkHasSchedule(orderId)) {
      this.vm.orderSchedules.push(orderId)
    }
  }

  build() {
    CommonPage({
      title: '预订成功',
      mainUi: () => {
        this.bookResMainUiBuilder();
      },
    })
  }

  @Builder
  bookResMainUiBuilder() {
    /** 订座信息 **/
    if (this.vm.order) {
      Column({ space: 12 }) {
        CommonShow({ title: '订座成功！' })

        Column() {
          Row() {
            Image(`${this.vm.appInfoModel.imgBaseUrl}${this.vm.order!.store.logo}`).width(32)
            Column({ space: 8 }) {
              Text(this.vm.order!.store.name).fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Medium)
              Text(this.vm.order!.store.address).fontSize(10).fontColor($r('sys.color.font_secondary'))
            }
            .layoutWeight(1)
            .margin({ left: $r('app.string.margin_8') })
            .alignItems(HorizontalAlign.Start)
          }.height(56)

          Divider()
          CommonListItem({
            desc: '就餐时间',
            value: this.vm.order!.time,
          })
          CommonListItem({
            desc: '就餐人数',
            value: this.vm.order!.count + '人',
          })
          CommonListItem({
            desc: '是否预订包间',
            value: this.vm.order!.room ? '是' : '否',
          })
          Divider()
          CommonListItem({
            desc: '订座人',
            value: this.vm.order!.name,
          })
          CommonListItem({
            desc: '联系方式',
            value: getAnonymousTel(this.vm.order!.phone),
          })
          Divider()

          CommonListItem({
            desc: '特殊需求',
            value: `${this.vm.order!.decoration}${this.vm.order!.decoration && this.vm.order!.tableWares.length ? '/' :
              ''}${this.vm.order!.tableWares.join('/')}`,
          })
          CommonListItem({
            desc: '备注',
            value: this.vm.order!.tips,
          })
          Divider()
          Row({ space: 12 }) {
            Button('添加日程', { controlSize: ControlSize.SMALL })
              .fontColor($r('sys.color.font_on_primary'))
              .backgroundColor($r('sys.color.multi_color_09'))
              .enabled(!this.vm.orderSchedules.includes(this.vm.order.orderId))
              .onClick(async () => {
                let result = await CalenderUtil.addCalenderEvent(this.vm.order!);
                if (result && !this.vm.orderSchedules.includes(this.vm.order!.orderId)) {
                  this.vm.orderSchedules.push(this.vm.order!.orderId)
                }
              })
            Button('取消预订', { controlSize: ControlSize.SMALL })
              .fontColor($r('sys.color.font_on_primary'))
              .backgroundColor($r('sys.color.multi_color_09'))
              .onClick(async () => {
                await this.vm.cancelBookOrder(this.vm.order!.orderId);
              })
          }
          .width(Constants.FULL_SIZE)
          .height(56)
          .justifyContent(FlexAlign.End)
        }
        .padding({ top: 4, left: 12, right: 12 })
        .borderRadius(20)
        .backgroundColor($r('sys.color.background_primary'))
      }
    }

    Blank().layoutWeight(1)
  }
}

@Builder
export function bookResPageBuilder() {
  BookResPage()
}