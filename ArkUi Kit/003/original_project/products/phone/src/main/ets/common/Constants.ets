import { TabBarData, TabBarType } from 'lib_common';

export const TABS_INFO: TabBarData[] = [
  {
    id: TabBarType.HOME_PAGE,
    title: '首页',
    activeIcon: $r('app.media.ic_tab_home_check'),
    defaultIcon: $r('app.media.ic_tab_home')
  },
  {
    id: TabBarType.ONE_CODE_PASS,
    title: '一码通',
    activeIcon: $r('app.media.ic_tab_code_pass'),
    defaultIcon: $r('app.media.ic_tab_code_pass')
  },
  {
    id: TabBarType.MINE,
    title: '我的',
    activeIcon: $r('app.media.ic_tab_mine_check'),
    defaultIcon: $r('app.media.ic_tab_mine')
  },
]
