import { CardInfo, ConsumeType, MockService, OrderInfo, OrderState, OrderType } from 'external_interactions';
import { RechargeRouteParam } from 'module_recharge';
import { TitleBar } from 'module_recharge/src/main/ets/components/TitleBar';
import { ScreenPropStorage , AccountUpdate} from 'external_interactions'
import { AppStorageV2 } from '@kit.ArkUI';
import { CashierComponent } from 'payment';

@ComponentV2
export struct BuyCard {
  @Local screenPropStorage : ScreenPropStorage = AppStorageV2.connect(ScreenPropStorage, 'ScreenPropStorage', () =>new ScreenPropStorage())!
  @Local accountUpdateStorage : AccountUpdate = AppStorageV2.connect(AccountUpdate, 'AccountUpdate', () =>new AccountUpdate())!
  @Local topRectHeight: number = this.screenPropStorage.topRectHeight;
  @Local bottomRectHeight: number = this.screenPropStorage.bottomRectHeight;
  @Local accountUpdate: boolean = this.accountUpdateStorage.accountUpdate;
  @Param @Once pathStack: NavPathStack = new NavPathStack();
  @Param @Once cardInfo: CardInfo | undefined = undefined;
  @Local balance: number = MockService.account.balance;
  @Local showFailed: boolean = false
  @Local commit: boolean = false
  @Local payByQuota: boolean = false

  aboutToAppear(): void {
    this.getUIContext().getHostContext()?.eventHub.on('confirmPay', (confirm: boolean) => {
      this.commit = confirm
      if(this.cardInfo){
        if (!this.payByQuota) {
          let orderInfo: OrderInfo =
            MockService.createOrder(OrderType.CARD, OrderState.COMPLETED, 1, this.cardInfo.price,
              this.cardInfo.id, this.cardInfo.avaiCourse)
          if (this.cardInfo.id.length === 0) {
            orderInfo.bookingId = this.cardInfo.avaiCourse
            orderInfo.orderType = OrderType.COURSE
          }
          this.pathStack.clear(false)
          MockService.addUserCard(this.cardInfo.id, this.cardInfo.quota)
          this.pathStack.pushPath({ name: 'card/orderDetail', param: orderInfo }, false)
          if (this.cardInfo.id.length === 0) {
            AppStorage.setOrCreate<boolean>(this.cardInfo.avaiCourse, true)
          }
        } else if (this.balance >= this.cardInfo.price) {
          // 会员卡余额充足，生成已完成订单，跳转订单详情页
          let orderInfo: OrderInfo =
            MockService.createOrder(OrderType.CARD, OrderState.COMPLETED, 1, this.cardInfo.price,
              this.cardInfo.id, this.cardInfo.avaiCourse)
          if (this.cardInfo.id.length === 0) {
            orderInfo.bookingId = this.cardInfo.avaiCourse
            orderInfo.orderType = OrderType.COURSE
          }
          MockService.account.balance -= this.cardInfo.price;
          MockService.dataPreferences.putSync('account', JSON.stringify(MockService.account))
          MockService.dataPreferences.flush()
          this.pathStack.clear(false)
          MockService.addUserCard(this.cardInfo.id, this.cardInfo.quota)
          this.pathStack.pushPath({ name: 'card/orderDetail', param: orderInfo }, false)
          this.accountUpdate = !this.accountUpdate
          if (this.cardInfo.id.length === 0) {
            AppStorage.setOrCreate<boolean>(this.cardInfo.avaiCourse, true)
          }
        } else {
          // 会员卡余额不足，提示充值，生成未完成订单
          this.showFailed = true
          MockService.createOrder(OrderType.CARD, OrderState.TO_BE_PAY, 1, this.cardInfo.price,
            this.cardInfo.id, this.cardInfo.avaiCourse)
        }
      }
    })

    this.getUIContext().getHostContext()?.eventHub.on('paymentType', (paymentType: string) => {
      if (paymentType === '3') {
        this.payByQuota = true
      } else {
        this.payByQuota = false
      }
    })
  }

  aboutToDisappear(): void {
    this.getUIContext().getHostContext()?.eventHub.off('confirmPay')
    this.getUIContext().getHostContext()?.eventHub.off('paymentType')
  }

