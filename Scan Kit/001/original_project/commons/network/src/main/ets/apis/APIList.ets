import { UtilLog } from '@hw-agconnect/util-log';
import { AxiosRequestHeaders } from '@ohos/axios';
import { RequestUrl } from '../constants/Index';
import '../mocks/MockAdapter.ets';
import {
  BookOrderDetail,
  CouponItem,
  DishesTypeResp,
  GoodsResp,
  GoodsSpecResp,
  MyCarResp,
  MyOrderResp,
  OrderLists,
  PackageSpecResp,
  QueueOrderDetail,
} from '../types/Order';
import {
  AddCarReq,
  AddDnOrderReq,
  BookOrderData,
  BookStoreParams,
  CancelBookOrderDate,
  CancelQueueOrderDate,
  CommonReq,
  MyOrderReq,
  QueueOrderData,
  QueueStoreParams,
  RefreshQueueOrderParams,
} from '../types/Request';
import { BaseResponse } from '../types/Response';
import { AppInfoResp, StoreInfoResp, TableInfoResp } from '../types/Store';
import { HelpMsgResp, PointRecord, RechargeRecord, UserInfoResp } from '../types/User';
import AxiosRequest from './AxiosHttpRequest';

const TAG = '[APIList]'

// 获取应用基础信息
export const getAppInfo = () => {
  return AxiosRequest.get<BaseResponse<AppInfoResp>>({
    url: RequestUrl.GET_APP_INFO_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
  })
};

// 获取店铺餐桌信息
export const getTableList = () => {
  return AxiosRequest.get<BaseResponse<Array<TableInfoResp>>>({
    url: RequestUrl.GET_TABLE_LIST_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
  })
};

// 查询店铺列表
export const getStoreList = () => {
  return AxiosRequest.get<BaseResponse<Array<StoreInfoResp>>>({
    url: RequestUrl.GET_STORE_LIST_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
  })
};

