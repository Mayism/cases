import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { UtilLog } from '@hw-agconnect/util-log';
import { AppStorageV2 } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { paySheetBuilder } from 'base_ui';
import {
  AppInfoModel,
  Constants,
  copyString,
  DnState,
  MyCarModel,
  OrderTypeEnum,
  RouterMap,
  RouterModule,
  StoreInfoModel,
  TabBarType,
} from 'common/Index';
import * as API from '../api/Index';
import { BtnType, MyOrderInfo } from '../models/Index';
import { ButtonListComp } from './ButtonListComp';

const TAG = '[OrderTypeComp]'

@ComponentV2
export struct OrderTypeComp {
  @Param @Require orderDetail: MyOrderInfo
  @Local appInfoModel: AppInfoModel = AppStorageV2.connect(AppInfoModel, () => new AppInfoModel())!;
  @Local storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!;
  @Local myCarModel: MyCarModel = AppStorageV2.connect(MyCarModel, () => new MyCarModel())!
  @Local countdownMin: number = 0
  @Local countdownSec: number = 0
  @Local paySheetFlag: boolean = false
  timer: number = 0
  private waitPayBtnList: Array<BtnType> = [
    {
      text: $r('app.string.pay'),
      color: $r('sys.color.font_on_primary'),
      backgroundColor: $r('sys.color.multi_color_09'),
      callback: () => {
        this.paySheetFlag = true
      },
    },
    {
      text: $r('app.string.add_good'),
      color: $r('sys.color.font_secondary'),
      backgroundColor: $r('sys.color.background_secondary'),
      callback: () => {
        if (this.orderDetail.order.id) {
          API.addGoods(this.orderDetail.order.id).then(() => {
            API.getMyCar()
            RouterModule.popToName(RouterMap.MAIN_INDEX, TabBarType.ORDER)
          })
        } else {
          promptAction.showToast({ message: '订单不存在。' })
        }

      },
    },
    {
      text: $r('app.string.cancel'),
      color: $r('sys.color.font_secondary'),
      backgroundColor: $r('sys.color.background_secondary'),
      callback: (orderId: string) => {
        API.cancelOrder(orderId).then((resp: number) => {
          if (resp === 1) {
            promptAction.showToast({ message: '取消成功' })
            this.getOrderInfo()
          } else {
            promptAction.showToast({ message: '取消失败' })
          }
        })
      },
    },
  ]
  private finishedBtnList: Array<BtnType> = [
    {
      text: $r('app.string.one_more_order'),
      color: $r('sys.color.font_secondary'),
      backgroundColor: $r('sys.color.background_secondary'),
      callback: () => {
        RouterModule.popToName(RouterMap.MAIN_INDEX, TabBarType.ORDER)
      },
    },
  ]
  @Event getOrderInfo: () => void = () => {
  }

  aboutToDisappear(): void {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }

  confirmOrder() {
    // 拉华为支付
    API.getHuaweiPayInfo(this.orderDetail.order.id ?? '').then((resp: number) => {
      if (resp) {
        promptAction.showToast({ message: '支付成功' })
        this.getOrderInfo()
      } else {
        promptAction.showToast({ message: '支付失败' })
      }
    }).catch((e: BusinessError) => {
      UtilLog.error(TAG, `getHuaweiPayInfo error: ${JSON.stringify(e)}.`);
      promptAction.showToast({ message: `支付失败！错误码：${JSON.stringify(e)}` })
    })
  }

  @Monitor('orderDetail.order.state')
  dealSate() {
    if (this.orderDetail.order.state !== DnState.TO_BE_PAID) {
      return;
    }
    if (this.timer) {
      this.clearTimer()
    }
    let orderTime = new Date(this.orderDetail.order.time!)
    orderTime.setMinutes(orderTime.getMinutes() + 30)
    let countdownSec = Math.floor((orderTime.getTime() - new Date().getTime()) / 1000)
    this.countdownSec = countdownSec >= 0 ? countdownSec : 0
    this.countdownMin = Math.floor(this.countdownSec / 60)
    this.timer = setInterval(() => {
      if (this.countdownSec <= 0) {
        this.clearTimer()
        API.cancelOrder(this.orderDetail.order.id ?? '')
        this.getOrderInfo()
        return
      }
      this.countdownSec--
      if (this.countdownSec > 60) {
        this.countdownMin = Math.floor(this.countdownSec / 60)
      } else {
        this.countdownMin = 0
      }
    }, 1000)
  }

  clearTimer() {
    clearInterval(this.timer)
    this.countdownMin = 0
    this.countdownSec = 0
  }

