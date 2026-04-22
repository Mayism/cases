import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { UtilLog } from '@hw-agconnect/util-log';
import { AppStorageV2 } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { paymentService } from '@kit.PaymentKit';
import { CarGoodsInfo, CouponItem } from 'base_ui';
import { myCarMapper, MyCarModel, OrderTypeEnum, PackageSpec, StoreInfoModel, WindowUtil } from 'common';
import {
  AddDnOrderReq,
  BaseResponse,
  GoodsReq,
  GoodsResp,
  GoodsSpecResp,
  HttpCode,
  HttpRequest,
  MyCarResp,
  UserInfoResp,
} from 'network';
import { Goods } from '../models/Index';

const TAG = '[OrderApi]'

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


export function addDnOrder(list: Array<CarGoodsInfo>, params: AddDnOrderReq): Promise<number> {
  return new Promise((resolve, reject) => {
    let sz: Array<GoodsReq> = list?.map((carGood: CarGoodsInfo) => {
      let goodsReq: GoodsReq = {
        id: carGood.goodsId,
        img: carGood.logo,
        money: carGood.money,
        name: carGood.name,
        num: carGood.num,
        spec: carGood.spec,
        combination: carGood.combination,
      }
      return goodsReq
    })
    let storeInfo: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!
    let req: AddDnOrderReq = {
      tableId: storeInfo.tableId,
      money: params.money,
      reductionMoney: params.reductionMoney,
      discount: '0',
      mjMoney: params.mjMoney,
      xyhMoney: params.xyhMoney,
      note: params.note,
      payType: params.payType,
      sz: JSON.stringify(sz),
      tableware: storeInfo.dinerNum,
      yhqMoney: params.yhqMoney ?? 0,
      couponId: params.couponId,
      redeemedPoint: params.redeemedPoint,
      orderType: params.orderType,
      boxMoney: params.orderType === OrderTypeEnum.DINE_IN ? 0 : params.boxMoney, // orderType为0堂食，无打包费；为4外带，有打包费
      rechargeId: params.rechargeId,
      preorderTime: params.preorderTime,
      preorderPhone: params.preorderPhone,
      storeName: storeInfo.storeInfo.name,
      storeLogo: storeInfo.storeInfo.logo,
      storeTel: storeInfo.storeInfo.tel,
      storeAddress: storeInfo.storeInfo.address,
    }
    HttpRequest.addDnOrder(req).then((resp: BaseResponse<number>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `AddDnOrder resp:${JSON.stringify(resp)}.`);
        getMyCar()
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `AddDnOrder error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `AddDnOrder error: ${JSON.stringify(e)}.`);
        reject(e)
      })
  })
}


export function clearCar(): Promise<number> {
  return new Promise((resolve, reject) => {
    HttpRequest.clearMyCar()
      .then((resp: BaseResponse<number>) => {
        if (resp.code === HttpCode.SUCCESS) {
          UtilLog.info(TAG, `clearCar resp:${JSON.stringify(resp)}.`);
          getMyCar()
          resolve(resp.data)
        } else {
          UtilLog.error(TAG, `clearCar error: ${JSON.stringify(resp)}.`);
          reject(resp)
        }
      })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `clearCar error: ${JSON.stringify(e)}.`);
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

export function getIsNew(): Promise<number> {
  return new Promise((resolve, reject) => {
    HttpRequest.getIsNew().then((resp: BaseResponse<number>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `getIsNew resp:${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `getIsNew error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getIsNew error: ${JSON.stringify(e)}.`);
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

export function purchase(defaultSuccess: boolean = false): Promise<boolean> {
  return new Promise((resolve, reject) => {
    const orderStr =
      '{"app_id":"***","merc_no":"***","prepay_id":"xxx","timestamp":"1680259863114","noncestr":"1487b8a60ed9f9ecc0ba759fbec23f4f","sign":"****","auth_id":"***"}';
    paymentService.requestPayment(WindowUtil.globalUIAbilityContext, orderStr).then(() => {
      UtilLog.info(TAG, 'fzp  pay succeed');
      resolve(true)
      promptAction.showToast({
        message: '支付成功',
        duration: 1000,
      })

    }).catch((error: BusinessError) => {
      UtilLog.error(TAG, 'fzp  pay failed.error:' + error.code);
      if (defaultSuccess) {
        // todo 支付失败处理，模板默认成功
        resolve(true)
      } else {
        let payStr = '请求失败'
        if (error.code === HttpCode.CANCEL_PAY) {
          payStr = '取消支付'
        } else if (error.code === HttpCode.PAY_FAILED) {
          payStr = '支付失败'
        } else if (error.code === HttpCode.NETWORK_ERROR) {
          payStr = '网络链接异常'
        } else if (error.code === HttpCode.DUPLICATE_REQUEST) {
          payStr = '重复请求'
        }
        promptAction.showToast({
          message: payStr,
          duration: 1000,
        })
        reject(error.code)
      }

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

export function getSnackSizedDeal(): Promise<Array<GoodsResp>> {
  return new Promise((resolve, reject) => {
    HttpRequest.getSnackSizedDeal().then((resp: BaseResponse<Array<GoodsResp>>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `getSnackSizedDeal resp:${JSON.stringify(resp)}.`);
        resolve(resp.data)
      } else {
        UtilLog.error(TAG, `getSnackSizedDeal error: ${JSON.stringify(resp)}.`);
        reject(resp)
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `getSnackSizedDeal error: ${JSON.stringify(e)}.`);
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

export function checkPoint(): Promise<boolean> {
  return new Promise((resolve, reject) => {
    HttpRequest.checkPoint().then((resp: BaseResponse<boolean>) => {
      if (resp.code === HttpCode.SUCCESS) {
        UtilLog.info(TAG, `checkPoint resp:${JSON.stringify(resp)}.`);
        resolve(resp.data);
      } else {
        UtilLog.error(TAG, `checkPoint error: ${JSON.stringify(resp)}.`);
        reject(resp.msg);
      }
    })
      .catch((e: BusinessError) => {
        UtilLog.error(TAG, `checkPoint error: ${JSON.stringify(e)}.`);
        reject(e);
      });
  });
}