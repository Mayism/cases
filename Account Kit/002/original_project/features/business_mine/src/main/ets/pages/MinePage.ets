import { Constants, DiamondZone, NavHeaderBar, RouterMap, RouterUtil } from 'lib_common';
import { MinePageViewModel } from '../viewmodel/MinePageViewModel';
import { MenuComp } from '../components/MenuComp';
import { UserInfoComp } from '../components/UserInfoComp';

@Builder
export function MinePageBuilder() {
  MinePage()
}

@ComponentV2
struct MinePage {
  @Local vm: MinePageViewModel = new MinePageViewModel()

  build() {
    NavDestination() {
      NavHeaderBar({
        title: '我的',
        isMainPage: true,
        hasBackButton: false,
        hasBgColor: false
      })
      Scroll() {
        Column({ space: 16 }) {
          UserInfoComp({ vm: this.vm })
          this.mineCard()
          Grid() {
            ForEach(this.vm.diamondZoneList, (item: DiamondZone) => {
              GridItem() {
                Column() {
                  Image(item.icon).width(32).height(32)
                  Text(item.title).fontSize(12).fontColor($r('sys.color.font_primary')).margin({ top: 8 })
                }
                .onClick(() => {
                  if (item.url) {
                    RouterUtil.pushPathByName(item.url)
                  }
                })
              }
            }, (v: DiamondZone) => JSON.stringify(v))
          }
          .width(Constants.FULL_SIZE)
          .height(80)
          .rowsGap(10)
          .columnsGap(10)
          .padding(12)
          .borderRadius(16)
          .columnsTemplate('1fr 1fr 1fr')
          .backgroundColor($r('sys.color.background_primary'))

          MenuComp({ vm: this.vm })
        }
        .padding({
          left: Constants.BORDER_WIDTH,
          right: Constants.BORDER_WIDTH,
          top: 12,
          bottom: 16
        })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.Top)
    }
    .width(Constants.FULL_SIZE)
    .height(Constants.FULL_SIZE)
    .linearGradient({
      direction: GradientDirection.Top, // 渐变方向
      repeating: false, // 渐变颜色是否重复
      colors: [['#F1F3F5', 0.0], ['#EFFFE4', 1]], // 数组末尾元素占比小于1时满足重复着色效果
    }).hideTitleBar(true)
  }

  @Builder
  mineCard() {
    Column({ space: 8 }) {
      Row({ space: 8 }) {
        Row() {
          Image($r('app.media.ic_home_self_point')).width(36).margin({ top: 4 })
          Column() {
            Text('我的积分').fontSize(14).fontColor($r('sys.color.font_primary')).height(19).textAlign(TextAlign.Center)
            Text(this.vm.globalPointInfo.myPoints.toString())
              .fontSize(14)
              .fontColor($r('sys.color.font_primary'))
              .margin({ top: 4 })
              .height(19)
              .textAlign(TextAlign.Center)
          }.height(42).margin({ left: 11 }).alignItems(HorizontalAlign.Start)
        }
        .height(60)
        .layoutWeight(1)
        .padding({ left: 12, top: 8, bottom: 8 })
        .borderRadius(16)
        .backgroundImage($r('app.media.bg_score'))
        .backgroundImageSize(ImageSize.Cover)
        .onClick(() => {
          RouterUtil.pushPathByName(RouterMap.SELF_POINT_RECORD_PAGE)
        })

        Row() {
          Image($r('app.media.ic_mine_wallet')).width(36).margin({ top: 4 })
          Column() {
            Text('我的钱包').fontSize(14).fontColor($r('sys.color.font_primary')).height(19).textAlign(TextAlign.Center)
            Text('￥' + this.vm.globalInfo.myWallet)
              .fontSize(14)
              .fontColor($r('sys.color.font_primary'))
              .margin({ top: 4 })
              .height(19)
              .textAlign(TextAlign.Center)
          }.height(42).margin({ left: 11 }).alignItems(HorizontalAlign.Start)
        }
        .height(60)
        .layoutWeight(1)
        .padding({ left: 12, top: 8, bottom: 8 })
        .borderRadius(16)
        .backgroundImage($r('app.media.bg_wallet'))
        .backgroundImageSize(ImageSize.Cover)
        .onClick(() => {
          RouterUtil.pushPathByName(RouterMap.MY_WALLET_PAGE)
        })
      }

      Row({ space: 8 }) {
        Row() {
          Image($r('app.media.ic_mine_coupon')).width(36).margin({ top: 4 })
          Column() {
            Text('我的券包').fontSize(14).fontColor($r('sys.color.font_primary')).height(19).textAlign(TextAlign.Center)
            Text(this.vm.globalCouponInfo.validCouponListCount.toString())
              .fontSize(14)
              .fontColor($r('sys.color.font_primary'))
              .margin({ top: 4 })
              .height(19)
              .textAlign(TextAlign.Center)
          }.height(42).margin({ left: 11 }).alignItems(HorizontalAlign.Start)
        }
        .height(60)
        .layoutWeight(1)
        .padding({ left: 12, top: 8, bottom: 8 })
        .borderRadius(16)
        .backgroundImage($r('app.media.bg_coupon'))
        .backgroundImageSize(ImageSize.Cover)
        .onClick(() => {
          RouterUtil.pushPathByName(RouterMap.MY_COUPONS_PAGE);
        })

        Row() {
        }.layoutWeight(1)
      }
    }
  }
}

