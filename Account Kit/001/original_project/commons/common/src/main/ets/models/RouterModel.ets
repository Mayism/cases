export interface HwMapModel {
  latitude: number,
  longitude: number,
}

export interface HomePageRouter {
  index: number,
  storeId: string,
  orderId: string,
}

export interface OrderDetailRouter {
  orderId: string,
  isOrderJump: boolean
  index: number
}

export interface CouponRouter {
  totalMoney: number,
  selectId: string,
  reduce: number,
}

export interface RemarksRouter {
  remarks: string,
}

export interface ImageRouter {
  imageSrc: string;
}

export interface FormCardJump {
  id: number,
  url: string,
  params: OrderDetailRouter,
}

export interface ConfirmDialogOption {
  title: string;
  message: string;
}
