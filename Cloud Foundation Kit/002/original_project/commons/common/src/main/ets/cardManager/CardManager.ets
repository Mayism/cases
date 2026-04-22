import { UtilLog as Logger } from '@hw-agconnect/util-log';
import { BusinessError } from '@kit.BasicServicesKit';
import { formBindingData, formProvider } from '@kit.FormKit';
import preferences from '@ohos.data.preferences';
import { PreferenceUtil } from '../utils/PreferenceUtil';
import { WindowUtil } from '../utils/WindowUtil';

export class FormDataClass {
  // 卡片类型 2：2*2  3：2*4
  formDimension: number = 0
  // 店铺名称
  storeName: ResourceStr = ''
  // 是否已下单
  orderState: boolean = false
  // 订单id
  orderId: string = ''
  // 下单时间
  orderTime: string = ''
  // 下单类型 1堂食  2外带
  orderType: number = 1
  // 堂食店铺桌号
  storeTable: string = ''
  // 外带取餐码
  orderPickNum: string = ''
  // 2*4卡片状态 1订座  2排号  3下单
  stateType: number = 0
  // 排队桌号
  queueTable: string = ''
  // 排队等待时间
  queueWaitTime: string = ''
  // 排队等待桌数
  queueWaitNum: number = 0
  // 订座是否为包间
  preorderRoom: boolean = false
  // 订座时间
  preorderTime: string = ''

  constructor(formDimension?: number) {
    if (formDimension) {
      this.formDimension = formDimension
    }
  }
}

export interface CardInfo {
  formId: string
  formDimension: number
}

export class CardManager {
  static KEY_CARD_ID = 'card_id'
  static KEY_CARD_INFO = 'card_data'
  private static instance: CardManager = new CardManager()

  static get(): CardManager {
    return CardManager.instance
  }

  public getCardInfoArray(context?: Context): Array<string> {
    let ctx = context || WindowUtil.globalUIAbilityContext
    try {
      preferences.removePreferencesFromCacheSync(ctx, { name: 'default' })
      return PreferenceUtil.getInstance(ctx).get(CardManager.KEY_CARD_ID) as Array<string>
    } catch (e) {
      Logger.error(`updateCard failed. getCardInfoArray error. ${e}`)
      return []
    }
  }

  public createFormData(data: FormDataClass): formBindingData.FormBindingData {
    return formBindingData.createFormBindingData(data);
  }

  public removeCard(formId: string, context: Context) {
    let cardIdArray = this.getCardInfoArray(context)
    if (!formId || !cardIdArray.length) {
      return
    }
    let cardInfoArr: Array<string> = cardIdArray
    let card = cardInfoArr.find(item => {
      let cardInfo: CardInfo = JSON.parse(item || '{}') as CardInfo
      return cardInfo.formId === formId
    })
    Logger.info(`removeCard start. formId:${formId}, cardInfo:${card}`)
    PreferenceUtil.getInstance(context).removeFromArray(CardManager.KEY_CARD_ID, card || '')
  }

  async updateCard(formData: FormDataClass, formId?: string, context?: Context) {
    Logger.info(`updateCard start. formData:${JSON.stringify(formData)}, formId:${formId}`)
    let cardIdArray: string[] = this.getCardInfoArray(context)
    if (!cardIdArray?.length) {
      Logger.info(`updateCard failed. formId is empty. ${JSON.stringify(cardIdArray)}`)
      return
    }
    Logger.info(`formId:${JSON.stringify(cardIdArray)}`)
    if (!formData) {
      formData = new FormDataClass()
    }
    let cardInfoArr: Array<string> = cardIdArray
    let formDimension = formData.formDimension
    for (let cardInfoStr of cardInfoArr) {
      let cardInfo: CardInfo = JSON.parse(cardInfoStr || '{}') as CardInfo
      // formid不存在不同步 2.有formid为刷新场景，过滤预约卡片  3。根据尺寸定向同步卡片
      if (!cardInfo.formId || (formId && cardInfo.formId !== formId) ||
        (formDimension && cardInfo.formDimension !== formDimension)) {
        continue
      }
      formData.formDimension = cardInfo.formDimension
      let formInfo = this.createFormData(formData);
      formProvider.updateForm(cardInfo.formId, formInfo).then(() => {
        Logger.info(`updateForm success. formData:${JSON.stringify(formData)},formId:${cardInfo.formId}`)
      }).catch((error: BusinessError) => {
        Logger.error(`Operation updateForm failed. formData:${JSON.stringify(formData)},formId:${cardInfo.formId}. Cause: ${JSON.stringify(error)}`);
      })
    }
  }
}