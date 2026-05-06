export interface TabBarData {
  id: TabBarType;
  title: ResourceStr;
  activeIcon?: ResourceStr;
  defaultIcon?: ResourceStr;
}

export enum TabBarType {
  HOME_PAGE = 0,
  MINE = 1
}

export interface HuaweiIDResp {
  openId: string
  unionId: string
  authCode: string
}