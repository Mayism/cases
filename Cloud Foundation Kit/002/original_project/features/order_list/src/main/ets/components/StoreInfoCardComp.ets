import { callTelSheetBuilder } from 'base_ui';
import { CommonUrl, Constants } from 'common/Index';
import { MyOrderInfo } from '../models/Index';

/*
 * 购买商品列表
 * */
@ComponentV2
export struct StoreInfoCard {
  @Param @Require orderDetail: MyOrderInfo
  @Local callTelSheet: boolean = false

  build() {
    Column({ space: 4 }) {
      Row() {
        Row() {
          Image(`${CommonUrl.CLOUD_STORAGE_URL}${this.orderDetail.order.storeLogo}`)
            .width(40)
            .height(40)
            .borderRadius(20)
          Text(`${this.orderDetail.order.storeName}`)
            .fontSize($r('sys.float.Subtitle_L'))
            .fontColor($r('sys.color.font_primary'))
            .fontWeight(FontWeight.Medium)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .constraintSize({ maxWidth: '90%' })
            .margin({ left: 4 })
        }.layoutWeight(1)

        Image($r('app.media.phone_icon')).width(24).height(24)
          .onClick(() => {
            // 拨打商家电话
            this.callTelSheet = true
          })
          .bindSheet($$this.callTelSheet, callTelSheetBuilder(this.orderDetail.order.storeTel, () => {
            this.callTelSheet = false
          }), {
            detents: [309, 310],
            backgroundColor: $r('sys.color.background_fourth'),
            blurStyle: BlurStyle.Thick,
            preferType: SheetType.CENTER,
            title: { title: $r('app.string.contact_us') },
          });
      }.justifyContent(FlexAlign.SpaceBetween)

      Row({ space: 2 }) {
        Image($r('app.media.ic_public_position')).width(12)
        Text(`${this.orderDetail.order.storeAddress}`)
          .fontSize($r('sys.float.Body_S'))
          .fontColor($r('sys.color.font_secondary'))
          .fontWeight(400)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)
      }
    }
    .width(Constants.FULL_SIZE)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
    .padding(12)

  }
}