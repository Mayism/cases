import { UtilLog } from '@hw-agconnect/util-log';
import { Want } from '@kit.AbilityKit';
import { formBindingData, FormExtensionAbility, formInfo } from '@kit.FormKit';
import { CardInfo, CardManager, FormDataClass, PreferenceUtil } from 'common';
import { HttpRequest, OrderUtil } from 'network';

const TAG: string = '[EntryFormAbility]';

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    // Called to return a FormBindingData object.
    let formId: string = ''
    let formDimension = 2
    if (want?.parameters) {
      formId = want.parameters[formInfo.FormParam.IDENTITY_KEY] as string
      // 获取卡片类型
      formDimension = want.parameters[formInfo.FormParam.DIMENSION_KEY] as number
    }
    let cardInfo: CardInfo = { formId, formDimension };
    try {
      PreferenceUtil.getInstance(this.context).putToArray('card_id', JSON.stringify(cardInfo))
    } catch (e) {
      UtilLog.error(TAG, `onAddForm error: ${e}`);
    }
    let formData = new FormDataClass(formDimension);
    return formBindingData.createFormBindingData(formData);
  }

  onCastToNormalForm(formId: string) {
    UtilLog.error(TAG, 'onCastToNormalForm error.')
  }

  onUpdateForm(formId: string) {
    // Called to notify the form provider to update a specified form.
    UtilLog.info(TAG, 'onUpdateForm start:', formId)
    CardManager.get().updateCard(new FormDataClass(), formId, this.context)
    UtilLog.info(TAG, 'onUpdateForm end', formId)
  }

  onFormEvent(formId: string, message: string) {
    OrderUtil.setContext(this.context)
    UtilLog.info(TAG, `FormAbility onFormEvent, formId = ${formId}, message: ${JSON.stringify(message)}`);
    let msgParams: Record<string, string> = JSON.parse(message)
    if (msgParams.type === '1') {
      HttpRequest.cancelBookOrderApi(Number(msgParams.orderId)).then(res => {
        UtilLog.info(TAG, `FormAbility onFormEvent cancelBookOrderApi, res = ${JSON.stringify(res)}}`);
        CardManager.get().updateCard(new FormDataClass(), formId, this.context)
      })
    } else if (msgParams.type === '2') {
      HttpRequest.cancelQueueOrderApi(Number(msgParams.orderId)).then(res => {
        UtilLog.info(TAG, `FormAbility onFormEvent cancelQueueOrderApi, res = ${JSON.stringify(res)}}`);
        CardManager.get().updateCard(new FormDataClass(), formId, this.context)
      })
    }
  }

  onRemoveForm(formId: string) {
    // Called to notify the form provider that a specified form has been destroyed.
    try {
      CardManager.get().removeCard(formId, this.context)
    } catch (e) {
      UtilLog.error(TAG, `[EntryFormAbility] onRemoveForm error: ${e}`);
    }
  }

  onAcquireFormState(want: Want) {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
};