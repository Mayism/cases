import AxiosMockAdapter from '@hw-agconnect/axios-mock-adapter';
import { AxiosRequestConfig, HttpStatusCode } from '@ohos/axios';
import { RequestUrl } from '../../constants/Index';
import { OrderLists } from '../../types/Order';
import { BaseResponse } from '../../types/Response';
import { PointRecord, RechargeRecord, UserInfoResp } from '../../types/User';
import { OrderUtil } from '../../utils/OrderUtil';
import {
  checkPoint,
  getCloseLogin,
  getOpenLogin,
  getPointList,
  getRechargeRecord,
  getUserInfoResp,
  rechargeMoney,
} from '../MockData/User';

export class UserMockApis {
  public start(adapter: AxiosMockAdapter) {
    adapter.onGet(RequestUrl.GET_LOGIN_HM_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getUserInfoResp(config.params.isRelative);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<UserInfoResp>,
      };
    });
    adapter.onGet(RequestUrl.GET_OPEN_LOGIN_HM_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getOpenLogin();
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<UserInfoResp>,
      };
    });
    adapter.onGet(RequestUrl.GET_CLOSE_LOGIN_HM_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getCloseLogin();
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<UserInfoResp>,
      };
    });
    adapter.onPost(RequestUrl.RECHARGE_MONEY_URL).reply(async (config: AxiosRequestConfig) => {
      let data = rechargeMoney(config.params.rechargeTierId);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<number>,
      };
    });
    adapter.onGet(RequestUrl.GET_RECHARGE_RECORD_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getRechargeRecord();
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<RechargeRecord[]>,
      };
    });
    adapter.onGet(RequestUrl.CHECK_POINT).reply(async (config: AxiosRequestConfig) => {
      let data = checkPoint();
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<boolean>,
      };
    });

    // 获取我的订单
    adapter.onGet(RequestUrl.URL_ORDER_LIST).reply(async () => {
      const data: OrderLists = {
        book: OrderUtil.getBookOrders(),
        queue: OrderUtil.getQueueOrders(),
      };
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<OrderLists>,
      };
    });
    // 获取我的订单
    adapter.onGet(RequestUrl.URL_USER_POINT_LIST).reply(async () => {
      const data: PointRecord[] = getPointList();
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<PointRecord[]>,
      };
    });
  }
}