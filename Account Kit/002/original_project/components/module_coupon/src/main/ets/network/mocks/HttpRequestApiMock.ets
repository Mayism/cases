import { GetCouponsRequest, IConsumeCouponRequest } from '../types/AxiosRequestParam';
import { BaseSuccessResponse } from '../types/BaseSuccessResponse';
import { GetCouponsResp, IConsumeCouponResp } from '../types/responseTypes/GetCouponsResp';
import { CouponMock, getCouponsMock1, getCouponsMock2, getCouponsMockNull } from './mockData/GetMockCoupons';

class HttpsApiMock {
  /** 获取优惠券 **/
  public getCoupons(params: GetCouponsRequest): Promise<BaseSuccessResponse<GetCouponsResp>> {
    if (params.status === '2') {
      return Promise.resolve(getCouponsMock1);
    } else if (params.status === '3' && params.couponStatus === '1') {
      return Promise.resolve(getCouponsMock2);
    }
    return Promise.resolve(getCouponsMockNull)
  }

  /**
   * 消费优惠券
   */
  public consumeCoupon(params: IConsumeCouponRequest): Promise<BaseSuccessResponse<IConsumeCouponResp>> {
    const item = CouponMock.validList.find(v => v.couponID === params.couponID);
    if (item) {
      item.offsetInfo = {
        offsetID: '1',
        couponCollectionTime: '1',
        couponOffsetTime: '1',
        offsetOrder: '1',
        couponStatus: '1',
      };
    }
    return Promise.resolve({
      code: 0,
      data: {
        couponID: item ? params.couponID : 'Invalid ID',
      }
    } as BaseSuccessResponse<IConsumeCouponResp>)
  }
}

const httpsMock = new HttpsApiMock();

export { httpsMock };
