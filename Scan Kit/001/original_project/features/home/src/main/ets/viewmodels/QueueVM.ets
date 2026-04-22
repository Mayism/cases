import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { Decimal } from '@kit.ArkTS';
import { AppStorageV2 } from '@kit.ArkUI';
import { geoLocationManager } from '@kit.LocationKit';
import Want from '@ohos.app.ability.Want';
import {
  alertToConfirm,
  AppInfoModel,
  CardManager,
  Constants,
  Dialog,
  formatDateToMonthDay,
  FormDataClass,
  FullLoading,
  getDistanceWithLocation,
  getStoreInfoMapper,
  getStoreInfoRespMapper,
  PermissionUtil,
  RouterMap,
  RouterModule,
  StoreInfo,
  StoreInfoModel,
  StoreQueueInfo,
  WindowUtil,
} from 'common';
import { HttpCode, HttpRequest, OrderUtil, QueueOrderData, QueueOrderDetail } from 'network';
import { CHOOSE_NUM, WEEK_DAYS } from '../constants/Constants';

@ObservedV2
export class QueueVM {
  @Trace appInfoModel: AppInfoModel = AppStorageV2.connect(AppInfoModel, () => new AppInfoModel())!
  @Trace storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!
  // 搜索中
  @Trace searching: boolean = false;
  // 搜索门店文字
  @Trace query: string = '';
  // 门店列表
  @Trace storeList: StoreInfo[] = [];
  // 当前时间字符串
  @Trace timeStr: string = '';
  // 当前时间日期对象
  @Trace timeDate: Date = new Date();
  // 订单排号时间
  @Trace orderTimeStr: string = '';
  // 选中门店
  @Trace storeSelected: StoreInfo | undefined;
  // 就餐人数
  @Trace headCount: number = 0;
  // 显示选择人数半模态
  @Trace showCount: boolean = false;
  public countRange: string[] = CHOOSE_NUM.map(num => num + '人');
  // 人数选择器选中索引
  @Trace tempCountIndex: number = 0;
  // 店铺排号信息
  @Trace storeQueueInfo: StoreQueueInfo | undefined;
  @Trace deskInfo: string = '';
  // 排号结果订单
  @Trace order: QueueOrderDetail | undefined;
  myLocation?: geoLocationManager.Location
  private static _instance: QueueVM;

  public static get instance() {
    if (!QueueVM._instance) {
      QueueVM._instance = new QueueVM();
    }
    return QueueVM._instance;
  }

  // 搜索门店列表
  @Computed
  public get searchStoreList() {
    if (!this.query.trim()) {
      return this.storeList;
    }
    return this.storeList.filter(item => item.name.includes(this.query.trim()));
  }

  // 座位类型
  @Computed
  public get type() {
    if (this.headCount <= 2) {
      return '小桌';
    } else if (this.headCount <= 4) {
      return '中桌';
    } else {
      return '大桌';
    }
  }

  // 重置排号参数
  public resetQueueParams() {
    this.query = '';
    this.timeDate = new Date();
    this.timeStr = formatDateToMonthDay(new Date()) + ' ' + WEEK_DAYS[this.timeDate.getDay()] + '(今天)';
    this.tempCountIndex = 2;
    this.headCount = CHOOSE_NUM[this.tempCountIndex];
  }

  // 重置排号订单参数
  public resetQueueOrderParams() {
    const now = new Date();
    this.orderTimeStr = formatDateToMonthDay(now) + ' ' + WEEK_DAYS[this.timeDate.getDay()] + '(今天)';
    this.storeQueueInfo = undefined;
  }

  // 获取排号门店
  public async getQueueStoreList() {
    this.searching = true;
    const res = await HttpRequest.getQueueStoreListApi(this.headCount);
    if (res.code === HttpCode.SUCCESS) {
      this.storeList = res.data.map((item): StoreInfo => {
        let store = getStoreInfoMapper(item);
        if (this.myLocation) {
          store.distance = getDistanceWithLocation(this.myLocation, item.coordinates || '');
        }
        return store
      })
      this.searching = false;
    }
  }

  // 获取排号门店叫号信息
  public getQueueStoreInfo() {
    this.storeQueueInfo = this.storeSelected?.queueInfo;
    if (!this.storeQueueInfo) {
      return;
    }
    this.deskInfo =
      '小桌-' + this.storeQueueInfo.min + '; 中桌-' + this.storeQueueInfo.mid + '; 大桌-' + this.storeQueueInfo.max;
  }

  // 跳转排号预订
  public jumpToQueueOrder(store: StoreInfo) {
    if (!store.needQueue) {
      Dialog.open();
      return;
    }
    if (OrderUtil.checkHasQueue(Number(store.id))) {
      promptAction.showToast({ message: '当前门店已存在排号订单' });
      return;
    }
    this.storeSelected = store;
    RouterModule.push(RouterMap.QUEUE_ORDER_PAGE);
  }

  // 创建排号订单
  public async createQueueOrder() {
    FullLoading.show();
    const data: QueueOrderData = {
      store: getStoreInfoRespMapper(this.storeSelected!),
      count: this.headCount,
    };
    const res = await HttpRequest.createQueueOrderApi(data);
    if (res.code === HttpCode.SUCCESS) {
      let order = OrderUtil.getQueueOrderById(res.data.orderId);
      this.updateFormCard(order)
      RouterModule.replace(RouterMap.QUEUE_RES_PAGE, res.data.orderId);
      FullLoading.hide();
    }
  }

  // 取消排号订单
  public async cancelQueueOrder(orderId: number) {
    alertToConfirm('取消排号订单后将无法恢复，是否取消？', async () => {
      const res = await HttpRequest.cancelQueueOrderApi(orderId);
      if (res.code === HttpCode.SUCCESS) {
        this.updateFormCard()
        RouterModule.pop();
      }
    });
  }

  // 刷新排号订单
  public async refreshQueueOrder() {
    FullLoading.show();
    const res = await HttpRequest.refreshQueueOrderApi(this.order!.orderId);
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
        this.order = res.data;
        this.updateFormCard(this.order)
      }
    }
  }

  public goPetalMap(store: StoreInfo) {
    let coordinates = store.coordinates?.split(',')
    if (coordinates?.length === 2) {
      let latitude: number = Number(coordinates[0])
      let longitude: number = Number(coordinates[1])
      let petalMapWant: Want = {
        bundleName: 'com.huawei.hmos.maps.app',
        uri: 'maps://routes',
        parameters: {
          linkSource: this.appInfoModel.packageName,
          destinationLatitude: latitude,
          destinationLongitude: longitude,
          destinationPoiId: '',
          destinationName: store.address ?? '',
        },
      }
      let context = WindowUtil.globalUIAbilityContext;
      context.startAbility(petalMapWant);
    } else {
      promptAction.showToast({ message: '商户地址错误！' })
    }
  }

  updateFormCard(order?: QueueOrderDetail) {
    let dataClass = new FormDataClass()
    dataClass.formDimension = 3
    if (order) {
      dataClass.storeName = order.store.name
      dataClass.orderState = true
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

  @Monitor('timeDate','headCount')
  private _conditionChange() {
    PermissionUtil.getLocation().then(res => {
      this.myLocation = res
    }).finally(() => {
      this.getQueueStoreList();
    })
  }
}
