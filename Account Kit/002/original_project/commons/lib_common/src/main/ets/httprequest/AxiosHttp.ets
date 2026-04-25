import { BusinessError } from '@kit.BasicServicesKit';
import axios, {
  AxiosInstance,
  AxiosRequestHeaders,
  AxiosResponse,
  InternalAxiosRequestConfig
} from '@ohos/axios';
import { RequestUrl } from '../constants/Common';
import { MockData } from '../mock/MockData';
import { CommonReq } from '../models/RequestModel';
import { Logger } from '../utils/Logger';

const TAG = '[AxiosHttp]';

interface InterceptorHooks {
  requestInterceptor?: (config: HttpRequestConfig) => Promise<HttpRequestConfig>;
  requestInterceptorCatch?: (error: BusinessError) => Object;
  responseInterceptor?: (response: AxiosResponse) => AxiosResponse | Promise<AxiosResponse>;
  responseInterceptorCatch?: (error: BusinessError) => Object;
}

export interface HttpRequestConfig extends InternalAxiosRequestConfig {
  showLoading?: boolean; //是否展示请求loading
  checkResultCode?: boolean; //是否检验响应结果码
  needJumpToLogin?: boolean //是否需要跳转到登陆页面
  interceptorHooks?: InterceptorHooks;
  method?: string;
  headers: AxiosRequestHeaders
}


/**
 * 网络请求构造
 * 基于axios框架实现
 */
export class AxiosHttpRequest {
  config: HttpRequestConfig;
  instance: AxiosInstance;
  interceptorHooks?: InterceptorHooks;
  mockFlag: boolean = false;

  setupInterceptor(): void {
    this.instance.interceptors.request.use(
      this.interceptorHooks?.requestInterceptor,
      this.interceptorHooks?.requestInterceptorCatch,
    );
    this.instance.interceptors.response.use(
      this.interceptorHooks?.responseInterceptor,
      this.interceptorHooks?.responseInterceptorCatch,
    );
  }

  constructor(options: HttpRequestConfig, mockFlag: boolean = false) {
    this.mockFlag = mockFlag;
    this.config = options;
    this.instance = axios.create(options);
    this.interceptorHooks = options.interceptorHooks;
    this.setupInterceptor()
  }

  request<T = Object>(config: HttpRequestConfig): Promise<T> {
    return new Promise<T>((resolve, reject) => {
      if (this.mockFlag) {
        let res = getMockResponse<T>(config)
        resolve(res)
        return
      }
      this.instance
        .request<Object, T>(config)
        .then(res => {
          resolve(res);
        })
        .catch((err: BusinessError) => {
          Logger.error(TAG, 'request error：', err.message)
          errorHandler(err)
          if (err) {
            reject(err);
          }
        });
    });
  }

  get<T = Object>(config: HttpRequestConfig): Promise<T> {
    config.method = 'GET'
    return this.request(config);
  }

  post<T = Object>(config: HttpRequestConfig): Promise<T> {
    config.method = 'POST'
    return this.request(config);
  }

  delete<T = Object>(config: HttpRequestConfig): Promise<T> {
    config.method = 'DELETE'
    return this.request(config);
  }
}

export function errorHandler(error: BusinessError) {
  Logger.error('error: ' + JSON.stringify(error));
}

export function getMockResponse<T>(config: HttpRequestConfig): T {
  let params: CommonReq = config.params
  let url: string = config.url || '';
  switch (url) {
    case RequestUrl.GET_SHOPPING_MALL_INFO_URL:
      return MockData.getShoppingMallInfo as T;
    case RequestUrl.GET_USER_INFO:
      return MockData.getUserInfoResp as T;
    case RequestUrl.ADD_PLATE_NUMBER:
      return MockData.addPlateNumber(params) as T;
    case RequestUrl.DELETE_PLATE_NUMBER:
      return MockData.deletePlateNumber(params) as T;
    case RequestUrl.QUERY_PLATE_NUMBER:
      return MockData.queryPlateNumber as T;
    case RequestUrl.GET_OPEN_LOGIN_HM_URL:
      return MockData.getOpenLogin as T;
    case RequestUrl.GET_CLOSE_LOGIN_HM_URL:
      return MockData.getCloseLogin as T;
    case RequestUrl.GET_PAY_RECORD_LIST:
      return MockData.getPayRecordList as T;
    case RequestUrl.GET_PAY_DETAIL:
      return MockData.getPayDetail(params) as T;
    case RequestUrl.PAY_ORDER:
      return MockData.payOrder(params) as T;
    case RequestUrl.MODIFY_USER_INFO:
      return MockData.modifyUserInfo(params) as T;
    case RequestUrl.GET_MY_WALLET_LIST_URL:
      return MockData.getMyWalletList as T;
    case RequestUrl.GET_SERVICE_URL:
      return MockData.getService as T;
    case RequestUrl.GET_STORE_GUIDE_URL:
      return MockData.getStoreGuide as T;
    case RequestUrl.GET_PRIVACY_INFO:
      return MockData.getPrivacyInfo as T;
    default:
      return '' as T;
  }
}

export default AxiosHttpRequest