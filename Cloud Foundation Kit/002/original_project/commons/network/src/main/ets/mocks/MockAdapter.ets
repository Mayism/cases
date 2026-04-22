import AxiosMockAdapter from '@hw-agconnect/axios-mock-adapter';
import process from '@ohos.process';
import HttpRequest from '../apis/AxiosHttpRequest';
import { OrderMockApis } from './mockapis/OrderMockApis';
import { StoreMockApis } from './mockapis/StoreMockApis';
import { UserMockApis } from './mockapis/UserMockApis';


// 创建mock适配器
const mockAdapter = new AxiosMockAdapter(HttpRequest.instance, {
  // pid===tid为主线程，否则为卡片
  delayResponse: process.pid === process.tid ? 100 : 0,
});

// todo 全局配置，是否启用mock，当前默认启用
const enableMock: boolean = true;

if (enableMock) {
  const mockApis = [
    new StoreMockApis(),
    new OrderMockApis(),
    new UserMockApis(),
  ];
  mockApis.forEach((api) => {
    api.start(mockAdapter);
  });
}
