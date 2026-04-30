import { AxiosRequestHeaders } from '@ohos/axios';
import axiosClient from '../models/AxiosRequest';
import { GetCouponsRequest, IConsumeCouponRequest } from '../types/AxiosRequestParam';
import { BaseSuccessResponse } from '../types/BaseSuccessResponse';
import { GetCouponsResp, IConsumeCouponResp } from '../types/responseTypes/GetCouponsResp';

class HttpsApi {
  /** 获取优惠券 **/
  public getCoupons(params: GetCouponsRequest): Promise<BaseSuccessResponse<GetCouponsResp>> {
    return axiosClient.get({
      url: '/v1/coupons/coupons-list',
      showLoading: false,
      headers: {} as AxiosRequestHeaders,
      params: params,
    });
  }

  /**
   * 消费优惠券
   */
  public consumeCoupon(params: IConsumeCouponRequest): Promise<BaseSuccessResponse<IConsumeCouponResp>> {
    return axiosClient.get({
      url: '/v1/coupons/consume-coupon',
      showLoading: false,
      headers: {} as AxiosRequestHeaders,
      params: params,
    });
  }
}

const https = new HttpsApi();

export { https as Https };
