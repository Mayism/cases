import { AxiosHttpRequest } from './AxiosHttp';
import { AxiosRequestHeaders, AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { RequestUrl } from '../constants/Index';

const axiosClient = new AxiosHttpRequest({
  baseURL: RequestUrl.BASE_URL,
  checkResultCode: false,
  // 3秒超时
  timeout: RequestUrl.REQUEST_TIME_OUT,
  headers: {} as AxiosRequestHeaders,
  interceptorHooks: {
    requestInterceptor: async (config) => {
      axiosClient.config.showLoading = config.showLoading;
      if (config.baseURL) {
        if (!config.params) {
          config.params = {};
        }
        // todo 接口请求补充公共请求参数 config.params.i = 'xxxxx';
      }

      if (config.showLoading) {
        // todo 可以补充网络请求加载loading效果
      }
      return config;
    },
    requestInterceptorCatch: (err: BusinessError) => {
      if (axiosClient.config.showLoading) {
      }
      return err;
    },
    responseInterceptor: (response: AxiosResponse) => {
      //优先执行自己的请求响应拦截器，在执行通用请求request的
      if (axiosClient.config.showLoading) {
      }
      if (response.data.Response?.Result?.token) {
        // todo token
      }
      if (response.status === 200) {
        return Promise.resolve(response.data);
      } else {
        return Promise.reject(response);
      }
    },
    responseInterceptorCatch: (error: BusinessError) => {
      if (axiosClient.config.showLoading) {
      }
      return Promise.reject(error);
    },
  },
});

export default axiosClient;