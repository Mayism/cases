import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { AppStorageV2 } from '@kit.ArkUI';
import { geoLocationManager } from '@kit.LocationKit';
import {
  alertToConfirm,
  AppInfoModel,
  CardManager,
  formatDateToMonthDay,
  formatTimeStrToDate,
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
} from 'common';
import { BookOrderData, BookOrderDetail, BookStoreParams, HttpCode, HttpRequest, OrderUtil } from 'network';
import { CHOOSE_NUM, CHOOSE_TIME } from '../constants/Constants';

@ObservedV2
export class BookVM {
  @Trace appInfoModel: AppInfoModel = AppStorageV2.connect(AppInfoModel, () => new AppInfoModel())!
  @Trace storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!
  // 搜索中
  @Trace searching: boolean = false;
  // 搜索门店文字
  @Trace query: string = '';
  // 门店列表
  @Trace storeList: StoreInfo[] = [];
  // 选中门店
  @Trace storeSelected: StoreInfo | undefined;
  // 筛选索引
  @Trace filterIndexes: [number, number, number] = [0, 0, 0];
  // 当前时间列表
  @Trace dates: Date[] = [];
  // 日期选择列表
  @Trace datesRange: string[] = [];
  // 时间选择列表
  @Trace timesRange: string[] = [];
  // 日期选择器选中索引
  @Trace tempDayIndex: number = 0;
  // 时间选择器选中索引
  @Trace tempTimeIndex: number = 0;
  // 选中时间字符串
  @Trace timeStr: string = '';
  // 就餐时间段
  @Trace period: number = 18;
  //就餐人数
  @Trace headCount: number = 0;
  // 是否预定包间
  @Trace isPrivateRoom: boolean = false;
  // 显示选择时间半模态
  @Trace showTime: boolean = false;
  // 显示选择人数半模态
  @Trace showCount: boolean = false;
  public countRange: string[] = CHOOSE_NUM.map(num => num + '人');
  // 人数选择器选中索引
  @Trace tempCountIndex: number = 0;
  public timeRes: TimePickerResult = { hour: 0, minute: 0, second: 0 };
  // 姓名
  @Trace name: string = '';
  // 电话
  @Trace phone: string = '';
  // 选中装饰类
  @Trace decoration: string = '';
  // 选中餐具类
  @Trace tableWares: string[] = [];
  // 备注
  @Trace tips: string = '';
  // 缓存输入的内容
  @Trace tipTemps: string = '';
  // 排号结果订单
  @Trace order: BookOrderDetail | undefined;
  // 添加日程
  @Trace orderSchedules: number[] = [];
  timeListController: ListScroller = new ListScroller()
  private myLocation?: geoLocationManager.Location
  private static _instance: BookVM;

  public static get instance() {
    if (!BookVM._instance) {
      BookVM._instance = new BookVM();
    }
    return BookVM._instance;
  }

  // 搜索门店列表
  @Computed
  public get searchStoreList() {
    if (!this.query.trim) {
      return this.storeList;
    }
    return this.storeList.filter(item => item.name.includes(this.query.trim()));
  }

  // 重置订座参数
  public resetBookParams() {
    this.query = '';
    this.filterIndexes = [2, 1, 18];
    this.period = this.filterIndexes[2];
    this.tempTimeIndex = this.filterIndexes[2];
    this.tempDayIndex = this.filterIndexes[1];
    this.tempCountIndex = this.filterIndexes[0];
    this.dates = this._getWeekFromToday();
    this.datesRange = this.dates.map((date, index) => formatDateToMonthDay(date, index === 0 ? 0 : undefined));
    this.timesRange = CHOOSE_TIME.map((date) => date.join('-'));
    const date = this.dates[this.filterIndexes[1]];
    this.timeStr = formatDateToMonthDay(date) + ' ' + CHOOSE_TIME[this.filterIndexes[2]].join('-');
    this.headCount = CHOOSE_NUM[this.filterIndexes[0]];
    this.isPrivateRoom = false;
  }

  // 重置订座订单参数
  public resetBookOrderParams() {
    this.name = '';
    this.phone = '';
    this.decoration = '';
    this.tableWares.length = 0;
    this.tips = '';
    this.tipTemps = '';
  }

