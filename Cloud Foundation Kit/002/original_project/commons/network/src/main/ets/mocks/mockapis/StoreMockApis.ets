import AxiosMockAdapter from '@hw-agconnect/axios-mock-adapter';
import { AxiosRequestConfig, HttpStatusCode } from '@ohos/axios';
import { RequestUrl, WEEK_DAYS } from '../../constants/Index';
import {
  BookOrderDetail,
  CouponItem,
  DishesTypeResp,
  GoodsResp,
  GoodsSpecResp,
  MyCarResp,
  QueueOrderDetail,
} from '../../types/Order';
import {
  AddCarReq,
  BookOrderData,
  BookStoreParams,
  CancelBookOrderDate,
  CancelQueueOrderDate,
  QueueOrderData,
  QueueStoreParams,
  RefreshQueueOrderParams,
} from '../../types/Request';
import { BaseResponse } from '../../types/Response';
import { AppInfoResp, StoreInfoResp, TableInfoResp } from '../../types/Store';
import { HelpMsgResp } from '../../types/User';
import { OrderUtil } from '../../utils/OrderUtil';
import {
  addCar,
  addGoods,
  cleanCar,
  getCouponsResp,
  getDishesList,
  getGoodsInfoResp,
  getGoodsSpecInfo,
  getIsNew,
  getLqCoupons,
  getMyCar,
  getMyCoupons,
  getSnackSizedDeal,
  getUpdCar,
} from '../MockData/Order';
import { getAppInfoResp, getStoreInfoResp, getStoreList, getTableInfoResp } from '../MockData/Store';
import { getHelp } from '../MockData/User';

