import { Constants, EmptyComp, NavHeaderBar, RouterMap, RouterUtil, Utils, Wallet } from 'lib_common';
import { WalletConstants, WalletItem } from '../constants/WalletConstants';
import { MyWalletViewModel } from '../viewmodel/MyWalletViewModel';

@Builder
export function MyWalletPageBuilder() {
  MyWalletPage()
}

@ComponentV2
struct MyWalletPage {
  @Local vm: MyWalletViewModel = MyWalletViewModel.instance

  @Computed
  get walletFilterList() {
    return this.vm.walletList.filter(item => this.vm.actionType === 0 || item.action === this.vm.actionType)
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: '我的钱包', hasBgColor: false })
      Column({ space: 12 }) {
        Row() {
          Column() {
            Text('钱包余额').fontSize(12).fontColor($r('sys.color.font_secondary'))
            Text('￥' + this.vm.getAmount())
              .fontSize(24)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
              .margin({ top: 4 })
          }.alignItems(HorizontalAlign.Start)

          Stack() {
            Image($r('app.media.bg_self_point_title_right')).width(133).height(78)
            Button('充值', { controlSize: ControlSize.SMALL })
              .fontSize($r('sys.float.Body_M'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_on_primary'))
              .width(72)
              .margin({ bottom: 4, right: 10 })
              .backgroundColor($r('app.color.app_theme'))
              .onClick(() => {
                RouterUtil.pushPathByName(RouterMap.RECHARGE_WALLET_PAGE, null, () => {
                  this.vm.chargeWallet();
                  this.getUIContext().getPromptAction().showToast({ message: '充值成功~' });
                })
              })
          }.alignContent(Alignment.BottomEnd)
        }
        .width(Constants.FULL_SIZE)
        .height(96)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: 24, right: 2 })
        .borderRadius(16)
        .clip(true)
        .backgroundImage($r('app.media.bg_self_point_title'))
        .backgroundImageSize({ width: Constants.FULL_SIZE, height: 96 })

        Column({ space: 12 }) {
          Row() {
            Text(this.vm.searchMonth.join(''))
              .fontSize(14)
              .fontColor($r('sys.color.font_secondary'))
            Image($r('app.media.ic_arrow_down_fill')).width(24)
          }
          .onClick(() => {
            this.vm.datePickerSheet = true
          })
          .bindSheet($$this.vm.datePickerSheet,
            this.DatePickerSheet(), {
              height: 336,
              preferType: SheetType.CENTER,
              showClose: false,
            })

          Row({ space: 8 }) {
            ForEach(WalletConstants.TAB_OPTIONS, (v: WalletItem) => {
              Text(v.title)
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor(this.vm.actionType === v.value ? $r('sys.color.font_on_primary') :
                $r('sys.color.font_primary'))
                .padding({
                  top: 4,
                  bottom: 4,
                  left: 8,
                  right: 8,
                })
                .backgroundColor(this.vm.actionType === v.value ? $r('app.color.app_theme') : $r('sys.color.comp_background_tertiary'))
                .borderRadius(14)
                .onClick(() => {
                  this.vm.actionType = v.value
                })
            }, (v: WalletItem) => JSON.stringify(v))
          }
          .margin({ top: 12 })
        }
        .width(Constants.FULL_SIZE)
        .height(96)
        .padding(12)
        .alignItems(HorizontalAlign.Start)
        .borderRadius(16)
        .backgroundColor($r('sys.color.background_primary'))
        .backgroundImage($r('app.media.bg_wallet_month'))
        .backgroundImageSize({ width: Constants.FULL_SIZE, height: 96 })
        .clip(true)

        Row() {
          Text('变动明细')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
        }.width(Constants.FULL_SIZE)

        Column() {
          List({ space: 12 }) {
            ForEach(this.walletFilterList, (wallet: Wallet) => {
              ListItem() {
                Row() {
                  Column() {
                    Text(wallet.name)
                      .fontSize(14)
                      .fontWeight(FontWeight.Medium)
                      .fontColor($r('sys.color.font_primary'))
                    Text(Utils.getFullDate(new Date(wallet.time)))
                      .fontSize(12)
                      .fontColor($r('sys.color.font_tertiary'))
                      .margin({ top: 2 })
                  }.alignItems(HorizontalAlign.Start)

                  Text(`${wallet.action === 1 ? '+' : '-'}${wallet.money}`)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(wallet.action === 1 ? $r('app.color.app_theme') : $r('sys.color.font_primary'))
                }.width(Constants.FULL_SIZE).justifyContent(FlexAlign.SpaceBetween).padding({ top: 8, bottom: 8 })
              }
            }, (wallet: Wallet) => JSON.stringify(wallet))
          }
          .scrollBar(BarState.Off)
          .divider({ strokeWidth: 1 })
          .contentEndOffset(12)
          .visibility(this.walletFilterList.length ? Visibility.Visible : Visibility.None)
          .layoutWeight(1)
          .backgroundColor($r('sys.color.background_primary'))
          .borderRadius(16)
          .padding({ left: 12, right: 12 })

          // 空数据展示
          Column() {
            EmptyComp({ text: '暂无历史记录', image: $r('app.media.ic_no_record') })
          }
          .justifyContent(FlexAlign.Center)
          .layoutWeight(1)
          .backgroundColor($r('sys.color.background_primary'))
          .borderRadius(16)
          .visibility(this.walletFilterList.length ? Visibility.None : Visibility.Visible)
        }.layoutWeight(1).alignItems(HorizontalAlign.Start)
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
  DatePickerSheet() {
    Column() {
      TextPicker({ range: this.vm.multi, value: $$this.vm.selectMonth })
        .width(Constants.FULL_SIZE)
        .disappearTextStyle({
          color: $r('sys.color.font_primary'),
          font: { size: 14 },
        })// 设置所有选项中除了最上、最下及选中项以外的文本颜色、字号、字体粗细。
        .textStyle({
          color: $r('sys.color.font_primary'),
          font: {
            size: 16,
          },
        })// 设置选中项的文本颜色、字号、字体粗细。
        .selectedTextStyle({
          color: $r('app.color.app_theme'),
          font: {
            size: 20,
            weight: FontWeight.Medium,
          },
        })
        .canLoop(false)
        .divider(null)
        .margin({ top: 8, bottom: 12 })
        .padding({ top: 16, bottom: 16 })
      Row({ space: 12 }) {
        Button('取消')
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
          .layoutWeight(1)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => {
            this.vm.selectMonth = this.vm.searchMonth
            this.vm.datePickerSheet = false
          })
        Button('确认')
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_on_primary'))
          .layoutWeight(1)
          .backgroundColor($r('app.color.app_theme'))
          .onClick(() => {
            this.vm.searchMonth = this.vm.selectMonth
            this.vm.datePickerSheet = false
            this.vm.filterWalletListByMonth();
          })
      }
    }
    .width(Constants.FULL_SIZE)
    .constraintSize({ maxWidth: Constants.FULL_SIZE })
    .margin({ left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH })
  }
}
