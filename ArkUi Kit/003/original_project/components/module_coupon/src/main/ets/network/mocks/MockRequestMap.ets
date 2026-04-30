import { httpsMock } from './HttpRequestApiMock';
import { FullLoading, Logger } from '../../commonlib/Index';
import { BaseSuccessResponse } from '../types/BaseSuccessResponse';

type MockMap = Record<string, (...args: ESObject[]) => Promise<BaseSuccessResponse<Object>>>;

// 创建 URL 到 Mock 方法的映射对象
const mockMap: MockMap = {
  '/v1/coupons/coupons-list': httpsMock.getCoupons,
  '/v1/coupons/consume-coupon': httpsMock.consumeCoupon,
};

// 模拟一个延时的 mock 方法，延迟时间为 `delay` 毫秒
function simulateDelay<T>(data: T, delay: number): Promise<T> {
  return new Promise<T>((resolve) => {
    setTimeout(() => {
      resolve(data);
    }, delay);
  });
}

function mockErrorHandler(msg?: string): Promise<string> {
  const errMsg: string = 'replace mock data failed!';
  FullLoading.hideLoading();
  Logger.error('[MockRequest]', msg ?? '', errMsg);
  return Promise.reject(errMsg);
}

export async function replaceMockData(url: string | undefined, args: Object): Promise<Object> {
  const arr = Object.entries(mockMap);
  if (url) {
    // url严格一致
    const func = arr.find((item) => url === item[0]);
    if (func) {
      const response: BaseSuccessResponse<Object> = await func[1](args);
      const delayResponse: BaseSuccessResponse<Object> = await simulateDelay(response, 10);
      FullLoading.hideLoading();
      return Promise.resolve(delayResponse);
    }
    return mockErrorHandler('cannot find mock function.');
  }
  return mockErrorHandler('cannot find url.');
}
