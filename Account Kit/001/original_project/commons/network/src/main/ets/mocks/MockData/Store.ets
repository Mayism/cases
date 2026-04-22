import {
  AppInfoResp,
  RechargeTier,
  ReductionResp,
  StoreInfoResp,
  StoreQueueInfoResp,
  TableInfoResp,
} from '../../types/Store';

const reductionList: ReductionResp[] = [{
  id: '1',
  name: '满10减1',
  full: 10,
  reduction: 1,
  type: 0,
}]

export const rechargeTierList: RechargeTier[] = [{
  id: '1',
  name: '充值100元（南京地区）',
  payMoney: 90,
  realMoney: 100,
  desc: '满100减10',
  type: 2,
}, {
  id: '2',
  name: '充值200元（不限门店）',
  payMoney: 150,
  realMoney: 200,
  desc: '满200减50',
  type: 2,
}, {
  id: '3',
  name: '充值500元（不限门店）',
  payMoney: 400,
  realMoney: 500,
  desc: '满500减100',
  type: 2,
}, {
  id: '4',
  name: '满100减10',
  payMoney: 90,
  realMoney: 100,
  desc: '满100减10',
  type: 1,
}, {
  id: '5',
  name: '满200减50',
  payMoney: 150,
  realMoney: 200,
  desc: '满200减50',
  type: 1,
}, {
  id: '6',
  name: '满300减80',
  payMoney: 220,
  realMoney: 300,
  desc: '满300减80',
  type: 1,
}, {
  id: '7',
  name: '满500减100',
  payMoney: 400,
  realMoney: 500,
  desc: '满500减100',
  type: 1,
}]

const QUEUE_INFO: StoreQueueInfoResp = {
  used: 9,
  min: 3,
  mid: 3,
  max: 3,
  now: 1,
};

const storeList: StoreInfoResp[] = [
  {
    id: '1',
    name: '餐饮店（华为路）',
    address: '南京市雨花台区华为路华为云楼',
    time1: '00:00',
    time2: '21:30',
    tel: '10000000002',
    announcement: '周年店庆全场优惠促销，优惠力度空前，进店享受全场五折优惠！！！',
    logo: 'CateringOrderTemplate/store_logo.png',
    coordinates: '31.97919489020034,118.76224773565536',
    businessLicense: 'CateringOrderTemplate/store_yyzz.png',
    foodLicense: 'CateringOrderTemplate/store_yyzz.png',
    environment: [
      'CateringOrderTemplate/store_environment1.png',
      'CateringOrderTemplate/store_environment2.png',
      'CateringOrderTemplate/store_environment3.png',
    ],
    isRest: 0,
    xyhMoney: 1,
    taste: '少糖；不要奶油奶沫；动物奶油；少糖；少糖；动物奶油；少糖；不要奶油奶沫；动物奶油',
    reductionList: reductionList,
    rechargeTier: rechargeTierList,
    privateRoom: [5, 3, 0, 4, 5, 3, 0, 4, 5, 3, 0, 4, 5, 3, 0, 4, 5, 3, 0, 4, 5, 3, 0, 4],
    diningHall: [2, 4, 6, 8, 10, 10, 10, 10, 10, 10, 10, 6, 0, 1, 6, 10, 10, 6, 3, 0, 3, 6, 8, 10],
    maxCount: 6,
    needQueue: true,
    queueInfo: QUEUE_INFO,
  }, {
  id: '2',
  name: '餐饮店（安德门大街）',
  address: '南京市雨花台区安德门大街',
  time1: '09:00',
  time2: '22:30',
  tel: '10000000003',
  announcement: '周年店庆全场优惠促销，优惠力度空前，进店享受全场五折优惠！！！',
  logo: 'CateringOrderTemplate/store_logo.png',
  coordinates: '31.97831,118.76362',
  businessLicense: 'CateringOrderTemplate/store_yyzz.png',
  foodLicense: 'CateringOrderTemplate/store_yyzz.png',
  environment: [
    'CateringOrderTemplate/store_environment1.png',
    'CateringOrderTemplate/store_environment2.png',
    'CateringOrderTemplate/store_environment3.png',
  ],
  isRest: 0,
  xyhMoney: 1,
  taste: '少糖；不要奶油奶沫；动物奶油；少糖；少糖；动物奶油；少糖；不要奶油奶沫；动物奶油',
  reductionList: reductionList,
  rechargeTier: rechargeTierList,
  privateRoom: [5, 3, 1, 4, 5, 3, 0, 4, 5, 3, 0, 4, 5, 3, 0, 4, 5, 3, 1, 4, 5, 3, 0, 4],
  diningHall: [2, 4, 6, 8, 10, 10, 10, 10, 10, 10, 10, 6, 0, 1, 6, 10, 10, 6, 3, 1, 3, 6, 8, 10],
  maxCount: 8,
  needQueue: false,
  queueInfo: QUEUE_INFO,
}, {
  id: '3',
  name: '餐饮店（安德门大街2店）',
  address: '南京市雨花台区安德门大街',
  time1: '00:00',
  time2: '23:59',
  tel: '10000000004',
  announcement: '周年店庆全场优惠促销，优惠力度空前，进店享受全场五折优惠！！！',
  logo: 'CateringOrderTemplate/store_logo.png',
  coordinates: '31.97052568354233,118.76447685976373',
  businessLicense: 'CateringOrderTemplate/store_yyzz.png',
  foodLicense: 'CateringOrderTemplate/store_yyzz.png',
  environment: [
    'CateringOrderTemplate/store_environment1.png',
    'CateringOrderTemplate/store_environment2.png',
    'CateringOrderTemplate/store_environment3.png',
  ],
  isRest: 0,
  xyhMoney: 1,
  taste: '少糖；不要奶油奶沫；动物奶油；少糖；少糖；动物奶油；少糖；不要奶油奶沫；动物奶油',
  reductionList: reductionList,
  rechargeTier: rechargeTierList,
  privateRoom: [5, 3, 0, 4, 5, 3, 0, 4, 5, 3, 0, 4, 0, 3, 0, 4, 5, 3, 0, 0, 0, 3, 0, 4],
  diningHall: [2, 4, 6, 8, 10, 10, 10, 10, 10, 10, 10, 6, 0, 1, 6, 10, 10, 6, 0, 1, 3, 6, 8, 10],
  maxCount: 6,
  needQueue: true,
  queueInfo: QUEUE_INFO,
}];

