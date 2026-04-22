import { RechargeTier } from '../models/Index'
import { BreakpointNameEnum, BreakpointType, GridRowColSetting } from '../utils/GridRowColSetting'

@ComponentV2
export struct MyWallet {
  @Param wallet: number = 0
  @Param rechargeTierList: RechargeTier[] = []
  @Param selectTier: RechargeTier = new RechargeTier()
  @Local breakpoint: string = '';
  @Local selectPrivacy: boolean = false
  @Local showPaySheet: boolean = false
  @Event goRechargeCb: () => void = () => {
  }
  @Event changeSelectCb: (selectTier: RechargeTier) => void = () => {
  }
  @Event goWalletTermsCb: () => void = () => {
  }
  @Event goPayCb: () => void = () => {
  }

  build() {
    GridRow(GridRowColSetting.DEFAULT_GRID_ROW_OPTIONS) {
      GridCol({ span: GridRowColSetting.GRID_ROW_OPTIONS_COLUMNS }) {
        Column() {
          Column() {
            Column() {
              Row({ space: 8 }) {
                Image($r('app.media.ic_wallet1')).width(24)
                Text('我的钱包').fontSize(16).fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Medium)
              }

              Text(`￥${this.wallet}`)
                .fontSize(24)
                .fontColor($r('sys.color.font_primary'))
                .fontWeight(FontWeight.Medium)
                .margin({ top: 12 })
              Row() {
                Button({ controlSize: ControlSize.SMALL }) {
                  Row() {
                    SymbolGlyph($r('sys.symbol.yuansign_circle'))
                      .fontSize(16)
                      .fontColor([$r('sys.color.font_on_primary')])
                    Text('账单明细')
                      .fontSize($r('sys.float.Body_M'))
                      .fontWeight(FontWeight.Medium)
                      .fontColor($r('sys.color.font_on_primary'))
                      .margin({ left: 4 })
                  }
                }.height(28).backgroundColor($r('sys.color.multi_color_09')).onClick(() => {
                  this.goRechargeCb()
                })
              }.width('100%').justifyContent(FlexAlign.End).margin({ top: 3 })
            }
            .alignItems(HorizontalAlign.Start)
            .backgroundImage($r('app.media.bg_wallet_card'))
            .backgroundImageSize({ width: '100%', height: 120 })
            .padding(12)
            .borderRadius(16)

            List({ space: 12 }) {
              ForEach(this.rechargeTierList, (item: RechargeTier) => {
                ListItem() {
                  Row() {
                    Row() {
                      Image($r('app.media.ic_wallet_money')).width(24)
                      Text(`${item.realMoney}元`)
                        .fontSize(20)
                        .fontWeight(FontWeight.Medium)
                        .fontColor($r('sys.color.font_primary'))
                        .margin({ left: 8 })
                      Text(`${item.desc}`)
                        .fontSize(14)
                        .fontWeight(FontWeight.Medium)
                        .fontColor($r('sys.color.font_secondary'))
                        .margin({ left: 8 })
                    }

                    Radio({ value: '', group: 'radioTierGroup' })
                      .checked(this.selectTier.id === item.id)
                      .radioStyle({
                        checkedBackgroundColor: $r('sys.color.multi_color_09'),
                      })
                      .height(24)
                      .width(24)
                      .padding(2)
                      .onChange((isChecked: boolean) => {
                        if (isChecked) {
                          this.changeSelectCb(item)
                        }
                      })
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.SpaceBetween)
                  .padding({
                    top: 16,
                    bottom: 16,
                    left: 12,
                    right: 12,
                  })
                  .borderRadius(16)
                  .backgroundColor(this.selectTier.id === item.id ? '#FFF7ED' : $r('sys.color.background_primary'))
                  .border(this.selectTier.id === item.id ? { width: 1, color: $r('sys.color.multi_color_09') } :
                    { width: 0 })
                }
              }, (item: RechargeTier) => item.id)
            }.contentStartOffset(16).contentEndOffset(16).lanes(new BreakpointType<number>({
              [BreakpointNameEnum.SM]: 1,
              [BreakpointNameEnum.MD]: 2,
              [BreakpointNameEnum.LG]: 2,
              [BreakpointNameEnum.XL]: 2,
            }).getValue(this.breakpoint), 12).edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
          }

          Column({ space: 16 }) {
            Row() {
              Checkbox({ name: '' })
                .select($$this.selectPrivacy)
                .selectedColor($r('sys.color.multi_color_09'))
                .shape(CheckBoxShape.CIRCLE)
                .height(24)
                .width(24)
                .padding(2)
                .margin(0)
              Text('我已阅读并同意').fontSize(14).fontColor($r('sys.color.font_secondary')).margin({ left: 6 })
              Text('《xxxx会员储值协议》').fontSize(14).fontColor($r('sys.color.multi_color_09')).onClick(() => {
                this.goWalletTermsCb()
              })
            }
            .width('100%')
            .justifyContent(this.breakpoint === BreakpointNameEnum.SM ? FlexAlign.Start : FlexAlign.Center)

            Button('立即充值')
              .fontSize($r('sys.float.Body_M'))
              .fontWeight(FontWeight.Medium)
              .fontColor(this.selectTier.id && this.selectPrivacy ? $r('sys.color.font_on_primary') :
                $r('sys.color.font_primary'))
              .width('100%')
              .constraintSize({ maxWidth: 448 })
              .backgroundColor(this.selectTier.id && this.selectPrivacy ? $r('sys.color.multi_color_09') :
                $r('sys.color.comp_background_tertiary'))
              .onClick(() => {
                if (this.selectTier.id && this.selectPrivacy) {
                  this.goPayCb()
                }
              })
          }

        }
        .height('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
    }
    .onBreakpointChange((bp) => {
      this.breakpoint = bp;
    })

  }
}
