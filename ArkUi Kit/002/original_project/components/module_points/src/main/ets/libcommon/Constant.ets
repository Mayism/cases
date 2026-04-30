export class Constants {
  static readonly FULL_SIZE = '100%'
  static readonly BORDER_WIDTH = 16
  static readonly YEAR_PICKER =
    ['1990年', '1991年', '1992年', '1993年', '1994年', '1995年', '1996年', '1997年', '1998年', '1999年',
      '2000年', '2001年', '2002年', '2003年', '2004年', '2005年', '2006年', '2007年', '2008年', '2009年', '2010年',
      '2011年', '2012年',
      '2013年', '2014年', '2015年', '2016年', '2017年', '2018年', '2019年', '2020年', '2021年', '2022年', '2023年',
      '2024年', '2025年',
      '2026年', '2027年', '2028年', '2029年', '2030年']
  static readonly MONTH_PICKER: string[] =
    ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
  static readonly CLOUD_STORAGE_URL = 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/template-thwjd/'
}

export enum RouterMap {
  SELF_SERVICE_POINT_PAGE = 'SelfServicePointPage',
  SELF_POINT_RECORD_PAGE = 'SelfPointRecordPage',
  SELF_POINT_RULE = 'SelfPointRule',
  SELF_POINT_GUIDE = 'SelfPointGuide',
}