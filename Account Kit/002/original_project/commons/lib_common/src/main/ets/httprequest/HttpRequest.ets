import { BusinessError } from '@kit.BasicServicesKit';
import { paymentService } from '@kit.PaymentKit';
import { common } from '@kit.AbilityKit';
import * as HttpRequestApi from './HttpRequestApi';
import { HttpCode } from '../constants/Common';
import {
  BaseResponse,
  PayRecord,
  PlateNumber,
  ShoppingMall,
  StoreGuide,
  UserInfo,
  Wallet,
} from '../models/ResponseModel';
import { Logger } from '../utils/Logger';
import { ContextUtils } from '../utils/ContextUtils';

const TAG = '[HttpRequestUtils]';

export function getShoppingMallInfo(): Promise<ShoppingMall> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.getShoppingMallInfo()
      .then((resp: BaseResponse<ShoppingMall>) => {
        if (resp.code === HttpCode.SUCCESS) {
          Logger.info(TAG, `getShoppingMallInfo resp:${JSON.stringify(resp)}.`);
          let shoppingMall = new ShoppingMall(resp.data.id, resp.data.name, resp.data.plateNum, resp.data.tel)
          resolve(shoppingMall);
        } else {
          Logger.error(TAG, `getShoppingMallInfo error: ${JSON.stringify(resp)}.`);
          reject(resp.msg);
        }
      })
      .catch((e: BusinessError) => {
        Logger.error(TAG, `getShoppingMallInfo error: ${JSON.stringify(e)}.`);
        reject(e);
      });
  });
}

export function getUserInfo(openid: string, unionId: string): Promise<UserInfo> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.getUserInfo(openid, unionId)
      .then((resp: BaseResponse<UserInfo>) => {
        if (resp.code === HttpCode.SUCCESS) {
          Logger.info(TAG, `getUserInfo resp:${JSON.stringify(resp)}.`);
          let userInfo = new UserInfo(resp.data.id, resp.data.name, resp.data.totalScore, resp.data.userTel,
            resp.data.membershipCode)
          resolve(userInfo);
        } else {
          Logger.error(TAG, `getUserInfo error: ${JSON.stringify(resp)}.`);
          reject(resp.msg);
        }
      })
      .catch((e: BusinessError) => {
        Logger.error(TAG, `getUserInfo error: ${JSON.stringify(e)}.`);
        reject(e);
      });
  });
}

export function getPayRecordList(): Promise<PayRecord[]> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.getPayRecordList().then((resp: BaseResponse<PayRecord[]>) => {
      if (resp.code === HttpCode.SUCCESS) {
        Logger.info(TAG, `getPayRecordList resp:${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        Logger.error(TAG, `getPayRecordList error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    }).catch((e: BusinessError) => {
      Logger.error(TAG, `getPayRecordList error: ${JSON.stringify(e)}.`);
      reject(e)
    })
  })
}

