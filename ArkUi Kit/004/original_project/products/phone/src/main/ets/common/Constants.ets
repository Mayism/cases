import { TabBarData, TabBarType } from 'lib_common';

export const TABS_INFO: TabBarData[] = [
  {
    id: TabBarType.HOME_PAGE,
    title: '首页',
    activeIcon: $r('app.media.ic_tab_home_check'),
    defaultIcon: $r('app.media.ic_tab_home')
  },
  {
    id: TabBarType.MINE,
    title: '我的',
    activeIcon: $r('app.media.ic_tab_mine_check'),
    defaultIcon: $r('app.media.ic_tab_mine')
  },
]
