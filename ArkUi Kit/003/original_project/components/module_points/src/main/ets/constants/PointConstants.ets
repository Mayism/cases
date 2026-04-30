import { IPoint } from '../libcommon/Index';

// 积分审核状态tab
export interface PointItem {
  title: string,
  value: number,
}

// 积分类型
export enum PointType {
  SCAN = 0,
  PHOTO,
}

// 积分路由传参
export class PointRouteParam {
  id: string = '';
}

/**
 * 积分有关的常量
 */
export class PointConstants {
  static readonly SELF_POINT_RECORD_TABS: PointItem[] = [
    {
      title: '审核中',
      value: 0,
    },
    {
      title: '已通过',
      value: 1,
    },
    {
      title: '未通过',
      value: 2,
    },
  ]
  static readonly DEFAULT_POINT: number = 1900;
  static readonly DEFAULT_CAR_PARKING: number = 999;
}

export enum PointStatus {
  REVIEWING,
  APPROVED,
  UN_APPROVED,
}

export const POINT_LIST: IPoint[] = [
  {
    id: '1',
    type: 0,
    action: 2,
    status: 0,
    point: 150,
    photo: 'ShoppingMall/img_approve.png',
    time: new Date('2025-06-10 10:24:06').getTime(),
  },
  {
    id: '2',
    type: 0,
    action: 1,
    status: 0,
    point: 1800,
    photo: 'ShoppingMall/img_approve.png',
    time: new Date('2025-06-10 10:22:06').getTime(),
  },
  {
    id: '3',
    type: 1,
    action: 2,
    status: 1,
    point: 180,
    photo: 'ShoppingMall/img_approve.png',
    time: new Date('2025-06-06 10:09:06').getTime(),
  },
  {
    id: '4',
    type: 1,
    action: 1,
    status: 1,
    point: 500,
    photo: 'ShoppingMall/img_approve.png',
    time: new Date('2025-06-06 10:01:06').getTime(),
  },
  {
    id: '5',
    type: 0,
    action: 1,
    point: 500,
    status: 1,
    photo: 'ShoppingMall/img_approve.png',
    time: new Date('2025-06-01 08:24:06').getTime(),
  },
  {
    id: '6',
    type: 0,
    action: 1,
    point: 600,
    status: 2,
    photo: 'ShoppingMall/img_approve.png',
    rejectReason: '请上传完整结账小票',
    time: new Date('2025-06-01 07:24:06').getTime(),
  },
  {
    id: '7',
    type: 1,
    action: 1,
    point: 500,
    status: 2,
    photo: 'ShoppingMall/img_approve.png',
    rejectReason: '请上传完整结账小票',
    time: new Date('2025-05-21 10:04:06').getTime(),
  },
  {
    id: '8',
    type: 1,
    action: 1,
    point: 700,
    status: 2,
    photo: 'ShoppingMall/img_approve.png',
    rejectReason: '请上传完整结账小票',
    time: new Date('2025-05-01 09:20:06').getTime(),
  }

];

export const CONSUMER_LIST: IPoint[] = [
  {
    id: '1',
    type: 1,
    time: new Date('2025-06-04').getTime(),
    action: 0,
    point: 400,
  },
  {
    id: '2',
    type: 1,
    time: new Date('2025-06-03').getTime(),
    action: 0,
    point: 800,
  },
  {
    id: '3',
    type: 1,
    time: new Date('2025-06-01').getTime(),
    action: 0,
    point: 400,
  },
  {
    id: '4',
    type: 1,
    time: new Date('2025-05-24').getTime(),
    action: 0,
    point: 800,
  },
  {
    id: '5',
    type: 1,
    time: new Date('2025-05-22').getTime(),
    action: 0,
    point: 400,
  },
  {
    id: '6',
    type: 1,
    time: new Date('2025-05-18').getTime(),
    action: 0,
    point: 800,
  },
  {
    id: '7',
    type: 1,
    time: new Date('2025-05-12').getTime(),
    action: 0,
    point: 400,
  },
  {
    id: '8',
    type: 1,
    time: new Date('2025-05-06').getTime(),
    action: 0,
    point: 800,
  },
  {
    id: '9',
    type: 1,
    time: new Date('2025-04-20').getTime(),
    action: 0,
    point: 400,
  },
  {
    id: '10',
    type: 1,
    time: new Date('2025-04-02').getTime(),
    action: 0,
    point: 800,
  },
  {
    id: '11',
    type: 1,
    time: new Date('2025-03-03').getTime(),
    action: 0,
    point: 400,
  },
];