export function getPayDetail(plate: string): Promise<PayRecord> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.getPayDetail(plate)
      .then((resp: BaseResponse<PayRecord>) => {
        if (resp.code === HttpCode.SUCCESS && resp.data) {
          Logger.info(TAG, `getPlatePayment resp:${JSON.stringify(resp)}.`);
          resolve(resp.data)
        } else {
          Logger.error(TAG, `getPlatePayment error: ${JSON.stringify(resp)}.`);
          reject(false)
        }
      })
      .catch((e: BusinessError) => {
        Logger.error(TAG, `getPlatePayment error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function addPlateNumber(plate: string, plateColorType: string, plateKind: number): Promise<boolean> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.addPlateNumber(plate, plateColorType, plateKind)
      .then((resp: BaseResponse) => {
        if (resp.code === HttpCode.SUCCESS) {
          Logger.info(TAG, `addPlateNumber resp:${JSON.stringify(resp)}.`);
          resolve(true)
        } else {
          Logger.error(TAG, `addPlateNumber error: ${JSON.stringify(resp)}.`);
          reject(false)
        }
      })
      .catch((e: BusinessError) => {
        Logger.error(TAG, `addPlateNumber error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function deletePlateNumber(id: string): Promise<boolean> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.deletePlateNumber(id)
      .then((resp: BaseResponse) => {
        if (resp.code === HttpCode.SUCCESS) {
          Logger.info(TAG, `deletePlateNumber resp:${JSON.stringify(resp)}.`);
          resolve(true)
        } else {
          Logger.error(TAG, `deletePlateNumber error: ${JSON.stringify(resp)}.`);
          reject(false)
        }
      })
      .catch((e: BusinessError) => {
        Logger.error(TAG, `deletePlateNumber error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function queryPlateNumber(): Promise<Array<PlateNumber>> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.queryPlateNumber()
      .then((resp: BaseResponse<Array<PlateNumber>>) => {
        if (resp.code === HttpCode.SUCCESS) {
          Logger.info(TAG, `addPlateNumber resp:${JSON.stringify(resp)}.`);
          resolve(resp.data)
        } else {
          Logger.error(TAG, `addPlateNumber error: ${JSON.stringify(resp)}.`);
          reject(resp)
        }
      })
      .catch((e: BusinessError) => {
        Logger.error(TAG, `addPlateNumber error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function getCancelLogin(): Promise<UserInfo> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.getCloseLoginHm()
      .then((resp: UserInfo) => {
        if (resp) {
          Logger.info(TAG, `getCancelLoginUtil resp:${JSON.stringify(resp)}.`);
          resolve(resp)
        } else {
          Logger.error(TAG, `getCancelLoginUtil error: ${JSON.stringify(resp)}.`);
          reject(resp)
        }
      })
      .catch((e: BusinessError) => {
        Logger.error(TAG, `getCancelLoginUtil error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function getPurchase(context: common.UIAbilityContext): Promise<boolean> {
  return new Promise((resolve, reject) => {
    const orderStr =
      '{"app_id":"***","merc_no":"***","prepay_id":"xxx","timestamp":"1680259863114","noncestr":"1487b8a60ed9f9ecc0ba759fbec23f4f","sign":"****","auth_id":"***"}';
    paymentService.requestPayment(context, orderStr).then(() => {
      Logger.info(TAG, 'pay succeed');
      resolve(true)
      ContextUtils.showToast({
        message: '支付成功',
        duration: 1000,
      })

    }).catch((error: BusinessError) => {
      let payStr = $r('app.string.request_failed')
      if (error.code === HttpCode.CANCEL_PAY) {
        payStr = $r('app.string.cancel_pay')
      } else if (error.code === HttpCode.PAY_FAILED) {
        payStr = $r('app.string.pay_failed')
      } else if (error.code === HttpCode.NETWORK_ERROR) {
        payStr = $r('app.string.network_error')
      } else if (error.code === HttpCode.DUPLICATE_REQUEST) {
        payStr = $r('app.string.duplicate_request')
      }
      Logger.error(TAG, 'pay failed.error:' + error.code + payStr);
      reject(error.code)
    })
  })
}

/**
 * 隐私政策
 */
export function getPrivacyInfo(): Promise<string> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.getPrivacyInfo().then((resp: BaseResponse<string>) => {
      if (resp.code === HttpCode.SUCCESS) {
        Logger.info(TAG, `getPrivacyInfo resp:${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        Logger.error(TAG, `getPrivacyInfo error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    }).catch((e: BusinessError) => {
      Logger.error(TAG, `getPrivacyInfo error: ${JSON.stringify(e)}.`);
      reject(e)
    })
  })
}

export function getMyWalletList(): Promise<Array<Wallet>> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.getMyWalletList().then((resp: BaseResponse<Array<Wallet>>) => {
      if (resp.code === HttpCode.SUCCESS) {
        Logger.info(TAG, `getMyWalletList resp:${JSON.stringify(resp)}.`);
        let myWalletList: Array<Wallet> = []
        resp.data.forEach((item: Wallet) => {
          myWalletList.push(item)
        })
        resolve(myWalletList)
      } else {
        Logger.error(TAG, `getMyWalletList error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        Logger.error(TAG, `getApprovePoint error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}

export function getService(index: number, type: number): Promise<string> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.getService(index, type).then((resp: BaseResponse<string>) => {
      if (resp.code === HttpCode.SUCCESS) {
        Logger.info(TAG, `getService resp:${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        Logger.error(TAG, `getService error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    }).catch((e: BusinessError) => {
      Logger.error(TAG, `getService error: ${JSON.stringify(e)}.`);
      reject(e)
    })
  })
}

export function getStoreGuide(): Promise<Array<StoreGuide>> {
  return new Promise((resolve, reject) => {
    HttpRequestApi.getStoreGuide().then((resp: BaseResponse<Array<StoreGuide>>) => {
      if (resp.code === HttpCode.SUCCESS) {
        Logger.info(TAG, `getStoreGuide resp:${JSON.stringify(resp)}.`);
        let list: Array<StoreGuide> = []
        resp.data.forEach((item: StoreGuide) => {
          list.push(new StoreGuide(item.id, item.logo, item.name, item.bigImage, item.location, item.floor, item.tag,
            item.tel, item.introduce))
        })
        resolve(list)
      } else {
        Logger.error(TAG, `getStoreGuide error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    }).catch((e: BusinessError) => {
      Logger.error(TAG, `getStoreGuide error: ${JSON.stringify(e)}.`);
      reject(e)
    })
  })
}