export function getUserInfo(storeId?: string, unionId?: string, isRelative?: boolean) {
  let params = {
    storeId,
    unionId,
    isRelative,
  } as CommonReq
  return AxiosRequest.get<BaseResponse<UserInfoResp>>({
    url: RequestUrl.GET_LOGIN_HM_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export async function getOpenLoginHm(code: string = '') {
  return AxiosRequest.get<BaseResponse<UserInfoResp>>({
    url: RequestUrl.GET_OPEN_LOGIN_HM_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
  })
}

export async function getCloseLoginHm() {
  return AxiosRequest.get<BaseResponse<UserInfoResp>>({
    url: RequestUrl.GET_CLOSE_LOGIN_HM_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
  })
}

export function getStoreInfo(storeId: string) {
  let params = {
    storeId: storeId,
  } as CommonReq
  return AxiosRequest.get<BaseResponse<StoreInfoResp>>({
    url: RequestUrl.GET_STORE_INFO_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

/**
 * 通过storeId接口获取商品信息
 * @param storeId
 * @returns
 */
export function getDishesList(storeId: string) {
  let params = {
    storeId: storeId,
  } as CommonReq
  return AxiosRequest.get<BaseResponse<Array<DishesTypeResp>>>({
    url: RequestUrl.GET_DISHES_LIST_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

/**
 * 获取商品信息
 * @param goodId
 * @returns
 */
export function getGoodInfo(goodId: string) {
  let params = {
    goodsId: goodId,
  } as CommonReq
  return AxiosRequest.get<BaseResponse<GoodsResp>>({
    url: RequestUrl.GET_GOOD_INFO_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

/**
 * 获取单个商品规格信息
 * @returns
 */
export function getGoodSpec(goodId: string, combination: PackageSpecResp[]) {
  let params = {
    goodsId: goodId,
    spec: combination.map(item => item.specName).join(','),
    combination: combination,
  } as CommonReq
  return AxiosRequest.get<BaseResponse<GoodsSpecResp>>({
    url: RequestUrl.GET_GOOD_SPEC_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

/**
 * 规格菜品到购物车
 * @returns
 */
export function addCarBySpec(goodId: string, n: GoodsSpecResp, num: number) {
  let params: AddCarReq = {
    money: n.money ?? 0,
    goodsId: goodId,
    num: num,
    specType: n.specType ?? 2,
    spec: n.spec ?? '',
    combination: n.combination ?? [], //规格
    boxMoney: n.boxMoney,
  }
  return AxiosRequest.get<BaseResponse<number>>({
    url: RequestUrl.GET_ADD_CAR_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

/**
 * 添加菜品到购物车
 * @param good
 * @param num
 * @returns
 */
export function addCar(good: GoodsResp, num: number) {
  let params: AddCarReq = {
    money: good.money,
    goodsId: good.id,
    num: num,
    specType: good.specType,
    spec: '',
    combination: [], //规格ID
    boxMoney: good.boxMoney,
  }
  return AxiosRequest.get<BaseResponse<number>>({
    url: RequestUrl.GET_ADD_CAR_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function getMyCar() {
  return AxiosRequest.get<BaseResponse<MyCarResp>>({
    url: RequestUrl.GET_MY_CAR_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
  })
}

export function clearMyCar() {
  return AxiosRequest.get<BaseResponse<number>>({
    url: RequestUrl.GET_DEL_CAR_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
  })
}

/**
 * 更新已经添加到购物车的菜品数量
 * @param id 购物车ID
 * @param num 购物车数量
 * @returns
 */
export function updateMyCar(id: string, num: number) {
  let params = {
    id,
    num: num,
  } as CommonReq
  return AxiosRequest.get<BaseResponse<number>>({
    url: RequestUrl.GET_UPD_CAR_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

/**
 * 提交订单
 * @returns
 */
export function addDnOrder(req: AddDnOrderReq) {
  return AxiosRequest.get<BaseResponse<number>>({
    url: RequestUrl.GET_ADD_DN_ORDER_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params: req,
  })
}

/**
 * 我的订单列表
 * @param state
 * @param page
 * @returns
 */
export function getMyOrder(page: number, state: Array<number>) {
  let params = {
    state: state,
    page,
    pagesize: 10,
  } as MyOrderReq
  UtilLog.info(TAG, `getMyOrder params info: ${JSON.stringify(params)}.`);
  return AxiosRequest.get<BaseResponse<Array<MyOrderResp>>>({
    url: RequestUrl.GET_MY_ORDER_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function getOrderInfo(orderId: string) {
  let params = {
    orderId: orderId,
  } as CommonReq
  UtilLog.info(TAG, `getMyOrder params info: ${JSON.stringify(params)}.`);
  return AxiosRequest.get<BaseResponse<MyOrderResp>>({
    url: RequestUrl.GET_ORDER_INFO_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

/*
 * 取消订单
 * @param orderId
 * returns
 * */
export function cancelOrder(orderId: string) {
  let params = {
    orderId: orderId,
  } as CommonReq
  return AxiosRequest.get<BaseResponse<number>>({
    url: RequestUrl.GET_CANCEL_ORDER_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

/*
 * 帮助信息
 * @returns
 * */
export function getHelpMsg() {
  return AxiosRequest.get<BaseResponse<Array<HelpMsgResp>>>({
    url: RequestUrl.GET_HELP_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
  })
}

/**
 * 获取商家优惠券信息，并且判断哪些券可以领取
 * @returns
 */
export function getCoupons() {
  return AxiosRequest.get<BaseResponse<Array<CouponItem>>>({
    url: RequestUrl.GET_COUPONS_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
  })
}

/**
 * 通过优惠券couponId接口领取优惠券
 * @param couponId
 * @returns
 */
export function getLqCoupons(couponId: string) {
  let params = {
    couponId: couponId,
  } as CommonReq
  return AxiosRequest.get<BaseResponse<number>>({
    url: RequestUrl.GET_LQ_COUPONS_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function getMyCoupons() {
  return AxiosRequest.get<BaseResponse<Array<CouponItem>>>({
    url: RequestUrl.GET_MY_COUPONS_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
  })
}

export function getIsNew() {
  return AxiosRequest.get<BaseResponse<number>>({
    url: RequestUrl.GET_IS_NEW_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
  })
}

export function addGoods(orderId: string) {
  let params = {
    orderId,
  } as CommonReq
  return AxiosRequest.post<BaseResponse<number>>({
    url: RequestUrl.GET_ADD_GOODS_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function getSnackSizedDeal() {
  return AxiosRequest.get<BaseResponse<Array<GoodsResp>>>({
    url: RequestUrl.GET_SNACK_SIZED_DEAL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params: {},
  })
}

export function deleteOrder(orderId: string) {
  let params = {
    orderId,
  } as CommonReq
  return AxiosRequest.delete<BaseResponse<number>>({
    url: RequestUrl.DELETE_ORDER_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function getHuaweiPayInfo(orderId: string) {
  let params = {
    orderId,
  } as CommonReq
  return AxiosRequest.get<BaseResponse<number>>({
    url: RequestUrl.GET_HUAWEI_PAY_INFO_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function rechargeMoney(rechargeTierId: string) {
  let params = {
    rechargeTierId,
  } as CommonReq
  return AxiosRequest.post<BaseResponse<number>>({
    url: RequestUrl.RECHARGE_MONEY_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function getRechargeRecord() {
  return AxiosRequest.get<BaseResponse<RechargeRecord[]>>({
    url: RequestUrl.GET_RECHARGE_RECORD_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params: {},
  })
}

export function checkPoint() {
  return AxiosRequest.get<BaseResponse<boolean>>({
    url: RequestUrl.CHECK_POINT,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params: {},
  })
}

// 订座门店列表获取
export const getBookStoreListApi = (params: BookStoreParams): Promise<BaseResponse<StoreInfoResp[]>> => {
  return AxiosRequest.get<BaseResponse<StoreInfoResp[]>>({
    url: RequestUrl.URL_STORE_BOOK_LIST,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params: params,
  })
};

// 排号门店列表获取
export const getQueueStoreListApi = (count: number): Promise<BaseResponse<StoreInfoResp[]>> => {
  const params: QueueStoreParams = { max: count };
  return AxiosRequest.get<BaseResponse<StoreInfoResp[]>>({
    url: RequestUrl.URL_STORE_QUEUE_LIST,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params: params,
  })
};

// 创建订座订单
export const createBookOrderApi = (data: BookOrderData): Promise<BaseResponse<BookOrderDetail>> => {
  return AxiosRequest.post<BaseResponse<BookOrderDetail>>({
    url: RequestUrl.URL_ORDER_BOOK_CREATE,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    data: data,
  })
};

// 取消订座订单
export const cancelBookOrderApi = (orderId: number): Promise<BaseResponse<void>> => {
  const data: CancelBookOrderDate = { orderId };
  return AxiosRequest.post<BaseResponse<void>>({
    url: RequestUrl.URL_ORDER_BOOK_CANCEL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    data: data,
  })
};

// 创建排号订单
export const createQueueOrderApi = (data: QueueOrderData): Promise<BaseResponse<QueueOrderDetail>> => {
  return AxiosRequest.post<BaseResponse<QueueOrderDetail>>({
    url: RequestUrl.URL_ORDER_QUEUE_CREATE,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    data: data,
  })
};

// 取消排号订单
export const cancelQueueOrderApi = (orderId: number): Promise<BaseResponse<void>> => {
  const data: CancelQueueOrderDate = { orderId };
  return AxiosRequest.post<BaseResponse<void>>({
    url: RequestUrl.URL_ORDER_QUEUE_CANCEL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    data: data,
  })
};

// 刷新排号订单
export const refreshQueueOrderApi = (orderId: number): Promise<BaseResponse<QueueOrderDetail | undefined>> => {
  const params: RefreshQueueOrderParams = { orderId };
  return AxiosRequest.get<BaseResponse<QueueOrderDetail | undefined>>({
    url: RequestUrl.URL_ORDER_QUEUE_REFRESH,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params: params,
  })
};

// 获取我的订单
export const getOrderListApi = (): Promise<BaseResponse<OrderLists>> => {
  return AxiosRequest.get<BaseResponse<OrderLists>>({
    url: RequestUrl.URL_ORDER_LIST,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params: {},
  })
}

// 获取我的积分记录
export const getPointList = (): Promise<BaseResponse<PointRecord[]>> => {
  return AxiosRequest.get<BaseResponse<PointRecord[]>>({
    url: RequestUrl.URL_USER_POINT_LIST,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params: {},
  })
}