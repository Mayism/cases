import { UtilLog as Logger, UtilLog } from '@hw-agconnect/util-log';
import { BusinessError } from '@kit.BasicServicesKit';
import { paymentService } from '@kit.PaymentKit';
import { WindowUtil } from 'common';
import {
  BaseResponse,
  CouponItem,
  HelpMsgResp,
  HttpCode,
  HttpRequest,
  PointRecord,
  RechargeRecord,
  UserInfoResp,
} from 'network';

const TAG = '[PersonalCenterApi]'

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


export function getHelpMsg(): Promise<Array<HelpMsgResp>> {
  return new Promise((resolve, reject) => {
    HttpRequest.getHelpMsg().then((resp: BaseResponse<Array<HelpMsgResp>>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `getHelpMsg resp:${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `getHelpMsg error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    }).catch((e: BusinessError) => {
      UtilLog.error(TAG, `getHelpMsg error: ${JSON.stringify(e)}.`);
      reject(e)
    })
  })
}

export function rechargeMoney(rechargeTierId: string): Promise<number> {
  return new Promise((resolve, reject) => {
    HttpRequest.rechargeMoney(rechargeTierId).then((resp: BaseResponse<number>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `rechargeMoney resp:${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `rechargeMoney error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    }).catch((e: BusinessError) => {
      UtilLog.error(TAG, `rechargeMoney error: ${JSON.stringify(e)}.`);
      reject(e)
    })
  })
}

export function getRechargeRecord(): Promise<Array<RechargeRecord>> {
  return new Promise((resolve, reject) => {
    HttpRequest.getRechargeRecord().then((resp: BaseResponse<Array<RechargeRecord>>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `getRechargeRecord resp:${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `getRechargeRecord error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    }).catch((e: BusinessError) => {
      UtilLog.error(TAG, `getRechargeRecord error: ${JSON.stringify(e)}.`);
      reject(e)
    })
  })
}

export function getUserInfo(): Promise<UserInfoResp> {
  return new Promise((resolve, reject) => {
    HttpRequest.getUserInfo()
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

export function purchase(): Promise<boolean> {
  return new Promise((resolve, reject) => {
    try {
      const orderStr =
        '{"app_id":"***","merc_no":"***","prepay_id":"xxx","timestamp":"1680259863114","noncestr":"1487b8a60ed9f9ecc0ba759fbec23f4f","sign":"****","auth_id":"***"}';
      paymentService.requestPayment(WindowUtil.globalUIAbilityContext, orderStr).then(() => {
        UtilLog.info(TAG, 'fzp  pay succeed');
        resolve(true)
      }).catch((error: BusinessError) => { // todo 模拟支付成功，此处应为：reject()
        resolve(true)
      })
    } catch (e) {
      Logger.error('paymentService undefined'); // todo 模拟器无法获取paymentService对象，模拟支付成功，此处应为：reject()
      resolve(true)
    }
  })
}

export function getPointList(): Promise<PointRecord[]> {
  return new Promise((resolve, reject) => {
    HttpRequest.getPointList().then((resp: BaseResponse<PointRecord[]>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `getPointList resp:${JSON.stringify(resp)}.`);
        resolve(resp.data);
      } else {
        UtilLog.error(TAG, `getPointList error: ${JSON.stringify(resp)}.`);
        reject(resp.msg);
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getPointList error: ${JSON.stringify(e)}.`);
        reject(e);
      });
  });
}