  @Builder
  cardShowBuilder() {
    Column() {
      if(this.cardInfo){
        Row() {
          Image($r(this.cardInfo.advImage))
            .width(80)
            .height(80)
            .borderRadius(8)
          Column() {
            Row() {
              Text(this.cardInfo.name)
                .textAlign(TextAlign.Start)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
              Text('¥' + this.cardInfo.price)
                .fontSize(14)
                .opacity(0.4)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            Row() {
              if (this.cardInfo.id.length === 0) {
                Text('')
              } else {
                Text(this.cardInfo.consumeType === ConsumeType.TIMES ? this.cardInfo.quota + '次' :
                  MockService.getQuotaDurationDesc(this.cardInfo.quota) + '卡')
                  .textAlign(TextAlign.Start)
                  .fontSize(14)
              }
              Text('x1')
                .fontSize(14)
                .opacity(0.4)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.SpaceEvenly)
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 16 })
          .height('100%')
        }.height(80)

        Divider()
          .margin({ top: 16, bottom: 16 })

        Row() {
          Text('合计：¥' + this.cardInfo.price)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .justifyContent(FlexAlign.End)
      }
    }
    .width('100%')
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .padding(16)
  }

  @Builder
  orderMoneyBuilder() {
    Column() {
      Text('订单金额')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 16 })
      Row() {
        Text('会员卡（剩余¥' + this.balance + '）')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
        if(this.cardInfo){
          Text('-' + this.cardInfo.price)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .opacity(0.6)
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .padding(16)
  }

  @Builder
  moneyNotEnoughMessage() {
    Column() {
      Image($r('app.media.money_not_enough'))
        .width(144)
        .height(144)
        .margin({ bottom: 30 })
      Text('会员卡余额不足，请前往会员卡充值界面充值！')
        .width('100%')
        .fontSize(14)
        .textAlign(TextAlign.Center)
        .opacity(0.4)
    }
    .width('100%')
    .margin({ top: 14 })
    .visibility(this.showFailed ? Visibility.Visible : Visibility.None)
  }

  @Builder
  cashierBuilder() {
    Column() {
      CashierComponent({ mercShortName: this.cardInfo?.name, paymentAmount: this.cardInfo?.price.toString() });
    }
  }

  build() {
    NavDestination() {
      Column() {
        TitleBar({ title: '提交订单',  onBackClick:()=>{this.pathStack.pop()} })
          .margin({ left: 16, right: 16 })
        Scroll() {
          Column({ space: 16 }) {
            // 展示卡项
            this.cardShowBuilder()
            // 订单金额
            this.orderMoneyBuilder()
            // 金额不足提示
            this.moneyNotEnoughMessage()

          }.margin({ left: 16, right: 16 })
          .justifyContent(FlexAlign.Start)
        }
        .scrollBar(BarState.Off)
        .width('100%')

        Row() {
          Row() {
            if(this.cardInfo){
              Text('需支付：' + this.cardInfo.price + '元')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
            }
          }
          .justifyContent(FlexAlign.Start)
          .width('40%')
          .height('60%')

          Button(this.showFailed ? '前往充值' : '提交订单', { type: ButtonType.Capsule, stateEffect: true })
            .width('50%')
            .height('60%')
            .fontColor($r('sys.color.comp_background_list_card'))
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Body_M'))
            .backgroundColor('#FF9019')
            .onClick(() => {
              if (this.showFailed) {
                // 跳转充值页
                this.pathStack.clear(false)
                this.pathStack.pushPath({ name: 'card/order' }, false)
                this.pathStack.pushPath({ name: 'vip/VipRecharge',
                  param: {
                    balance: MockService.account.balance,
                    handleBack:(balance: number)=>{
                      this.balance = balance;
                      MockService.account.balance = balance;
                      MockService.dataPreferences.putSync('account', JSON.stringify(MockService.account));
                      MockService.dataPreferences.flush()
                    }
                  } as RechargeRouteParam
                }, false)
                AppStorage.setOrCreate('stackAnimated', false)
              } else {
                this.commit = true
              }
            })
            .bindSheet($$this.commit, this.cashierBuilder(), {
              title: () => {},
              height: SheetSize.FIT_CONTENT,
              showClose: true,
              enableOutsideInteractive: false,
              backgroundColor: '#E5FFFFFF',
              blurStyle: BlurStyle.COMPONENT_THICK,
              onWillDismiss: ((action: DismissSheetAction) => {
                // exit event listener
                this.commit = false
              }),
            })
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .height(75)
        .width('100%')
        .padding({ bottom: 10 })
        .backgroundColor(Color.White)
        .position({ bottom: 0 })
      }
      .height('100%')
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx?.pathStack
      this.cardInfo = ctx?.pathInfo?.param as CardInfo;
    })
    .backgroundColor($r('app.color.main_background_color'))
    .padding({ top: this.getUIContext().px2vp(this.topRectHeight) })

  }
}
