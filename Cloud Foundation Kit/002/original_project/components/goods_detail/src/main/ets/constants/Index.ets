import { BuyNote } from '../models/Index';

export const BUY_NOTE_LIST: BuyNote[] = [
  {
    icon: $r('app.media.ic_public_clock'),
    noteTitle: $r('app.string.use_time'),
    noteDesc: [$r('app.string.use_time_desc')],
  },
  {
    icon: $r('app.media.ic_ict_trip'),
    noteTitle: $r('app.string.validity'),
    noteDesc: [$r('app.string.order_validity_desc')],
  },
  {
    icon: $r('app.media.ic_public_doc_list'),
    noteTitle: $r('app.string.usage_rules'),
    noteDesc: [$r('app.string.usage_rules_desc1'), $r('app.string.usage_rules_desc2')],
  },
];

export class Constants {
  // todo mock图片url前缀，真实图片地址可以按业务需求指定
  static readonly CLOUD_STORAGE_URL = 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/test-1pvkp/'
}

// 商品类别
export enum GoodsSpecEnum {
  // 正常
  NORMAL = 1,
  // 选规格
  SPEC_TYPE = 2,
  // 选套餐
  PACKAGE_TYPE = 3,
}