import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { UtilLog } from '@hw-agconnect/util-log';
import { AppStorageV2 } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import dataPreferences from '@ohos.data.preferences';
import { GoodsComp } from 'base_ui';
import {
  CardManager,
  formatDateForForm,
  FormDataClass,
  NavHeaderBar,
  OrderDetailRouter,
  OrderTypeEnum,
  RouterMap,
  RouterModule,
  WindowModel,
} from 'common/Index';
import { MyOrderResp } from 'network';
import * as API from '../api/Index';
import { OrderTypeComp } from '../components/OrderTypeComp';
import { PaymentDetailsComp } from '../components/PaymentDetailsComp';
import { ReductionCard } from '../components/ReductionCardComp';
import { StoreInfoCard } from '../components/StoreInfoCardComp';
import { orderGoodsMapper, orderInfoMapper } from '../mapper/Index';
import { MyOrderInfo } from '../models/Index';

const TAG = '[OrderDetailPage]'

@Builder
export function OrderDetailPageBuilder() {
  OrderDetailPage()
}

@ComponentV2
struct OrderDetailPage {
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!
  @Local orderId: string = ''
  @Local isOrderJump: boolean = false
  @Local orderDetailInfo: MyOrderInfo = new MyOrderInfo()
  scroller: Scroller = new Scroller();

  getRouteParams() {
    let params = RouterModule.getNavParam<OrderDetailRouter>(RouterMap.ORDER_DETAIL_PAGE)
    if (params) {
      this.orderId = params.orderId
      this.isOrderJump = params.isOrderJump
    }
  }

  aboutToAppear() {
    this.getRouteParams()
    this.getOrderInfo()
  }

  getOrderInfo() {
    API.getOrderInfo(this.orderId).then((resp: MyOrderResp) => {
      if (resp) {
        UtilLog.info(TAG, `getOrderInfo resp:${JSON.stringify(resp)}.`);
        this.orderDetailInfo = orderInfoMapper(resp)
        if (this.isOrderJump) {
          this.updateFormCard()
        }
      } else {
        UtilLog.error(TAG, `getOrderInfo error: ${JSON.stringify(resp)}.`);
        promptAction.showToast({ message: '订单不存在。' })
        RouterModule.popToName(RouterMap.MAIN_INDEX, 0)
      }
    }).catch((e: BusinessError) => {
      UtilLog.error(TAG, `getOrderInfo error: ${JSON.stringify(e)}.`);
      promptAction.showToast({ message: '订单不存在。' })
      RouterModule.popToName(RouterMap.MAIN_INDEX, 0)
    })
  }

  updateFormCard() {
    try {
      dataPreferences.removePreferencesFromCacheSync(this.getUIContext().getHostContext(),
        { name: CardManager.KEY_CARD_ID })
    } catch (e) {
      UtilLog.error(TAG, `removePreferencesFromCacheSync error: ${JSON.stringify(e)}.`);
    }
    let dataClass = new FormDataClass()
    dataClass.storeName = this.orderDetailInfo.order.storeName || ''
    dataClass.orderType = this.orderDetailInfo.order.orderType
    dataClass.stateType = 3
    dataClass.orderState = true
    dataClass.orderId = this.orderId
    dataClass.storeTable =
      this.orderDetailInfo.order.orderType === OrderTypeEnum.DINE_IN ?
        `${this.orderDetailInfo?.table?.typeName} | ${this.orderDetailInfo?.table?.name}` : ''
    dataClass.orderPickNum =
      this.orderDetailInfo.order.orderType === OrderTypeEnum.TAKEOUT ? `${this.orderDetailInfo?.order?.oid}` : ''
    dataClass.orderTime = formatDateForForm(new Date(this.orderDetailInfo.order.time))
    CardManager.get().updateCard(dataClass)
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: $r('app.string.order_detail'), hasBackButton: true })
      Scroll(this.scroller) {
        Column({ space: 12 }) {
          OrderTypeComp({
            orderDetail: this.orderDetailInfo,
            getOrderInfo: () => {
              this.getOrderInfo()
            },
          })
          StoreInfoCard({ orderDetail: this.orderDetailInfo })
          GoodsComp({ goodsList: orderGoodsMapper(this.orderDetailInfo.goods) })
          ReductionCard({ orderInfo: this.orderDetailInfo?.order })
          PaymentDetailsComp({ orderDetail: this.orderDetailInfo }).margin({ top: 8 })
        }.margin({ left: 12, right: 12, top: 12 })
      }
      .layoutWeight(1)
      .padding({ bottom: this.windowModel.getWindowBottomHeight() })
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
    }
    .hideTitleBar(true)
    .backgroundColor('#FFF1F3F5')
  }
}

