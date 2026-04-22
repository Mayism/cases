import { BaseResponse, HttpCode, HttpRequest, MyCarResp, MyOrderResp } from 'network';
import { BusinessError } from '@kit.BasicServicesKit';
import { AppStorageV2 } from '@kit.ArkUI';
import { myCarMapper, MyCarModel } from 'common';
import { UtilLog } from '@hw-agconnect/util-log';

const TAG = '[OrderListApi]'

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

export function getMyCar(): Promise<MyCarResp> {
  return new Promise((resolve, reject) => {
    HttpRequest.getMyCar().then((resp: BaseResponse<MyCarResp>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `getMyCar resp:${JSON.stringify(resp)}.`);
        let myCarModel: MyCarModel = AppStorageV2.connect(MyCarModel, () => new MyCarModel())!
        myCarModel.myCar = myCarMapper(resp.data)
        resolve(resp.data)
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

export function getOrderInfo(orderId: string = ''): Promise<MyOrderResp> {
  return new Promise((resolve, reject) => {
    HttpRequest.getOrderInfo(orderId).then((resp: BaseResponse<MyOrderResp>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `getOrderInfo resp：${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `getOrderInfo error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getOrderInfo error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}
