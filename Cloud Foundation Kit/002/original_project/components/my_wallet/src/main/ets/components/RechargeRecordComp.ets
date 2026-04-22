import { RechargeRecord, WalletRecordType } from '../models/Index'
import { getFullDate } from '../utils/Index'

@ComponentV2
export struct RechargeRecordComp {
  @Param rechargeRecordList: RechargeRecord[] = []

  build() {
    Column() {
      List({ space: 12 }) {
        ForEach(this.rechargeRecordList, (item: RechargeRecord) => {
          ListItem() {
            Column({ space: 2 }) {
              if (item.recordType === WalletRecordType.RECHARGE) {
                Row() {
                  Text('充值成功').fontSize(14).fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Medium)
                  Text(`+${item.rechargeMoney}`)
                    .fontSize(14)
                    .fontColor($r('sys.color.font_primary'))
                    .fontWeight(FontWeight.Medium)
                }.width('100%').justifyContent(FlexAlign.SpaceBetween)
              }
              if (item.recordType === WalletRecordType.CONSUME) {
                Row() {
                  Text('消费').fontSize(14).fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Medium)
                  Text(`-${item.rechargeMoney}`)
                    .fontSize(14)
                    .fontColor($r('sys.color.font_primary'))
                    .fontWeight(FontWeight.Medium)
                }.width('100%').justifyContent(FlexAlign.SpaceBetween)
              }

              Row() {
                Text(getFullDate(new Date(item.time))).fontSize(12).fontColor($r('sys.color.font_tertiary'))
                Text(`余额：${item.balance.toFixed(2)}`).fontSize(12).fontColor($r('sys.color.font_tertiary'))
              }.width('100%').justifyContent(FlexAlign.SpaceBetween)
            }.padding({ top: 10, bottom: 10 })

          }
        }, (item: RechargeRecord) => item.id)
      }
      .scrollBar(BarState.Off)
      .borderRadius(16)
      .edgeEffect(EdgeEffect.Spring)
      .divider({ strokeWidth: 1 })
      .padding({
        left: 12,
        right: 12,
      })
      .backgroundColor($r('sys.color.background_primary'))
      .visibility(this.rechargeRecordList.length ? Visibility.Visible : Visibility.None)

      Column({ space: 24 }) {
        Image($r('app.media.ic_record_empty')).width(160)
        Text('钱包空空如也~~~').fontSize(14).fontColor($r('sys.color.font_tertiary'))
      }
      .width('100%')
      .height(358)
      .justifyContent(FlexAlign.Center)
      .borderRadius(16)
      .backgroundColor($r('sys.color.background_primary'))
      .visibility(this.rechargeRecordList.length ? Visibility.None : Visibility.Visible)
    }
    .width('100%')
  }
}