import { AxiosRequestHeaders, AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { AxiosHttpRequest, errorHandler } from './AxiosHttp';
import { Constants, HttpCode, RequestUrl } from '../constants/Common';

const axiosClient = new AxiosHttpRequest({
  baseURL: RequestUrl.BASE_URL,
  checkResultCode: false,
  // 5秒超时
  timeout: Constants.REQUEST_TIME_OUT,
  headers: {
  } as AxiosRequestHeaders,
  interceptorHooks: {
    requestInterceptor: async (config) => {
      axiosClient.config.showLoading = config.showLoading;
      if (config.baseURL) {
        // 补充公共请求参数
        if (!config.params) {
          config.params = {};
        }
        config.params.i = 'xxxxx';
      }

      return config;
    },
    requestInterceptorCatch: (err: BusinessError) => {
      return err;
    },
    responseInterceptor: (response: AxiosResponse) => {
      //优先执行自己的请求响应拦截器，在执行通用请求request的
      if (axiosClient.config.showLoading) {
      }
      if (response.data.Response?.Result?.token) {
        AppStorage.setOrCreate('token', response.data.Response?.Result?.token);
      }
      if (response.status === HttpCode.SUCCESS_200) {
        return Promise.resolve(response.data);
      } else {
        return Promise.reject(response);
      }
    },
    responseInterceptorCatch: (error: BusinessError) => {
      errorHandler(error);
      return Promise.reject(error);
    },
  }
}, true);

export default axiosClient;