import { ContextUtils } from '../libcommon/ContextUtils';
import { NavHeaderBar } from '../libcommon/Index';

@Builder
export function SelfPointRuleBuilder() {
  SelfPointRule()
}

@ComponentV2
struct SelfPointRule {
  @Provider() pathStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    ContextUtils.setUIContext(this.getUIContext());
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: '积分规则', hasBgColor: false })
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
            Row({ space: 8 }) {
              Image($r('app.media.ic_question')).width(24)
              Text('什么是积分?').fontSize(16).fontWeight(500)
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)

            Row({ space: 8 }) {
              Image($r('app.media.ic_answer')).width(24)
              Text('积分是针对会员推出的一种积分兑换服务，会员在购物过程中累积积分，然后可以将积分用于兑换商品或享受其他会员福利。')
                .layoutWeight(1)
                .fontSize(12)
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)
          }
          .margin({ top: 16 })

          Divider().color($r('sys.color.comp_divider')).margin({ top: 12, bottom: 12 })

          Column({ space: 8 }) {
            Text('会员积分兑换细则：').fontSize(16).fontWeight(500)
            Column() {
              Text('1、积分累积方式：\n' +
                '会员在购物时，根据消费金额累积相应积分。一般来说，每消费1元可以获得1积分。\n' +
                '2、积分分有效期：\n' +
                '积分通常有一个有效期 ，例如一年。在有效期內使用枳分兌換商品，超过有效期积分将失效。\n' +
                '3、积分兑换：\n' +
                '例如100积分可以兑换1元的商品或一次性兑换停车券、抵扣券等。\n' +
                '4.、兑换方式：\n' +
                '会员可以在商场柜台直接兑换，也可以通过终端设备应用程序进行兑换。').fontSize(12)
            }
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
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