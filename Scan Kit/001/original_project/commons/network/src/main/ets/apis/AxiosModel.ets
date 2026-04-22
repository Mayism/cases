import { AxiosRequestHeaders, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';

export interface InterceptorHooks {
  requestInterceptor?: (config: HttpRequestConfig) => Promise<HttpRequestConfig>;
  requestInterceptorCatch?: (error: BusinessError) => BusinessError;
  responseInterceptor?: (response: AxiosResponse) => AxiosResponse | Promise<AxiosResponse>;
  responseInterceptorCatch?: (error: BusinessError) => Promise<BusinessError>;
}

export interface HttpRequestConfig extends InternalAxiosRequestConfig {
  showLoading?: boolean; //是否展示请求loading
  checkResultCode?: boolean; //是否检验响应结果码
  needJumpToLogin?: boolean //是否需要跳转到登陆页面
  interceptorHooks?: InterceptorHooks;
  method?: string;
  headers: AxiosRequestHeaders
}