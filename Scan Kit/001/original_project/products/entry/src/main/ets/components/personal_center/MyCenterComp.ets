import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { PersistenceV2 } from '@kit.ArkUI';
import { Constants, HomePageRouter, RouterMap, RouterModule, UserInfoModel } from 'common/Index';
import * as API from '../../api/Index';

@ComponentV2
export struct MyCenterComp {
  @Consumer('currentIndex') currentIndex: number = 0
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!

  @Styles
  cardStyle(){
    .layoutWeight(1)
    .padding({
      left: 12,
      right: 12,
      top: 16,
      bottom: 16,
    })
    .borderRadius(16)
    .backgroundColor(Color.White)
  }

  build() {
    Column() {
      Row({ space: 16 }) {
        Row() {
          Column() {
            Text($r('app.string.wallet')).fontSize($r('sys.float.Body_S')).fontColor($r('sys.color.font_primary'))
            Text($r('app.string.yuan_params',
              `${this.userInfoModel.isRelative ? this.userInfoModel.userInfo.wallet : 0}`))
              .fontSize($r('sys.float.Caption_M'))
              .fontColor(this.userInfoModel.isRelative ? $r('sys.color.multi_color_09') :
                $r('sys.color.font_secondary')).margin({ top: 4 })
          }.alignItems(HorizontalAlign.Start)

          Image($r('app.media.wallet')).width(32)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .cardStyle()
        .onClick(() => {
          if (!this.userInfoModel.isRelative) {
            promptAction.showToast({ message: '请先关联账号~' })
            return
          }
          RouterModule.push(RouterMap.MY_WALLET_PAGE, null, (popInfo: PopInfo) => {
            API.getUserInfo().then(res => {
              this.userInfoModel.userInfo.wallet = res.wallet
            })
          })
        })

        Row() {
          Column() {
            Text($r('app.string.my_coupon')).fontSize($r('sys.float.Body_S')).fontColor($r('sys.color.font_primary'))
            Text($r('app.string.my_coupon_desc'))
              .fontSize($r('sys.float.Caption_M'))
              .fontColor($r('sys.color.font_secondary'))
              .margin({ top: 4 })
          }.alignItems(HorizontalAlign.Start)

          Image($r('app.media.coupon')).width(32)
        }
        .cardStyle()
        .justifyContent(FlexAlign.SpaceBetween)
        .onClick(() => {
          if (!this.userInfoModel.isRelative) {
            promptAction.showToast({ message: '请先关联账号~' })
            return
          }
          RouterModule.push(RouterMap.MY_COUPONS_PAGE, null, (popInfo: PopInfo) => {
            let result = popInfo.result as HomePageRouter
            this.currentIndex = result.index
          })
        })
      }
      .width(Constants.FULL_SIZE)
      .justifyContent(FlexAlign.SpaceBetween)

      Row({ space: 16 }) {
        Row() {
          Column() {
            Text($r('app.string.points')).fontSize($r('sys.float.Body_S')).fontColor($r('sys.color.font_primary'))
            Text($r('app.string.points_param',
              `${this.userInfoModel.isRelative ? this.userInfoModel.userInfo.totalScore : 0}`))
              .fontSize($r('sys.float.Caption_M'))
              .fontColor(this.userInfoModel.isRelative ? $r('sys.color.multi_color_09') :
                $r('sys.color.font_secondary')).margin({ top: 4 })
          }.alignItems(HorizontalAlign.Start)

          Image($r('app.media.ic_score_card')).width(32)
        }
        .cardStyle()
        .justifyContent(FlexAlign.SpaceBetween)
        .onClick(() => {
          if (!this.userInfoModel.isRelative) {
            promptAction.showToast({ message: '请先关联账号~' })
            return
          }
          RouterModule.push(RouterMap.MY_POINTS_PAGE, null, (popInfo: PopInfo) => {
            let result = popInfo.result as HomePageRouter
            this.currentIndex = result.index
          })
        })

        Row() {
          Column() {
            Text('我的预约/排号').fontSize($r('sys.float.Body_S')).fontColor($r('sys.color.font_primary'))
            Text('降低等待时间')
              .fontSize($r('sys.float.Caption_M'))
              .fontColor($r('sys.color.font_secondary')).margin({ top: 4 })
          }.alignItems(HorizontalAlign.Start)

          Image($r('app.media.ic_preorder_card')).width(32)
        }
        .cardStyle()
        .justifyContent(FlexAlign.SpaceBetween)
        .onClick(() => {
          if (!this.userInfoModel.isRelative) {
            promptAction.showToast({ message: '请先关联账号~' })
            return
          }
          RouterModule.push(RouterMap.ORDER_LIST_PAGE, null, (popInfo: PopInfo) => {
            let result = popInfo.result as HomePageRouter
            this.currentIndex = result.index
          })
        })
      }.justifyContent(FlexAlign.Start).margin({ top: 12 })

    }
    .width(Constants.FULL_SIZE)
    .margin({ top: 12 })
  }
}