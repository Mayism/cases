export interface TabBarData {
  id: TabBarType;
  title: ResourceStr;
  icon: Resource;
  activeIcon?:Resource;
}

export enum TabBarType {
  HOMEPAGE = 0,
  ORDER,
  ORDER_LIST,
  MINE
}

export const TABS_INFO: TabBarData[] = [
  {
    id: TabBarType.HOMEPAGE,
    title: $r('app.string.tab_home'),
    icon: $r('app.media.ic_tab_home'),
    activeIcon: $r('app.media.ic_tab_home_active'),
  },
  {
    id: TabBarType.ORDER,
    title: $r('app.string.tab_order'),
    icon: $r('app.media.ic_tab_order'),
    activeIcon: $r('app.media.ic_tab_order_active'),
  },
  {
    id: TabBarType.ORDER_LIST,
    title: $r('app.string.tab_order_list'),
    icon: $r('app.media.ic_tab_order_list'),
    activeIcon: $r('app.media.ic_tab_order_list_active'),
  },
  {
    id: TabBarType.MINE,
    title: $r('app.string.tab_mine'),
    icon: $r('app.media.ic_tab_person'),
    activeIcon: $r('app.media.ic_tab_person_active'),
  },
]

export interface HuaweiIDResp {
  openId: string
  unionId: string
  authCode: string
}