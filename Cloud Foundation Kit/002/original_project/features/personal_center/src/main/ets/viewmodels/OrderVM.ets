import Decimal from '@arkts.math.Decimal';
import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { AppStorageV2 } from '@kit.ArkUI';
import {
  alertToConfirm,
  AppInfoModel,
  CardManager,
  Constants,
  FormDataClass,
  FullLoading,
  RouterModule,
  StoreInfoModel,
} from 'common';
import { BookOrderDetail, HttpCode, HttpRequest, OrderUtil, QueueOrderDetail } from 'network';

@ObservedV2
export class OrderVM {
  @Trace appInfoModel: AppInfoModel = AppStorageV2.connect(AppInfoModel, () => new AppInfoModel())!
  @Trace storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!
  // 初次加载
  @Trace init: boolean = true;
  // 当前索引
  @Trace index: number = 0;
  // 订座订单列表
  @Trace bookList: BookOrderDetail[] = [];
  // 排号订单列表
  @Trace queueList: QueueOrderDetail[] = [];
  // 添加日程
  @Trace schedule: number[] = [];
  private static _instance: OrderVM;

  public static get instance() {
    if (!OrderVM._instance) {
      OrderVM._instance = new OrderVM();
    }
    return OrderVM._instance;
  }

  // 获取所有订单
  public async getAllOrders() {
    const res = await HttpRequest.getOrderListApi();
    if (res.code === HttpCode.SUCCESS) {
      this.bookList = [...res.data.book];
      this.bookList.forEach(order => {
        if (OrderUtil.checkHasSchedule(order.orderId)) {
          OrderVM._instance.schedule.push(order.orderId)
        }
      })
      this.queueList = res.data.queue.filter(order => order.wait >= 0);
      this.init = false;
    }
  }

  // 取消订座订单
  public async cancelBookOrder(orderId: number) {
    alertToConfirm('取消订座订单后将无法恢复，是否取消？', async () => {
      const res = await HttpRequest.cancelBookOrderApi(orderId);
      if (res.code === HttpCode.SUCCESS) {
        this.updateFormCard()
        const index = this.bookList.findIndex(order => order.orderId === orderId);
        if (index !== -1) {
          this.bookList.splice(index, 1);
        }
      }
    });
  }

  // 取消排号订单
  public async cancelQueueOrder(orderId: number) {
    alertToConfirm('取消排号订单后将无法恢复，是否取消？', async () => {
      const res = await HttpRequest.cancelQueueOrderApi(orderId);
      if (res.code === HttpCode.SUCCESS) {
        this.updateFormCard()
        const index = this.queueList.findIndex(order => order.orderId === orderId);
        if (index !== -1) {
          this.queueList.splice(index, 1);
        }
      }
    });
  }

  // 刷新排号订单
  public async refreshQueueOrder(orderId: number) {
    FullLoading.show();
    const res = await HttpRequest.refreshQueueOrderApi(orderId);
    FullLoading.hide();
    if (res.code === HttpCode.SUCCESS) {
      if (res.data === undefined) {
        promptAction.showToast({ message: '排号不存在' });
        RouterModule.pop();
      } else if (res.data.wait < 0) {
        promptAction.showToast({ message: '排号已过期' });
        this.updateFormCard()
        RouterModule.pop();
      } else {
        this.updateFormCard(res.data)
        this.getAllOrders();
      }
    }
  }

  updateFormCard(order?: QueueOrderDetail) {
    let dataClass = new FormDataClass()
    dataClass.formDimension = 3
    if (order) {
      dataClass.storeName = order.store.name
      dataClass.orderState = false
      dataClass.orderId = order.orderId.toString()
      dataClass.stateType = 2
      dataClass.queueWaitNum = order.wait
      dataClass.queueTable = this.getTableSize(order.count, order.mine)
      dataClass.queueWaitTime = new Decimal(order.mine).sub(order.now).mul(Constants.QUEUE_TABLE_MIN).toString()
      CardManager.get().updateCard(dataClass)
    } else {
      dataClass.storeName = this.storeModel.storeInfo.name
      CardManager.get().updateCard(dataClass)
    }
  }

  getTableSize(count: number, mine: number) {
    if (count < 3) {
      return `小桌${mine}号`
    } else if (count < 5) {
      return `中桌${mine}号`
    } else {
      return `大桌${mine}号`
    }
  }
}
