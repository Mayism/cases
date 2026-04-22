import { UtilLog } from '@hw-agconnect/util-log';
import { AppStorageV2 } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { MyCar, MyCarModel, PackageSpec, StoreInfo, StoreInfoModel } from 'common';
import {
  AppInfoResp,
  BaseResponse,
  CouponItem,
  DishesTypeResp,
  GoodsResp,
  GoodsSpecResp,
  HttpCode,
  HttpRequest,
  MyCarResp,
  MyOrderResp,
  StoreInfoResp,
  TableInfoResp,
  UserInfoResp,
} from 'network';
import { storeInfoMapper } from '../mapper/Index';
import { Goods } from '../models/Index';

const TAG = '[PhoneApi]'

export function getAppInfo(): Promise<AppInfoResp> {
  return new Promise((resolve, reject) => {
    HttpRequest.getAppInfo()
      .then((resp: BaseResponse<AppInfoResp>) => {
        if (resp.code === HttpCode.SUCCESS) {
          UtilLog.info(TAG, `getAppInfo resp:${JSON.stringify(resp)}.`);
          resolve(resp.data)
        } else {
          UtilLog.error(TAG, `getAppInfo error: ${JSON.stringify(resp)}.`);
          reject(resp)
        }
      })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getAppInfo error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function getTableList(): Promise<Array<TableInfoResp>> {
  return new Promise((resolve, reject) => {
    HttpRequest.getTableList()
      .then((resp: BaseResponse<Array<TableInfoResp>>) => {
        if (resp.code === HttpCode.SUCCESS) {
          UtilLog.info(TAG, `getTableList resp:${JSON.stringify(resp)}.`);
          resolve(resp.data)
        } else {
          UtilLog.error(TAG, `getTableList error: ${JSON.stringify(resp)}.`);
          reject(resp)
        }
      })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getTableList error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function getStoreList(): Promise<Array<StoreInfo>> {
  return new Promise((resolve, reject) => {
    HttpRequest.getStoreList()
      .then((resp: BaseResponse<Array<StoreInfoResp>>) => {
        if (resp.code === HttpCode.SUCCESS) {
          UtilLog.info(TAG, `getStoreInfo resp:${JSON.stringify(resp)}.`);
          let storeList = resp.data.map((item): StoreInfo => storeInfoMapper(item))
          resolve(storeList)
        } else {
          UtilLog.error(TAG, `getStoreInfo error: ${JSON.stringify(resp)}.`);
          reject(resp)
        }
      })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getStoreInfo error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function getStoreInfo(storeId: string): Promise<StoreInfo> {
  return new Promise((resolve, reject) => {
    HttpRequest.getStoreInfo(storeId)
      .then((resp: BaseResponse<StoreInfoResp>) => {
        if (resp.code === HttpCode.SUCCESS) {
          UtilLog.info(TAG, `getStoreInfo resp:${JSON.stringify(resp)}.`);
          resolve(storeInfoMapper(resp.data))
        } else {
          UtilLog.error(TAG, `getStoreInfo error: ${JSON.stringify(resp)}.`);
          reject(resp)
        }
      })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getStoreInfo error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function getMyCoupons(): Promise<Array<CouponItem>> {
  return new Promise((resolve, reject) => {
    HttpRequest.getMyCoupons().then((resp: BaseResponse<Array<CouponItem>>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `getMyCoupons resp:${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `getMyCoupons error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getMyCoupons error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function getLqCoupons(couponId: string): Promise<number> {
  return new Promise((resolve, reject) => {
    HttpRequest.getLqCoupons(couponId).then((resp: BaseResponse<number>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `getLqCoupons resp:${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `getLqCoupons error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getLqCoupons error: ${JSON.stringify(e)}.`);
        reject()
      })
  })
}

export function getGoodInfo(goodsId: string = ''): Promise<GoodsResp> {
  return new Promise((resolve, reject) => {
    if (!goodsId) {
      UtilLog.error(TAG, `getGoodInfo error. goodsId is empty: ${JSON.stringify(goodsId)}.`);
      reject(`getGoodInfo error. goodsId is empty: ${JSON.stringify(goodsId)}.`)
      return
    }
    HttpRequest.getGoodInfo(goodsId).then((resp: BaseResponse<GoodsResp>) => {
      if (resp.code === HttpCode.SUCCESS) {
        resolve(resp.data)
        UtilLog.info(TAG, `getGoodInfo resp:${JSON.stringify(resp)}.`);
      } else {
        UtilLog.error(TAG, `getGoodInfo error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getGoodSpec error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function getGoodSpec(goodsId: string = '', selectSpecArr: PackageSpec[]): Promise<GoodsSpecResp> {
  return new Promise((resolve, reject) => {
    if (!goodsId || !selectSpecArr) {
      UtilLog.error(TAG, ' goodsId or selectSpecArr is empty!');
      reject(' goodsId or selectSpecArr is empty!')
      return
    }
    HttpRequest.getGoodSpec(goodsId, selectSpecArr).then((resp: BaseResponse<GoodsSpecResp>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `getGoodSpec resp:${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `getGoodSpec error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getGoodSpec error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function addCarSpec(selectSpecInfo: GoodsSpecResp, goodsId: string | undefined,
  num: number = 1): Promise<number> {
  return new Promise((resolve, reject) => {
    if (!goodsId) {
      UtilLog.error(TAG, `addCarSpec error.goodsId is empty.`);
      reject(`addCarSpec error.goodsId is empty.`)
      return
    }
    HttpRequest.addCarBySpec(goodsId, selectSpecInfo, num).then((resp: BaseResponse<number>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `addCarSpec resp:${JSON.stringify(resp)}.`);
        getMyCar()
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `addCarSpec error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `addCarSpec error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function getMyCar(): Promise<MyCar> {
  return new Promise((resolve, reject) => {
    HttpRequest.getMyCar().then((resp: BaseResponse<MyCarResp>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `getMyCar resp:${JSON.stringify(resp)}.`);
        let myCarModel: MyCarModel = AppStorageV2.connect(MyCarModel, () => new MyCarModel())!
        myCarModel.myCar.update(resp.data)
        resolve(myCarModel.myCar)
      } else {
        UtilLog.error(TAG, `getMyCar error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getMyCar error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function addCar(goods: Goods, num: number = 1): Promise<number> {
  return new Promise((resolve, reject) => {
    HttpRequest.addCar(goods, num).then((resp: BaseResponse<number>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `addCar resp:${JSON.stringify(resp)}.`);
        getMyCar()
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `addCar error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `addCar error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function updateMyCar(carId: string, num: number): Promise<number> {
  return new Promise((resolve, reject) => {
    HttpRequest.updateMyCar(carId, num).then((resp: BaseResponse<number>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `updateMyCar resp:${JSON.stringify(resp)}.`);
        getMyCar()
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `updateMyCar error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `updateMyCar error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function getCouponList(): Promise<Array<CouponItem>> {
  return new Promise((resolve, reject) => {
    HttpRequest.getCoupons().then((resp: BaseResponse<Array<CouponItem>>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `getCouponList resp:${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `getCouponList error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getCouponList error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function clearCar(): Promise<number> {
  return new Promise((resolve, reject) => {
    HttpRequest.clearMyCar()
      .then((resp: BaseResponse<number>) => {
        if (resp.code === HttpCode.SUCCESS) {
          UtilLog.info(TAG, `clearCarUtil resp:${JSON.stringify(resp)}.`);
          getMyCar()
          resolve(resp.data)
        } else {
          UtilLog.error(TAG, `clearCarUtil error: ${JSON.stringify(resp)}.`);
          reject(resp)
        }
      })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `clearCarUtil error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}


export function getDishesList(): Promise<Array<DishesTypeResp>> {
  return new Promise((resolve, reject) => {
    let storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!;
    if (!storeModel.storeId) {
      UtilLog.error(TAG, 'storeId is empty!');
      reject('storeId is empty!')
      return
    }
    HttpRequest.getDishesList(storeModel.storeId)
      .then((resp: BaseResponse<Array<DishesTypeResp>>) => {
        if (resp.code === HttpCode.SUCCESS) {
          UtilLog.info(TAG, `getDishesList resp:${JSON.stringify(resp)}.`);
          resolve(resp.data)
        } else {
          UtilLog.error(TAG, `getDishesList error: ${JSON.stringify(resp)}.`);
        }
      })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getDishesList error: ${JSON.stringify(e)}.`);
      })
  })
}

export function getMyOrder(page: number = 0, tab: Array<number>): Promise<Array<MyOrderResp>> {
  return new Promise((resolve, reject) => {
    HttpRequest.getMyOrder(page, tab).then((resp: BaseResponse<Array<MyOrderResp>>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `getMyOrder resp:${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `getMyOrder error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    }).catch((e: BusinessError) => {
      UtilLog.error(TAG, `getMyOrder error: ${JSON.stringify(e)}.`);
      reject(e)
    })
  })
}

export function addGoods(orderId: string): Promise<number> {
  return new Promise((resolve, reject) => {
    HttpRequest.addGoods(orderId).then((resp: BaseResponse<number>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `addGoods resp:${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `addGoods error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `addGoods error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function cancelOrder(orderId: string): Promise<number> {
  return new Promise((resolve, reject) => {
    HttpRequest.cancelOrder(orderId)
      .then((resp: BaseResponse<number>) => {
        if (resp.code === HttpCode.SUCCESS) {
          UtilLog.info(TAG, `cancelOrder resp：${JSON.stringify(resp)}.`);
          resolve(resp.data)
        } else {
          UtilLog.error(TAG, `cancelOrder error: ${JSON.stringify(resp)}.`);
          reject(resp)
        }
      })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `cancelOrder error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function deleteOrder(orderId: string): Promise<number> {
  return new Promise((resolve, reject) => {
    HttpRequest.deleteOrder(orderId).then((resp: BaseResponse<number>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `deleteOrder resp：${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `deleteOrder error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `deleteOrder error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function getHuaweiPayInfo(orderId: string = ''): Promise<number> {
  return new Promise((resolve, reject) => {
    HttpRequest.getHuaweiPayInfo(orderId).then((resp: BaseResponse<number>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `getHuaweiPayInfo resp：${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `getHuaweiPayInfo error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getHuaweiPayInfo error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function getOpenLoginHm(code: string): Promise<UserInfoResp> {
  return new Promise((resolve, reject) => {
    HttpRequest.getOpenLoginHm(encodeURIComponent(code)).then((resp: BaseResponse<UserInfoResp>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `getOpenLoginHm resp:${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `getOpenLoginHm error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getOpenLoginHm error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function getCancelLogin(): Promise<UserInfoResp> {
  return new Promise((resolve, reject) => {
    HttpRequest.getCloseLoginHm()
      .then((resp: BaseResponse<UserInfoResp>) => {
        if (resp.code === HttpCode.SUCCESS) {
          UtilLog.info(TAG, `getCancelLogin resp:${JSON.stringify(resp)}.`);
          resolve(resp.data)
        } else {
          UtilLog.error(TAG, `getCancelLogin error: ${JSON.stringify(resp)}.`);
          reject(resp)
        }
      })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getCancelLogin error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function getUserInfo(storeId?: string, unionId?: string, isRelative?:boolean): Promise<UserInfoResp> {
  return new Promise((resolve, reject) => {
    HttpRequest.getUserInfo(storeId, unionId, isRelative)
      .then((resp: BaseResponse<UserInfoResp>) => {
        if (resp.code === HttpCode.SUCCESS) {
          UtilLog.info(TAG, `getUserInfo resp:${JSON.stringify(resp)}.`);
          resolve(resp.data);
        } else {
          UtilLog.error(TAG, `getUserInfo error: ${JSON.stringify(resp)}.`);
          reject(resp.msg);
        }
      })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getUserInfo error: ${JSON.stringify(e)}.`);
        reject(e);
      });
  });
}