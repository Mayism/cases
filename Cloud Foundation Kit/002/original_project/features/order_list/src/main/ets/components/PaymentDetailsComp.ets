import { Constants, copyString, OrderTypeEnum } from 'common/Index';
import { MyOrderInfo } from '../models/Index';

@ComponentV2
export struct PaymentDetailsComp {
  @Param @Require orderDetail: MyOrderInfo;

  build() {
    Column() {
      Row() {
        Text($r('app.string.order_time')).fontSize($r('sys.float.Body_M')).fontColor($r('sys.color.font_secondary'))
        Text(this.orderDetail.order.time).fontSize($r('sys.float.Body_S')).fontColor($r('sys.color.font_primary'))
      }
      .width(Constants.FULL_SIZE)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ top: 12, bottom: 12 })

      // 订单号
      Row() {
        Text($r('app.string.order_id')).fontSize($r('sys.float.Body_M')).fontColor($r('sys.color.font_secondary'))
        Row() {
          Text(this.orderDetail.order.orderNum)
            .fontSize($r('sys.float.Body_S'))
            .fontColor($r('sys.color.font_primary'))
          Image($r('app.media.copy')).width(16).margin({ left: 4 })
            .onClick(() => {
              copyString(this.orderDetail.order.orderNum || '')
            })
        }.justifyContent(FlexAlign.End).layoutWeight(1)
      }
      .width(Constants.FULL_SIZE)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ top: 12, bottom: 12 })

      // 预约号码
      Row() {
        Text('预约号码').fontSize($r('sys.float.Body_M')).fontColor($r('sys.color.font_secondary'))
        Row() {
          Text(this.orderDetail.order.preorderPhone)
            .fontSize($r('sys.float.Body_S'))
            .fontColor($r('sys.color.font_primary'))
        }.justifyContent(FlexAlign.End).layoutWeight(1)
      }
      .width(Constants.FULL_SIZE)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ top: 12, bottom: 12 })

      // 就餐方式
      Row() {
        Text($r('app.string.order_type')).fontSize($r('sys.float.Body_M')).fontColor($r('sys.color.font_secondary'))
        Row() {
          Text(Number(this.orderDetail.order.orderType) === OrderTypeEnum.DINE_IN ?
            $r('app.string.store_dining') :
            $r('app.string.picking')).fontSize($r('sys.float.Body_S')).fontColor($r('sys.color.font_primary'))
        }.justifyContent(FlexAlign.End).layoutWeight(1)
      }
      .width(Constants.FULL_SIZE)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ top: 12, bottom: 12 })

      if (this.orderDetail.order.orderType === OrderTypeEnum.TAKEOUT) {
        // 预约时间
        Row() {
          Text('预约时间').fontSize($r('sys.float.Body_M')).fontColor($r('sys.color.font_secondary'))
          Row() {
            Text(this.orderDetail.order.preorderTime)
              .fontSize($r('sys.float.Body_S'))
              .fontColor($r('sys.color.font_primary'))
          }.justifyContent(FlexAlign.End).layoutWeight(1)
        }
        .width(Constants.FULL_SIZE)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ top: 12, bottom: 12 })

      }
      if (this.orderDetail.order.orderType === OrderTypeEnum.DINE_IN) {
        Row() {
          Text($r('app.string.dinner_num_label'))
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_secondary'))
          Text(this.orderDetail.order.tableware.toString())
            .fontSize($r('sys.float.Body_S'))
            .fontColor($r('sys.color.font_primary'))
        }
        .width(Constants.FULL_SIZE)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ top: 12, bottom: 12 })

        Row() {
          Text('我的桌号')
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_secondary'))
          Text(`${this.orderDetail.table?.typeName}${this.orderDetail.table?.name}`)
            .fontSize($r('sys.float.Body_S'))
            .fontColor($r('sys.color.font_primary'))
        }
        .width(Constants.FULL_SIZE)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ top: 12, bottom: 12 })
      }

      Row() {
        Text($r('app.string.remark')).fontSize($r('sys.float.Body_M')).fontColor($r('sys.color.font_secondary'))
        Text(this.orderDetail.order.note || $r('app.string.none'))
          .fontSize($r('sys.float.Body_S'))
          .fontColor($r('sys.color.font_primary'))
          .width(200)
          .maxLines(1)
          .textAlign(TextAlign.End)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width(Constants.FULL_SIZE)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ top: 12, bottom: 12 })
    }.width(Constants.FULL_SIZE)
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
    .padding({
      left: 12,
      right: 12,
      top: 4,
      bottom: 4,
    })
  }
}