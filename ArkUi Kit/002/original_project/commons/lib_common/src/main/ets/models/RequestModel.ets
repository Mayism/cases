export interface CommonReq {
  id: string;
  storeId: string;
  userId: string;
  name: string;
  // 车牌号
  plate: string;
  // 还需支付的停车费
  extraPay: string;
  type: string|number;
  plateKind: number;
  code: string;
  packageName: string;
  openId: string;
  unionId: string;
  index: number;
}