export const getStoreList = (): Array<StoreInfoResp> => {
  return storeList
};

export const getAppInfoResp = (): AppInfoResp => {
  return {
    bannerList: ['CateringOrderTemplate/good_spec_logo1.png', 'CateringOrderTemplate/good_spec_logo2.png'],
    imgBaseUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/test-1pvkp/',
    telephone: '10000000001',
  }
}

export const getTableInfoResp = (): Array<TableInfoResp> => {
  let result: Array<TableInfoResp> = [{
    id: '1',
    tableName: '1号桌',
    typeName: '小桌',
    num: 1,
    status: 0,
  }, {
    id: '2',
    tableName: '2号桌',
    typeName: '小桌',
    num: 2,
    status: 0,
  },
    {
      id: '3',
      tableName: '3号桌',
      typeName: '中桌',
      num: 3,
      status: 0,
    }, {
      id: '4',
      tableName: '4号桌',
      typeName: '中桌',
      num: 4,
      status: 0,
    },
    {
      id: '5',
      tableName: '5号桌',
      typeName: '大桌',
      num: 5,
      status: 0,
    }, {
      id: '6',
      tableName: '6号桌',
      typeName: '大桌',
      num: 6,
      status: 0,
    },
    {
      id: '7',
      tableName: '7号桌',
      typeName: '大桌',
      num: 7,
      status: 0,
    }, {
      id: '8',
      tableName: '8号桌',
      typeName: '大桌',
      num: 8,
      status: 0,
    },
    {
      id: '9',
      tableName: '9号桌',
      typeName: '大桌',
      num: 9,
      status: 0,
    }, {
      id: '10',
      tableName: '10号桌',
      typeName: '大桌',
      num: 10,
      status: 0,
    }]
  return result
}

export const getStoreInfoResp = (storeId: string): StoreInfoResp => {
  let store = getStoreList().find(item => item.id === (storeId || '1'))!
  return store
}