  @Builder
  waitPayBuilder() {
    Column() {
      Text($r('app.string.to_be_paid'))
        .fontSize($r('sys.float.Title_S'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))
      Row() {
        Text() {
          Span($r('app.string.please')).fontColor($r('sys.color.font_secondary'))
          if (this.countdownMin) {
            Span($r('app.string.minute_params', `${this.countdownMin}`)).fontColor($r('sys.color.warning'))
          }
          Span($r('app.string.second_params', `${this.countdownSec % 60}`)).fontColor($r('sys.color.warning'))
          Span($r('app.string.timeout_cancel')).fontColor($r('sys.color.font_secondary'))
        }.fontSize($r('sys.float.Body_M'))
      }
      .padding({
        left: 4,
        right: 4,
        top: 12,
        bottom: 12,
      })

      ButtonListComp({ btnList: this.waitPayBtnList, orderId: this.orderDetail.order.id })
        .bindSheet($$this.paySheetFlag, paySheetBuilder(Number(this.orderDetail.order.money ?? 0), (flag: boolean) => {
          if (flag) {
            this.confirmOrder()
          }
          this.paySheetFlag = false
        }), {
          detents: [397, 398],
          backgroundColor: $r('sys.color.background_fourth'),
          title: { title: $r('app.string.select_pay_type') },
          blurStyle: BlurStyle.Thick,
          preferType: SheetType.CENTER,
        })
    }
    .width(Constants.FULL_SIZE)
  }

  @Builder
  finishedBuilder() {
    Column({ space: 12 }) {
      Text($r('app.string.order_completed'))
        .fontSize($r('sys.float.Title_S'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))
      if (this.storeModel.orderType === OrderTypeEnum.DINE_IN) {
        Row() {
          Image($r('app.media.table_icon')).width(16)
          Text(`${this.orderDetail.table?.typeName} ${this.orderDetail.table?.name}`)
            .fontColor($r('sys.color.font_secondary'))
            .fontSize($r('sys.float.Body_M'))
            .margin({ left: 2 })
        }
      } else {
        Text() {
          ImageSpan($r('app.media.ic_pick_num')).width(16)
          Span($r('app.string.pick_good_id')).fontColor($r('sys.color.font_secondary')).margin({ left: 2 })
          Span(`${this.orderDetail.order.oid}`).fontColor($r('sys.color.font_secondary')).margin({ left: 4 })
        }.fontSize($r('sys.float.Body_M'))
      }
      Text() {
        Span($r('app.string.order_id_prefix'))
        Span(`${this.orderDetail.order.orderNum}  `)
        ImageSpan($r('app.media.copy')).width(16).height(16)
          .onClick(() => {
            copyString(this.orderDetail.order.orderNum ?? '')
          })
      }
      .fontSize($r('sys.float.Caption_M'))
      .fontColor($r('sys.color.font_secondary'))
      .backgroundColor($r('sys.color.background_secondary'))
      .align(Alignment.Center)
      .padding({
        left: 12,
        right: 12,
        top: 4,
        bottom: 4,
      })

      ButtonListComp({ btnList: this.finishedBtnList })
    }
    .width(Constants.FULL_SIZE)
  }

  @Builder
  canceledBuilder() {
    Column() {
      Text($r('app.string.order_canceled'))
        .fontSize($r('sys.float.Title_S'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))
      Row() {
        Text($r('app.string.order_id_prefix'))
          .fontSize($r('sys.float.Caption_M'))
          .fontColor($r('sys.color.font_secondary'))
        Text(`${this.orderDetail.order.orderNum}  `)
          .fontSize($r('sys.float.Caption_M'))
          .fontColor($r('sys.color.font_secondary'))
        Image($r('app.media.copy')).width(12).height(12)
          .onClick(() => {
            copyString(this.orderDetail.order.orderNum ?? '')
          })
      }
      .align(Alignment.Center)
      .backgroundColor($r('sys.color.background_secondary'))
      .borderRadius(4)
      .padding({
        left: 12,
        right: 12,
        top: 4,
        bottom: 4,
      })
      .margin({ top: 28 })

      Text($r('app.string.use_close_order'))
        .fontSize($r('sys.float.Caption_L'))
        .fontColor($r('sys.color.font_secondary'))
        .margin({ top: 28 })
    }
    .width(Constants.FULL_SIZE)
  }

  build() {
    Column() {
      if (this.orderDetail.order.state === DnState.TO_BE_PAID) {
        this.waitPayBuilder()
      } else if (this.orderDetail.order.state === DnState.COMPLETED) {
        this.finishedBuilder()
      } else {
        this.canceledBuilder()
      }
    }
    .constraintSize({ maxWidth: Constants.FULL_SIZE })
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
    .padding({
      left: 12,
      right: 12,
      top: 16,
      bottom: 16,
    })
  }
}