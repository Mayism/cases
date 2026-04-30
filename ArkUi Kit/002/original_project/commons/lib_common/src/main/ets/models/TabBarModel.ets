export interface TabBarData {
  id: TabBarType;
  title: ResourceStr;
  activeIcon?: ResourceStr;
  defaultIcon?: ResourceStr;
}

export enum TabBarType {
  HOME_PAGE = 0,
  ONE_CODE_PASS,
  MINE
}

export interface HuaweiIDResp {
  openId: string
  unionId: string
  authCode: string
}