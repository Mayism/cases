import { Constants, NavHeaderBar, PayRecord, Utils } from 'lib_common';
import { PaySuccessViewModel } from '../viewmodel/PaySuccessViewModel';

@Builder
export function PaySuccessPageBuilder() {
  PaySuccessPage()
}

@ComponentV2
struct PaySuccessPage {
  vm: PaySuccessViewModel = new PaySuccessViewModel();

  build() {
    NavDestination() {
      NavHeaderBar({ title: '缴费成功' })
      Scroll() {
        Column() {
          Column({ space: 6 }) {
            Text('缴费成功').fontSize($r('sys.float.Title_M')).fontWeight(FontWeight.Medium)
            Row({ space: 4 }) {
              Text('车辆请在').fontSize(14).fontColor($r('sys.color.font_secondary'))
              Text('15分钟').fontSize(14).fontColor($r('sys.color.multi_color_08'))
              Text('内离场').fontSize(14).fontColor($r('sys.color.font_secondary'))
            }
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ top: 24 })

          this.carInfoCard(this.vm.payRecord)
          Column() {
            Button('返回首页')
              .fontSize($r('sys.float.Body_L'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_on_primary'))
              .width('100%')
              .height(40)
              .backgroundColor($r('app.color.app_theme'))
              .onClick(() => {
                this.vm.backHome();
              })
          }
          .layoutWeight(1)
          .constraintSize({ minHeight: 72 })
          .justifyContent(FlexAlign.End)
          .padding({ top: 16, bottom: 16 })

        }
        .width('100%')
        .padding({
          left: Constants.BORDER_WIDTH,
          right: Constants.BORDER_WIDTH,
          bottom: this.vm.getWindowBottomHeight()
        })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
    .onBackPressed(() => {
      return this.vm.onBackPressed();
    })
  }

  @Builder
  carInfoCard(item: PayRecord) {
    Column() {
      Text('车辆信息').fontSize(16).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
      Column() {
        Row() {
          Text('车牌号').fontSize(14).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
          Text(Utils.getPlateFmt(item.plate)).fontSize(14).fontColor($r('sys.color.font_primary'))
        }.width(Constants.FULL_SIZE)
        .padding(12)
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Text('停车场').fontSize(14).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
          Text(item.address).fontSize(14).fontColor($r('sys.color.font_primary'))
        }.width(Constants.FULL_SIZE).padding(12)
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Text('入场时间').fontSize(14).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
          Text(Utils.getFullDate(new Date(item.entryTime))).fontSize(14).fontColor($r('sys.color.font_primary'))
        }.width(Constants.FULL_SIZE).padding(12)
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Text('停留时间').fontSize(14).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
          Text(Utils.getCountdown(item.parkingTime)).fontSize(14).fontColor($r('sys.color.font_primary'))
        }.width(Constants.FULL_SIZE).padding(12)
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Text('支付金额').fontSize(14).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
          Text(`￥${item.money}`).fontSize(14).fontColor($r('sys.color.multi_color_08')).fontWeight(500)
        }.width(Constants.FULL_SIZE).padding(12)
        .justifyContent(FlexAlign.SpaceBetween)
      }.cardStyle()
    }
    .alignItems(HorizontalAlign.Start)
    .margin({ top: 24 })
  }

  @Styles
  cardStyle(){
    .width(Constants.FULL_SIZE)
    .borderRadius(16)
    .margin({ top: 12 })
    .backgroundColor($r('sys.color.background_primary'))
    .clip(true)
  }
}