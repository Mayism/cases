import AxiosMockAdapter from '@hw-agconnect/axios-mock-adapter';
import { AxiosRequestConfig, HttpStatusCode } from '@ohos/axios';
import { RequestUrl } from '../../constants/Index';
import { MyOrderResp } from '../../types/Order';
import { BaseResponse } from '../../types/Response';
import { addOrder, cancelOrder, deleteOrder, getHuaweiPayInfo, getMyOrder, getOrderInfo } from '../MockData/Order';

export class OrderMockApis {
  public start(adapter: AxiosMockAdapter) {

    adapter.onGet(RequestUrl.GET_ADD_DN_ORDER_URL).reply(async (config: AxiosRequestConfig) => {
      let data = addOrder(config.params);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<string>,
      };
    });

    adapter.onGet(RequestUrl.GET_MY_ORDER_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getMyOrder(config.params);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<Array<MyOrderResp>>,
      };
    });

    adapter.onGet(RequestUrl.GET_ORDER_INFO_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getOrderInfo(config.params);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<MyOrderResp>,
      };
    });

    adapter.onGet(RequestUrl.GET_CANCEL_ORDER_URL).reply(async (config: AxiosRequestConfig) => {
      let data = cancelOrder(config.params);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<number>,
      };
    });


    adapter.onDelete(RequestUrl.DELETE_ORDER_URL).reply(async (config: AxiosRequestConfig) => {
      let data = deleteOrder(config.params);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<number>,
      };
    });

    adapter.onGet(RequestUrl.GET_HUAWEI_PAY_INFO_URL).reply(async (config: AxiosRequestConfig) => {
      let data = getHuaweiPayInfo(config.params);
      return {
        status: HttpStatusCode.Ok,
        data: { code: 0, msg: '', data: data } as BaseResponse<number>,
      };
    });


  }
}