import { AppStorageV2 } from '@kit.ArkUI';
import { AxiosRequestHeaders } from '@ohos/axios';
import { PLATE_COLOR_TYPE, RequestUrl } from '../constants/Common';
import { CommonReq } from '../models/RequestModel';
import {
  PayRecord,
  BaseResponse,
  ShoppingMall,
  StoreGuide,
  UserInfo,
  PlateNumber,
  Wallet,
} from '../models/ResponseModel';
import { MallModel, UserInfoModel } from '../models/StorageModel';
import AxiosRequest from './AxiosRequest';

export async function getShoppingMallInfo() {
  let params = {
    packageName: 'appInfo.packageName',
  } as CommonReq
  return AxiosRequest.get<BaseResponse<ShoppingMall>>({
    url: RequestUrl.GET_SHOPPING_MALL_INFO_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export async function addPlateNumber(plate: string, plateColorType: string, plateKind: number) {
  let type = PLATE_COLOR_TYPE.BLUE
  if (plateColorType === PLATE_COLOR_TYPE.GREEN) {
    type = PLATE_COLOR_TYPE.GREEN
  } else if (plateColorType === PLATE_COLOR_TYPE.YELLOW) {
    type = PLATE_COLOR_TYPE.YELLOW
  }
  let params = {
    plate,
    type,
    plateKind,
  } as CommonReq
  return AxiosRequest.get<BaseResponse>({
    url: RequestUrl.ADD_PLATE_NUMBER,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export async function getPayDetail(plate: string) {
  let params = {
    plate,
  } as CommonReq
  return AxiosRequest.get<BaseResponse<PayRecord>>({
    url: RequestUrl.GET_PAY_DETAIL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

// 查询缴费记录
export async function getPayRecordList() {
  return AxiosRequest.get<BaseResponse<PayRecord[]>>({
    url: RequestUrl.GET_PAY_RECORD_LIST,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
  })
}

export async function deletePlateNumber(id: string) {
  let params = {
    id,
  } as CommonReq
  return AxiosRequest.get<BaseResponse>({
    url: RequestUrl.DELETE_PLATE_NUMBER,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export async function queryPlateNumber() {
  return AxiosRequest.get<BaseResponse<Array<PlateNumber>>>({
    url: RequestUrl.QUERY_PLATE_NUMBER,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params: {},
  })
}


export async function getOpenLoginHm(code: string = '') {
  let params = {
    code,
  } as CommonReq
  return AxiosRequest.get<BaseResponse<UserInfo>>({
    url: RequestUrl.GET_OPEN_LOGIN_HM_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export async function getCloseLoginHm(code: string = '') {
  let params = {
    code,
  } as CommonReq
  return AxiosRequest.get<UserInfo>({
    url: RequestUrl.GET_CLOSE_LOGIN_HM_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function getUserInfo(openId: string, unionId: string) {
  let params = {
    packageName: '',
    openId: openId,
    unionId: unionId,
  } as CommonReq
  return AxiosRequest.get<BaseResponse<UserInfo>>({
    url: RequestUrl.GET_USER_INFO,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function payOrder(plate: string, money: string) {
  let params = {
    plate,
    extraPay: money,
  } as CommonReq
  return AxiosRequest.get<BaseResponse>({
    url: RequestUrl.PAY_ORDER,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function getPrivacyInfo() {
  let mallModel: MallModel = AppStorageV2.connect(MallModel, () => new MallModel())!;
  let params = {
    storeId: mallModel.shoppingMall.id,
  } as CommonReq
  return AxiosRequest.post<BaseResponse<string>>({
    url: RequestUrl.GET_PRIVACY_INFO,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function modifyUserInfo(name: string) {
  let userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
  let mallModel: MallModel = AppStorageV2.connect(MallModel, () => new MallModel())!;
  let params = {
    storeId: mallModel.shoppingMall.id,
    userId: userInfo.userInfo.id,
    name,
  } as CommonReq
  return AxiosRequest.post<BaseResponse<UserInfo>>({
    url: RequestUrl.MODIFY_USER_INFO,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function getMyWalletList() {
  let mallModel: MallModel = AppStorageV2.connect(MallModel, () => new MallModel())!;
  let userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
  let params = {
    storeId: mallModel.shoppingMall.id,
    userId: userInfo.userInfo.id,
  } as CommonReq
  return AxiosRequest.get<BaseResponse<Array<Wallet>>>({
    url: RequestUrl.GET_MY_WALLET_LIST_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function getService(index: number, type: number) {
  let params = {
    index,
    type,
  } as CommonReq
  return AxiosRequest.get<BaseResponse<string>>({
    url: RequestUrl.GET_SERVICE_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}

export function getStoreGuide() {
  let mallModel: MallModel = AppStorageV2.connect(MallModel, () => new MallModel())!;
  let params = {
    storeId: mallModel.shoppingMall.id,
  } as CommonReq
  return AxiosRequest.get<BaseResponse<Array<StoreGuide>>>({
    url: RequestUrl.GET_STORE_GUIDE_URL,
    showLoading: true,
    headers: {} as AxiosRequestHeaders,
    params,
  })
}