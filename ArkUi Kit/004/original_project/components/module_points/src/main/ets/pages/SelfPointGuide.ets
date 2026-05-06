import { ContextUtils } from '../libcommon/ContextUtils';
import { NavHeaderBar } from '../libcommon/Index';

@Builder
export function SelfPointGuideBuilder() {
  SelfPointGuide()
}

@ComponentV2
struct SelfPointGuide {
  @Provider() pathStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    ContextUtils.setUIContext(this.getUIContext());
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: '自助积分指南', hasBgColor: false })
      Scroll() {
        Column() {
          Image($r('app.media.point_banner'))
            .width('100%')
            .borderRadius(16)
            .margin({ top: 12 })
            .constraintSize({
              maxHeight: '35%',
            })

          Column({ space: 8 }) {
            Text('操作指引').fontSize(16).fontWeight(500)
            Column() {
              Text('1、若您拿到的是商场统一的购物小票，请进入元服务点击“自助积分”，选择“扫码积分”→直接扫描购物小票上的一维条码即可自助积分到账；\n' +
                '\n' +
                '2、若您拿到的是商户的购物小票，请进入元服务点击“自助积分”，选择“拍照积分”，需要您拍照上传收银小票的照片进行审核（注：银行POS单、餐饮点菜单等单据为无效收银小票），照片需清晰拍摄收银机号、小票号、购买日期、购买金额四项信息，审核通过后积分将累计至您的积分账户中。审核需要1个工作日，请您耐心等待。')
                .fontSize(12)
            }
          }
          .margin({ top: 16 })
          .alignItems(HorizontalAlign.Start)

          Divider().color($r('sys.color.comp_divider')).margin({ top: 12, bottom: 12 })

          Column({ space: 8 }) {
            Text('自助积分规则').fontSize(16).fontWeight(500)
            Column() {
              Text('1、小票有效期为15天，请在有效期内积分，逾期作废。\n' +
                '\n' +
                '2、自助积分需要您上传收银小票的照片进行审核（注：银行POS单、餐饮点菜单等单据为无效收银小票），照片需清晰拍摄收银机号、小票号、购买日期、购买金额四项信息，审核通过后积分将累计至您的积分账户中。\n' +
                '\n' +
                '3、请妥善保管好您的收银小票，如无法补积分（无法补积分说明：如遇数据不完整、系统升级等原因，极少数情况下会出现无法补积分的情况）需持收银小票至负一楼顾客服务中心进行积分。')
                .fontSize(12)
            }
          }
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(HorizontalAlign.Start)
        .padding({ left: 16, right: 16, bottom: 28 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
      .edgeEffect(EdgeEffect.Spring)
    }
    .hideTitleBar(true)
    .onReady((context) => {
      this.pathStack = context.pathStack;
    })
  }
}
