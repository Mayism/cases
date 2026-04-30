import { Constants, EmptyComp, NavHeaderBar, PayRecord, PAY_STATUE, Utils } from 'lib_common';
import { PayRecordViewModel } from '../viewmodel/PayRecordViewModel';

@Builder
export function PayRecordPageBuilder() {
  PayRecordPage()
}

@ComponentV2
struct PayRecordPage {
  @Local vm: PayRecordViewModel = new PayRecordViewModel()

  build() {
    NavDestination() {
      NavHeaderBar({ title: '缴费记录' })
      Column() {
        if (this.vm.payRecordList.length) {
          List({ space: 12 }) {
            ForEach(this.vm.payRecordList, (item: PayRecord) => {
              ListItem() {
                this.recordCard(item)
              }
            }, (v: PayRecord) => JSON.stringify(v))
          }
          .width('100%')
          .layoutWeight(1)
          .padding({ top: 20 })
          .scrollBar(BarState.Off)
        } else {
          EmptyComp({ image: $r('app.media.ic_no_record'), text: '暂无记录' }).margin({ top: 93 })
        }
      }
      .width(Constants.FULL_SIZE)
      .layoutWeight(1)
      .constraintSize({ maxWidth: Constants.FULL_SIZE })
      .margin({
        left: Constants.BORDER_WIDTH,
        right: Constants.BORDER_WIDTH,
        bottom: this.vm.windowModel.getWindowBottomHeight(),
      })
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
  }

  @Builder
  recordCard(item: PayRecord) {
    Column() {
      Row() {
        Text(Utils.getPlateFmt(item.plate)).fontSize(14).fontColor($r('sys.color.font_primary'))
        Text(this.vm.getPayText(item))
          .fontSize(14)
          .fontColor(this.vm.getPayTextColor(item))
          .padding({
            top: 4,
            bottom: 4,
            right: 8,
            left: 8,
          })
          .backgroundColor($r('sys.color.comp_background_secondary'))
          .borderRadius(14)
      }.width(Constants.FULL_SIZE)
      .justifyContent(FlexAlign.SpaceBetween)

      Divider().color($r('sys.color.comp_divider')).margin({ top: 12, bottom: 12 })

      Column({ space: 8 }) {
        Row() {
          Image($r('app.media.ic_position')).width(16)
          Text(item.address).fontSize(14).fontColor($r('sys.color.font_primary')).margin({ left: 4 })
        }

        Row() {
          Image($r('app.media.ic_clock')).width(16)
          Text(Utils.getCountdown(item.parkingTime))
            .fontSize(14)
            .fontColor($r('sys.color.font_primary'))
            .margin({ left: 4 })
        }

        Row() {
          Image($r('app.media.ic_point')).width(16)
          Text(`入场时间：${Utils.getFullDate(new Date(item.entryTime))}`)
            .fontSize(14)
            .fontColor($r('sys.color.font_primary'))
            .margin({ left: 4 })
        }

        Row() {
          Image($r('app.media.ic_point_red')).width(16)
          Text(`出场时间：${Utils.getFullDate(new Date(item.entryTime))}`)
            .fontSize(14)
            .fontColor($r('sys.color.font_primary'))
            .margin({ left: 4 })
        }.visibility(item.payStatue === PAY_STATUE.PAYMENT_COMPLETED ? Visibility.Visible : Visibility.None)
      }
      .width(Constants.FULL_SIZE)
      .alignItems(HorizontalAlign.Start)
    }
    .width(Constants.FULL_SIZE)
    .borderRadius(16)
    .padding(12)
    .backgroundColor($r('sys.color.background_primary'))
  }
}