export class StoreMockApis {
  public start(adapter: AxiosMockAdapter) {
    adapter.onGet(RequestUrl.GET_APP_INFO_URL).reply((config: AxiosRequestConfig) => {
      let list = getAppInfoResp();
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: list } as BaseResponse<AppInfoResp>,
      };
    });
    adapter.onGet(RequestUrl.GET_TABLE_LIST_URL).reply(async (config: AxiosRequestConfig) => {
      let list = getTableInfoResp();
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: list } as BaseResponse<Array<TableInfoResp>>,
      };
    });
    adapter.onGet(RequestUrl.GET_STORE_LIST_URL).reply(async (config: AxiosRequestConfig) => {
      let list = getStoreList();
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: list } as BaseResponse<Array<StoreInfoResp>>,
      };
    });
    adapter.onGet(RequestUrl.GET_STORE_INFO_URL).reply(async (config: AxiosRequestConfig) => {
      const storeId: string = config.params?.storeId
      let data = getStoreInfoResp(storeId);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<StoreInfoResp>,
      };
    });
    adapter.onGet(RequestUrl.GET_DISHES_LIST_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getDishesList();
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<Array<DishesTypeResp>>,
      };
    });

    adapter.onGet(RequestUrl.GET_GOOD_INFO_URL).reply(async (config: AxiosRequestConfig) => {
      const goodsId: string = config.params?.goodsId
      let data = getGoodsInfoResp(goodsId);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<GoodsResp>,
      };
    });
    adapter.onGet(RequestUrl.GET_GOOD_SPEC_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getGoodsSpecInfo(config.params);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<GoodsSpecResp>,
      };
    });
    adapter.onGet(RequestUrl.GET_ADD_CAR_URL).reply(async (config: AxiosRequestConfig) => {
      let data = addCar(config.params as AddCarReq);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<number>,
      };
    });

    adapter.onGet(RequestUrl.GET_MY_CAR_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getMyCar();
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<MyCarResp>,
      };
    });

    adapter.onGet(RequestUrl.GET_DEL_CAR_URL).reply(async (config: AxiosRequestConfig) => {
      let data = cleanCar();
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<number>,
      };
    });

    adapter.onGet(RequestUrl.GET_UPD_CAR_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getUpdCar(config.params);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<number>,
      };
    });

    adapter.onGet(RequestUrl.GET_HELP_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getHelp();
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<Array<HelpMsgResp>>,
      };
    });
    adapter.onGet(RequestUrl.GET_COUPONS_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getCouponsResp();
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<Array<CouponItem>>,
      };
    });
    adapter.onGet(RequestUrl.GET_LQ_COUPONS_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getLqCoupons(config.params);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<number>,
      };
    });

    adapter.onGet(RequestUrl.GET_MY_COUPONS_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getMyCoupons();
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<CouponItem[]>,
      };
    });
    adapter.onGet(RequestUrl.GET_IS_NEW_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getIsNew();
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<number>,
      };
    });

    adapter.onPost(RequestUrl.GET_ADD_GOODS_URL).reply(async (config: AxiosRequestConfig) => {
      let data = addGoods(config.params);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<number>,
      };
    });

    adapter.onGet(RequestUrl.GET_SNACK_SIZED_DEAL).reply(async (config: AxiosRequestConfig) => {
      let data = getSnackSizedDeal(config.params);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<Array<GoodsResp>>,
      };
    });

    // 订座门店列表获取
    adapter.onGet(RequestUrl.URL_STORE_BOOK_LIST).reply(async (config: AxiosRequestConfig) => {
      const params = config.params as BookStoreParams;
      let list = getStoreList().filter(store => store.maxCount >= params.max);
      if (params.isPrivate) {
        list = list.filter(store => store.privateRoom[params.period]);
      } else {
        list = list.filter(store => store.diningHall[params.period]);
      }
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: list } as BaseResponse<StoreInfoResp[]>,
      };
    });

    // 排号门店列表获取
    adapter.onGet(RequestUrl.URL_STORE_QUEUE_LIST).reply(async (config: AxiosRequestConfig) => {
      const params = config.params as QueueStoreParams;
      let list = getStoreList().filter(store => store.maxCount >= params.max);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: list } as BaseResponse<StoreInfoResp[]>,
      };
    });

    // 创建订座订单
    adapter.onPost(RequestUrl.URL_ORDER_BOOK_CREATE).reply(async (config: AxiosRequestConfig) => {
      const data = JSON.parse(config.data) as BookOrderData;
      const orderNew: BookOrderDetail = {
        orderId: Date.now(),
        store: data.store,
        time: data.time,
        count: data.count,
        room: data.room,
        name: data.name,
        phone: data.phone,
        decoration: data.decoration ?? '',
        tableWares: data.tableWares ?? [],
        tips: data.tips ?? '',
      };
      OrderUtil.addBookOrder(orderNew);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: orderNew } as BaseResponse<BookOrderDetail>,
      };
    });

    // 取消订座订单
    adapter.onPost(RequestUrl.URL_ORDER_BOOK_CANCEL).reply(async (config: AxiosRequestConfig) => {
      const data = JSON.parse(config.data) as CancelBookOrderDate;
      OrderUtil.delBookOrder(data.orderId);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '' } as BaseResponse<void>,
      };
    });

    // 创建排号订单
    adapter.onPost(RequestUrl.URL_ORDER_QUEUE_CREATE).reply(async (config: AxiosRequestConfig) => {
      const data = JSON.parse(config.data) as QueueOrderData;
      const today = new Date();
      const month = today.getMonth() + 1;
      const day = today.getDate();
      const time = `${month}月${day}日` + ' ' + WEEK_DAYS[today.getDay()] + '(今天)';;
      const orderNew: QueueOrderDetail = {
        orderId: Date.now(),
        store: data.store,
        time: time,
        count: data.count,
        mine: data.store.queueInfo.used,
        now: data.store.queueInfo.now,
        wait: data.store.queueInfo.used - data.store.queueInfo.now,
      };
      OrderUtil.addQueueOrder(orderNew);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: orderNew } as BaseResponse<QueueOrderDetail>,
      };
    });

    // 取消排号订单
    adapter.onPost(RequestUrl.URL_ORDER_QUEUE_CANCEL).reply(async (config: AxiosRequestConfig) => {
      const data = JSON.parse(config.data) as CancelQueueOrderDate;
      OrderUtil.delQueueOrder(data.orderId);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '' } as BaseResponse<void>,
      };
    });

    // 刷新排号订单
    adapter.onGet(RequestUrl.URL_ORDER_QUEUE_REFRESH).reply(async (config: AxiosRequestConfig) => {
      const params = config.params as RefreshQueueOrderParams;
      const res = await OrderUtil.refreshQueueOrder(params.orderId);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: res } as BaseResponse<QueueOrderDetail | undefined>,
      };
    });

  }
}