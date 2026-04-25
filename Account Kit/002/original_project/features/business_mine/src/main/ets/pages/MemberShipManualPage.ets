import { NavHeaderBar } from 'lib_common';

@Builder
export function MemberShipManualPageBuilder() {
  MemberShipManualPage()
}

@ComponentV2
struct MemberShipManualPage {
  build() {
    NavDestination() {
      NavHeaderBar({ title: '会员手册', hasBgColor: false })
      Column({ space: 16 }) {
        Text('会员章程').fontSize($r('sys.float.Title_M')).fontWeight(FontWeight.Medium)
        Column({ space: 8 }) {
          Text('会员开通').fontSize($r('sys.float.Subtitle_M')).fontWeight(FontWeight.Medium)
          Text('打开元服务，会自动静默登录华为账号。').fontSize($r('sys.float.Body_S'))
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        Column({ space: 8 }) {
          Text('会员说明').fontSize($r('sys.float.Subtitle_M')).fontWeight(FontWeight.Medium)
          Text('会员可用于商城线上线下一体化消费，参与会员折扣，累积积分。\n' +
            '为了能准确地向会员提供信息，在会员的移动电话、通讯地址等个人信息有所变动时，请及时更新元服务内的个人信息，确保持卡会员权益。')
            .fontSize($r('sys.float.Body_S'))
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        Column({ space: 8 }) {
          Text('会员资格').fontSize($r('sys.float.Subtitle_M')).fontWeight(FontWeight.Medium)
          Text('会员自注册成功后以一个自然年为计算周期。\n' +
            '管理方拥有对会员变更的决定与解释权，会员的变更信息我们会及时向您进行提示和提供操作指引。')
            .fontSize($r('sys.float.Body_S'))
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }
      .padding(16)
    }
    .hideTitleBar(true)
  }
}