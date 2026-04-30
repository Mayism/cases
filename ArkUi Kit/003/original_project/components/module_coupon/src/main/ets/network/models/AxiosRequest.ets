import { BusinessError } from '@kit.BasicServicesKit';
import { AxiosRequestHeaders, AxiosResponse } from '@ohos/axios';
import { AxiosHttpRequest } from './AxiosHttp';
import { FullLoading } from '../../commonlib/Index';

const axiosClient = new AxiosHttpRequest(
  {
    baseURL: '',
    timeout: 10 * 3000,
    headers: {
    }as AxiosRequestHeaders,
    interceptorHooks: {
      requestInterceptor: async (config) => {
        if (config.showLoading) {
          FullLoading.showLoading();
        }
        return config;
      },
      requestInterceptorCatch: (err: BusinessError) => {
        if (FullLoading.isLoading) {
          FullLoading.hideLoading();
        }
        return err;
      },
      responseInterceptor: (response: AxiosResponse) => {
        if (FullLoading.isLoading) {
          FullLoading.hideLoading();
        }
        if (response.status === 200) {
          return Promise.resolve(response.data);
        } else {
          return Promise.reject(response);
        }
      },
      responseInterceptorCatch: (error: BusinessError) => {
        if (FullLoading.isLoading) {
          FullLoading.hideLoading();
        }
        return Promise.reject(error);
      },
    },
  },
  true,// 开关模拟
);

export default axiosClient;
