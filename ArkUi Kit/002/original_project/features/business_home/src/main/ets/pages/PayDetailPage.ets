import { common } from '@kit.AbilityKit';
import { Constants, FormatUtils, NavHeaderBar, PayRecord, SheetHeaderComp, Utils } from 'lib_common';
import { SelectCoupons } from 'module_coupon';
import { PayDetailViewModel } from '../viewmodel/PayDetailViewModel';

@Builder
export function PayDetailPageBuilder() {
  PayDetailPage()
}

@ComponentV2
struct PayDetailPage {
  @Local vm: PayDetailViewModel = new PayDetailViewModel()
  context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;

  aboutToAppear(): void {
    this.vm.getParams()
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: '缴费详情' })
      Scroll() {
        Column({ space: 12 }) {
          this.carInfoCard(this.vm.payRecord)
          this.couponCard(this.vm.payRecord)
          this.walletCard(this.vm.payRecord)
          Column({ space: 12 }) {
            Row() {
              Image($r('app.media.ic_tips')).width(16)
              Text('停车支付说明').fontSize(12).fontColor($r('sys.color.font_primary')).margin({ left: 6 })
            }
            .onClick(() => {
              this.vm.showPayIntroSheet = true;
            })
            .bindSheet($$this.vm.showPayIntroSheet, this.payIntroduceBuilder(), {
              height: SheetSize.FIT_CONTENT,
              preferType: SheetType.CENTER,
              showClose: false,
            });

            Row() {
              Text('还需支付：').fontSize(16).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
              Text(`￥${this.vm.getActualPayMoney()}`)
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.multi_color_08'))
                .margin({ left: 4 })
            }
          }

          Column() {
            Button('立即支付')
              .fontSize($r('sys.float.Body_L'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_on_primary'))
              .width(Constants.FULL_SIZE)
              .height(40)
              .backgroundColor($r('app.color.app_theme'))
              .onClick(() => {
                this.vm.payOrder(this.context)
              })
          }
          .layoutWeight(1)
          .constraintSize({ minHeight: 72 })
          .justifyContent(FlexAlign.End)
          .padding({ top: 16, bottom: 16 })
        }
        .width(Constants.FULL_SIZE)
        .padding({
          top: 12,
          left: Constants.BORDER_WIDTH,
          right: Constants.BORDER_WIDTH,
          bottom: this.vm.getWindowBottomHeight()
        })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
    }
    .backgroundColor($r('sys.color.background_secondary')).hideTitleBar(true)
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
          Text('本次应付').fontSize(14).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
          Text(`￥${FormatUtils.formatCurrency(Number(item.money))}`)
            .fontSize(14)
            .fontColor($r('sys.color.multi_color_08'))
        }.width(Constants.FULL_SIZE).padding(12)
        .justifyContent(FlexAlign.SpaceBetween)
      }.cardStyle()
    }.alignItems(HorizontalAlign.Start)

  }

  @Builder
  couponCard(item: PayRecord) {
    Column() {
      Text('停车券/积分抵扣（二选一）').fontSize(16).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
      Column() {
        Row() {
          Text('停车券').fontSize(14).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
          Row({ space: 4 }) {
            Text(this.vm.getCouponSelectText()).fontSize(14).fontColor(this.vm.getCouponSelectTextFg)
            Image($r('app.media.ic_right')).width(16).fillColor('#999999')
          }
          .onClick(() => {
            this.vm.showCouponSheet = true;
          })
          .bindSheet($$this.vm.showCouponSheet, this.selectCouponSheet(), {
            detents: [500, 750],
            preferType: SheetType.CENTER,
            scrollSizeMode: ScrollSizeMode.CONTINUOUS,
            showClose: false,
            backgroundColor: $r('sys.color.background_secondary'),
          })
        }
        .width(Constants.FULL_SIZE)
        .padding(12)
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Column({ space: 2 }) {
            Text('积分').fontSize(14).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
            Row() {
              Text('余额：').fontSize(10).fontColor($r('sys.color.font_primary'))
              Text(this.vm.globalPointInfo.myPoints.toString())
                .fontSize(10)
                .fontColor($r('sys.color.multi_color_04'))
                .margin({ left: 4 })
            }
          }.alignItems(HorizontalAlign.Start)

          Row({ space: 4 }) {
            Text(this.vm.getPointSelectText())
              .fontSize(14)
              .fontColor(this.vm.getPointSelectTextFg)
            Image($r('app.media.ic_right')).width(16).fillColor('#999999')
          }
          .onClick(() => {
            this.vm.showPointSheet = true;
          })
          .bindSheet($$this.vm.showPointSheet, this.selectPointSheet(), {
            height: SheetSize.FIT_CONTENT,
            preferType: SheetType.CENTER,
            showClose: false,
          });
        }
        .width(Constants.FULL_SIZE)
        .padding(12)
        .justifyContent(FlexAlign.SpaceBetween)
      }.cardStyle()
    }.alignItems(HorizontalAlign.Start)

  }

  @Builder
  selectPointSheet() {
    Column() {
      SheetHeaderComp({
        title: '积分抵扣',
        close: () => {
          this.vm.tempSelectPayPoint = this.vm.selectPayPoint;
          this.vm.showPointSheet = false;
        },
      })
      Column({ space: 16 }) {
        Column() {
          ForEach([[400, 1], [800, 2]], (item: number[]) => {
            Row() {
              Row({ space: 4 }) {
                Text(item[0].toString()).fontSize(20).fontWeight(500).lineHeight(28)
                Text('积分抵扣').fontSize(16)
                Text(item[1].toString()).fontSize(20).fontWeight(500).lineHeight(28)
                Text('小时').fontSize(16)
              }
              .alignItems(VerticalAlign.Bottom)

              Blank()
              if (this.vm.globalPointInfo.myPoints >= item[0]) {
                Radio({ value: item[0].toString(), group: 'radioGroup', indicatorType: RadioIndicatorType.TICK })
                  .checked(this.vm.tempSelectPayPoint === item[0].toString())
                  .radioStyle({
                    checkedBackgroundColor: $r('app.color.app_theme'),
                  })
                  .height(20)
                  .width(20)
                  .onClick(() => {
                    if (this.vm.tempSelectPayPoint === item[0].toString()) {
                      this.vm.tempSelectPayPoint = '';
                    } else {
                      this.vm.tempSelectPayPoint = item[0].toString();
                    }
                  })
              } else {
                Text('积分不足').fontSize(12).fontColor($r('sys.color.multi_color_08'))
              }
            }
            .width(Constants.FULL_SIZE)
            .height(52)
          }, (v: number[]) => v[0]?.toString())
        }

        Column() {
          Button('确定')
            .width(Constants.FULL_SIZE)
            .backgroundColor($r('app.color.app_theme'))
            .borderRadius(20)
            .height(40)
            .onClick(() => {
              this.vm.selectPayPoint = this.vm.tempSelectPayPoint;
              this.vm.selectedCouponID = '';
              this.vm.selectedCouponMoney = 0;
              this.vm.showPointSheet = false;
            })
        }
        .padding({
          top: 26,
          bottom: 8,
        })
      }
      .backgroundColor($r('sys.color.background_primary'))
      .borderRadius({ topLeft: 16, topRight: 16 })
      .padding({
        top: 16,
        left: 12,
        right: 12,
        bottom: this.vm.getWindowBottomHeight()
      })
    }
    .width(Constants.FULL_SIZE)
    .padding({ left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH })
    .backgroundColor($r('sys.color.background_secondary'))
  }

  @Builder
  selectCouponSheet() {
    Column() {
      SheetHeaderComp({
        title: '选择停车券',
        close: () => {
          this.vm.showCouponSheet = false;
        },
      })
      Column() {
        SelectCoupons({
          selectIdParam: this.vm.selectedCouponID,
          onSelect: (id: string, money: number) => {
            this.vm.selectedCouponID = id;
            this.vm.selectedCouponMoney = money;
            this.vm.selectPayPoint = '';
            this.vm.tempSelectPayPoint = '';
            this.vm.showCouponSheet = false;
          },
        })
      }
      .layoutWeight(1)
    }
    .width(Constants.FULL_SIZE)
    .padding({ left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH, bottom: this.vm.getWindowBottomHeight() })
  }

  @Builder
  walletCard(item: PayRecord) {
    Column() {
      Text('电子钱包支付').fontSize(16).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
      Column() {
        Row() {
          Column({ space: 2 }) {
            Text('电子钱包').fontSize(14).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
            Row({ space: 4 }) {
              Text('余额：').fontSize(10).fontColor($r('sys.color.font_primary'))
              Text(`￥${this.vm.globalInfo.myWallet}`)
                .fontSize(10)
                .fontColor($r('sys.color.multi_color_04'))
            }
          }.alignItems(HorizontalAlign.Start)

          Row({ space: 8 }) {
            Text(FormatUtils.formatCurrency(this.vm.useWalletMoney))
              .fontSize(14)
              .fontColor($r('sys.color.font_secondary'))

            Toggle({ type: ToggleType.Switch, isOn: this.vm.useWallet })
              .selectedColor($r('app.color.app_theme'))
              .switchPointColor($r('sys.color.comp_background_primary_contrary'))
              .enabled(this.vm.enableWallet)
              .onChange((isOn: boolean) => {
                this.vm.useWallet = isOn;
              })
          }
        }.width(Constants.FULL_SIZE).padding(12)
        .justifyContent(FlexAlign.SpaceBetween)

      }.cardStyle()
    }.alignItems(HorizontalAlign.Start)

  }

  @Builder
  payIntroduceBuilder() {
    Column() {
      SheetHeaderComp({
        title: '停车支付说明',
        close: () => {
          this.vm.showPayIntroSheet = false;
        },
      })
      Column({ space: 16 }) {
        Column({ space: 8 }) {
          Text('‌会员优惠‌：').fontSize(16).fontWeight(500)
          Text('1、会员凭当日单张满100元的购物小票，兑换停车券一张可享受一次免费停车，当日有效。\n' +
            '2、多次消费满100元，则可多次享受该优惠。').fontSize(12)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        Column({ space: 8 }) {
          Text('‌非会员优惠‌：').fontSize(16).fontWeight(500)
          Text('1、商场停车场30分钟内免费。\n' +
            '2、30分钟之后开始计费，15分钟0.5元，不足15分钟按照5分钟计费，24小时内18元封顶。').fontSize(12)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .margin({ bottom: 24 })
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(16)
      .padding(12)
    }
    .padding({ left: 16, right: 16, bottom: this.vm.getWindowBottomHeight() })
    .backgroundColor($r('sys.color.background_secondary'))
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
