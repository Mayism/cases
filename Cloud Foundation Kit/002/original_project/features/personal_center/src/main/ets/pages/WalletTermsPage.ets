import { NavHeaderBar } from 'common';

@Builder
export function WalletTermsPageBuilder() {
  WalletTermsPage();
}

@ComponentV2
struct WalletTermsPage {
  private agreementText: string = `XXXX会员储值协议
协议编号：XXXXXX
生效日期：YYYY年MM月DD日

第一条 定义
会员储值：指用户通过指定渠道向XXXX平台预存资金，用于后续消费的行为。

储值账户：平台为用户开设的虚拟资金账户，记录储值余额及使用情况。

第二条 储值规则
充值方式：

用户可通过华为支付指定渠道充值。

余额管理：

储值余额仅限本账号消费使用，不可转让、提现或兑换现金。

余额有效期：自充值之日起至【XX年】或平台公示的终止日期。

第三条 使用规则
消费范围：

限用于XXXX平台内指定商品/服务，不可用于违法违规用途。

退款规则：

非平台原因导致的储值，原则上不予退款。

因平台停运等特殊情况，将按法律法规处理。

第四条 用户权利义务
用户需确保充值行为合法，且资金来源正当。

平台有权冻结涉嫌违规的储值账户，并配合监管机构调查。

第五条 免责条款
因以下情况导致储值损失，平台不承担责任：

用户泄露账户信息导致的盗用。

不可抗力（如自然灾害、系统故障等）。

第六条 协议修改与终止
平台有权根据业务调整修改本协议，修改后将通过官网/APP公示。

用户继续使用储值服务视为接受修改后的协议。

提示：充值前请仔细阅读本协议，点击确认即视为同意全部条款。

XXXX公司
联系电话：XXX-XXXXXXX
官方网址：www.xxxxxxx.com`

  build() {
    NavDestination() {
      NavHeaderBar({ title: '会员储值协议' })
      Scroll() {
        Text(this.agreementText)
          .fontSize(16)
          .fontColor($r('sys.color.font_primary'))
          .lineHeight(22)
          .padding(16)
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .width('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1)
    }.hideTitleBar(true);
  }
}