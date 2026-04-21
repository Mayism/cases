import { BusinessError, pasteboard } from '@kit.BasicServicesKit';
import {
  GetTableInfoResp,
  GetUserInfoResp,
  PackageSpec,
} from '../models/ResponseModel';
import * as HttpRequestApi from '../axiosHttpRequest/HttpRequestApi';
import { call } from '@kit.TelephonyKit';
import { promptAction } from '@kit.ArkUI';
import { paymentService } from '@kit.PaymentKit';
import { common } from '@kit.AbilityKit';
import { HttpCode, OrderTypeEnum } from '../constants/Common';

export function getCancelLoginUtil(): Promise<GetUserInfoResp> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.getCloseLoginHm()
      .then((resp: GetUserInfoResp) => {
        if (resp) {
          console.info(`getCancelLoginUtil resp:${JSON.stringify(resp)}.`);
          resolve(resp)
        } else {
          console.error(`getCancelLoginUtil error: ${JSON.stringify(resp)}.`);
          reject(resp)
        }
      })
      .catch((e: BusinessError) => {
        console.error(`getCancelLoginUtil error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}


export function getTableInfoUtil(tableId: string): Promise<GetTableInfoResp> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.getTableInfo(tableId)
      .then((resp: GetTableInfoResp) => {
        if (resp) {
          console.info(`getTableInfo resp：${JSON.stringify(resp)}.`);
          resolve(resp)
        } else {
          console.error(`getTableInfo error: ${JSON.stringify(resp)}.`);
          reject(resp)
        }
      })
      .catch((e: BusinessError) => {
        console.error(`getTableInfo error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}


export function getLqCouponsUtil(couponId: string): Promise<number> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.getLqCoupons(couponId).then((resp: number) => {
      if (resp === HttpCode.SUCCESS) {
        console.info(`getLqCouponsUtil resp:${JSON.stringify(resp)}.`);
        resolve(resp)
      } else {
        console.error(`getLqCouponsUtil error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        console.error(`getLqCouponsUtil error: ${JSON.stringify(e)}.`);
        reject()
      })
  })
}


export function cancelOrderUtil(orderId: string): Promise<number> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.cancelOrder(orderId)
      .then((resp: number) => {
        if (resp) {
          console.info(`cancelOrder resp：${JSON.stringify(resp)}.`);
          resolve(resp)
        } else {
          console.error(`cancelOrder error: ${JSON.stringify(resp)}.`);
          reject(resp)
        }
      })
      .catch((e: BusinessError) => {
        console.error(`cancelOrder error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}
