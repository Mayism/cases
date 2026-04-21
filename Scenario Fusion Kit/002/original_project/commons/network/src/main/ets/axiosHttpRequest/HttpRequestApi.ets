import { AxiosRequestHeaders } from '@ohos/axios';
import { DnState, OrderListEnum, RequestUrl } from '../constants/Common';
import { CommonReq, MyOrderReq } from '../models/RequestModel';
import {
  GetHmSystemResp,
  GetTableInfoResp,
  GetTableTitleResp,
  GetUserInfoResp,
  PackageSpec,
} from '../models/ResponseModel';
import AxiosRequest from './AxiosRequest';

/**
 * 通过APPID调用接口获取店铺storeId，再通过接口获取店铺信息
 * @param params
 * @returns
 */
export async function getHmSystem() {
  let params = {
    hmAppid: AppStorage.get('appId') as string,
  } as CommonReq
  return AxiosRequest.get<GetHmSystemResp>({
    url: RequestUrl.GET_HM_SYSTEM_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function getUserInfo(storeId: string, openId: string, unionId: string) {
  let params = {
    storeId: storeId,
    openId: openId,
    unionId: unionId,
  } as CommonReq
  return AxiosRequest.get<GetUserInfoResp>({
    url: RequestUrl.GET_LOGIN_HM_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export async function getOpenLoginHm(code: string = '') {
  let params = {
    storeId: AppStorage.get('storeId') as string,
    userId: AppStorage.get('userId') as string,
    code: code ?? AppStorage.get('authCode') as string,
  } as CommonReq
  return AxiosRequest.get<GetUserInfoResp>({
    url: RequestUrl.GET_OPEN_LOGIN_HM_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export async function getCloseLoginHm(code: string = '') {
  let params = {
    storeId: AppStorage.get('storeId') as string,
    userId: AppStorage.get('userId') as string,
    code: code ?? AppStorage.get('authCode') as string,
  } as CommonReq
  return AxiosRequest.get<GetUserInfoResp>({
    url: RequestUrl.GET_CLOSE_LOGIN_HM_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function getTableTitle(storeId: string) {
  let params = {
    storeId: storeId,
  } as CommonReq
  return AxiosRequest.get<GetTableTitleResp>({
    url: RequestUrl.GET_TABLE_TITLE_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

/**
 * 4、通过桌号id接口获取桌位信息
 * @param tableid
 * @returns
 */
export function getTableInfo(tableId: string) {
  let params = {
    type: tableId,
  } as CommonReq
  return AxiosRequest.get<GetTableInfoResp>({
    url: RequestUrl.GET_ZHUO_HAO_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}


export function clearMyCar() {
  let storeId: string = AppStorage.get('storeId') as string
  let userId: string = AppStorage.get('userId') as string
  let params = {
    userId: userId,
    storeId: storeId,
  } as CommonReq
  return AxiosRequest.get<number>({
    url: RequestUrl.GET_DEL_CAR_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

/**
 * 13、更新已经添加到购物车的菜品数量
 * @param id 购物车ID
 * @param num 购物车数量
 * @returns
 */
export function updateMyCar(id: string, num: number) {
  let params = {
    id,
    num: num + '',
  } as CommonReq
  return AxiosRequest.get<number>({
    url: RequestUrl.GET_UPD_CAR_URL,
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
  return AxiosRequest.get<number>({
    url: RequestUrl.GET_CANCEL_ORDER_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params
  })
}

/**
 * 通过优惠券couponId、userId接口领取优惠券
 * @param couponId
 * @returns
 */
export function getLqCoupons(couponId: string) {
  let userId: string = AppStorage.get('userId') as string
  let params = {
    couponId: couponId,
    userId: userId,
  } as CommonReq
  return AxiosRequest.get<number>({
    url: RequestUrl.GET_LQ_COUPONS_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function getIsNew() {
  let storeId: string = AppStorage.get('storeId') as string
  let userId: string = AppStorage.get('userId') as string
  let params = {
    storeId: storeId,
    userId: userId,
  } as CommonReq
  return AxiosRequest.get<number>({
    url: RequestUrl.GET_IS_NEW_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function addGoods(orderId: string) {
  let params = {
    orderId,
  } as CommonReq
  return AxiosRequest.get<number>({
    url: RequestUrl.GET_ADD_GOODS_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function deleteOrder(orderId: string) {
  let params = {
    orderId,
  } as CommonReq
  return AxiosRequest.get<number>({
    url: RequestUrl.GET_DELETE_ORDER_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function getHuaweiPayInfo(orderId: string) {
  let params = {
    orderId,
  } as CommonReq
  return AxiosRequest.get<number>({
    url: RequestUrl.GET_HUAWEI_PAY_INFO_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}