  // 确定时间选择
  public confirmPickerTime() {
    const timeStrTemp = formatDateToMonthDay(this.dates[this.tempDayIndex]) + ' ' + CHOOSE_TIME[this.tempTimeIndex][0];
    const timeDateTemp = formatTimeStrToDate(timeStrTemp);
    if (timeDateTemp.getTime() < Date.now()) {
      promptAction.showToast({ message: '订座时间不能早于当前时间' });
      return;
    }
    this.timeStr =
      formatDateToMonthDay(this.dates[this.tempDayIndex]) + ' ' + CHOOSE_TIME[this.tempTimeIndex].join('-');
    this.period = this.tempTimeIndex;
    this.filterIndexes[1] = this.tempDayIndex
    this.filterIndexes[2] = this.period
    this.showTime = false;
  }

  // 获取订座门店
  public async getBookStoreList() {
    this.searching = true;
    const params: BookStoreParams = {
      period: this.period,
      max: this.headCount,
      isPrivate: this.isPrivateRoom,
    };
    const res = await HttpRequest.getBookStoreListApi(params);
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

  // 跳转订座预订
  public jumpToBookOrder(store: StoreInfo) {
    const lefts: number[] = this.isPrivateRoom ? store.privateRoom : store.diningHall;
    if (lefts[this.period] === 0) {
      return;
    }
    this.storeSelected = store;
    RouterModule.push(RouterMap.BOOK_ORDER_PAGE);
  }

  // 特殊需求选择
  public specialOpt(onlyOne: boolean, value: string) {
    if (onlyOne) {
      if (this.decoration === value) {
        this.decoration = '';
      } else {
        this.decoration = value;
      }
    } else {
      const index = this.tableWares.findIndex(item => item === value);
      if (index === -1) {
        this.tableWares.push(value);
      } else {
        this.tableWares.splice(index, 1);
      }
    }
  }

  // 创建订座订单
  public async createBookOrder() {
    if (this.name === '') {
      promptAction.showToast({ message: '姓名不能为空' });
      return;
    }
    const regex = /^1(3\d|4[5-9]|5[0-35-9]|6[2567]|7[0-8]|8\d|9[0-35-9])\d{8}$/;
    if (!regex.test(this.phone)) {
      promptAction.showToast({ message: '电话号码格式错误' });
      return;
    }
    FullLoading.show();
    const data: BookOrderData = {
      store: getStoreInfoRespMapper(this.storeSelected),
      time: this.timeStr,
      count: this.headCount,
      room: this.isPrivateRoom,
      name: this.name,
      phone: this.phone,
      decoration: this.decoration,
      tableWares: this.tableWares,
      tips: this.tips,
    };
    const res = await HttpRequest.createBookOrderApi(data);
    if (res.code === HttpCode.SUCCESS) {
      let order = OrderUtil.getBookOrderById(res.data.orderId);
      this.updateFormCard(order)
      RouterModule.replace(RouterMap.BOOK_RES_PAGE, res.data.orderId);
      FullLoading.hide();
    }
  }

  // 取消订座订单
  public async cancelBookOrder(orderId: number) {
    alertToConfirm('取消订座订单后将无法恢复，是否取消？', async () => {
      const res = await HttpRequest.cancelBookOrderApi(orderId);
      if (res.code === HttpCode.SUCCESS) {
        this.updateFormCard()
        RouterModule.pop();
      }
    })
  }

  updateFormCard(order?: BookOrderDetail | undefined) {
    let dataClass = new FormDataClass()
    dataClass.formDimension = 3
    if (order) {
      dataClass.storeName = order.store.name
      dataClass.orderState = true
      dataClass.orderId = order.orderId.toString()
      dataClass.stateType = 1
      dataClass.preorderRoom = order.room
      dataClass.preorderTime = order.time
      CardManager.get().updateCard(dataClass)
    } else {
      dataClass.storeName = this.storeModel.storeInfo.name
      CardManager.get().updateCard(dataClass)
    }
  }

  @Monitor('filterIndexes.0')
  private _countChange() {
    this.headCount = CHOOSE_NUM[this.filterIndexes[0]];
  }

  @Monitor('filterIndexes.1','filterIndexes.2')
  private _timeChange() {
    const date = this.dates[this.filterIndexes[1]];
    this.timeStr = formatDateToMonthDay(date) + ' ' + CHOOSE_TIME[this.filterIndexes[2]].join('-');
  }

  @Monitor('period','headCount','isPrivateRoom')
  private _conditionChange(monitor: IMonitor) {
    PermissionUtil.getLocation().then(res => {
      this.myLocation = res
    }).finally(() => {
      this.getBookStoreList();
    })
  }

  private _getWeekFromToday(): Date[] {
    const dates: Date[] = [];
    for (let i = 0; i < 7; i++) {
      const date = new Date();
      date.setDate(date.getDate() + i);
      dates.push(date);
    }
    return dates;
  }
}
