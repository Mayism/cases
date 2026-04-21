import { HttpRequestConfig } from '../axiosHttpRequest/AxiosModel';
import { RequestUrl } from '../constants/Common';
import { MockData } from './MockData';

export function getMockResponse<T>(config: HttpRequestConfig): T {
  let params: ESObject = config.params
  let url: string = config.url || '';
  switch (url) {
    case RequestUrl.GET_LOGIN_HM_URL:
      return MockData.getUserInfoResp as T;
    case RequestUrl.GET_OPEN_LOGIN_HM_URL:
      return MockData.getOpenLogin as T;
    case RequestUrl.GET_CLOSE_LOGIN_HM_URL:
      return MockData.getCloseLogin as T;
    case RequestUrl.GET_TABLE_TITLE_URL:
      return MockData.getTableTitleResp as T;
    case RequestUrl.GET_ZHUO_HAO_URL:
      return MockData.getTableInfoResp(params) as T;
    case RequestUrl.GET_IS_NEW_URL:
      return MockData.getIsNew as T;
    default:
      return '' as T;
  }
}