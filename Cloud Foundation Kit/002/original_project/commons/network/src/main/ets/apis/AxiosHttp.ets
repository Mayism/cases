import { UtilLog } from '@hw-agconnect/util-log';
import { BusinessError } from '@kit.BasicServicesKit';
import axios, { AxiosInstance } from '@ohos/axios';
import { HttpRequestConfig, InterceptorHooks } from './AxiosModel';

const TAG = '[AxiosHttpRequest]'

/**
 * 网络请求构造
 * 基于axios框架实现
 */
export class AxiosHttpRequest {
  config: HttpRequestConfig;
  instance: AxiosInstance;
  interceptorHooks?: InterceptorHooks;

  constructor(options: HttpRequestConfig) {
    this.config = options;
    this.instance = axios.create(options);
    this.interceptorHooks = options.interceptorHooks;
    this.setupInterceptor()
  }

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

  request<T>(config: HttpRequestConfig): Promise<T> {
    return new Promise<T>((resolve, reject) => {
      this.instance
        .request<null, T>(config)
        .then(res => {
          resolve(res);
        })
        .catch((err: BusinessError) => {
          UtilLog.error(TAG, '网络请求Request异常：', err.message)
          if (err) {
            reject(err);
          }
        });
    });
  }

  get<T>(config: HttpRequestConfig): Promise<T> {
    config.method = 'GET'
    return this.request(config);
  }

  post<T>(config: HttpRequestConfig): Promise<T> {
    config.method = 'POST'
    return this.request(config);
  }

  delete<T>(config: HttpRequestConfig): Promise<T> {
    config.method = 'DELETE'
    return this.request(config);
  }
}

export default AxiosHttpRequest