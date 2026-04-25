import { formBindingData, FormExtensionAbility, formInfo } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { Logger } from 'lib_common';
import { WidgetUtil } from '../utils/WidgetUtil';

const TAG: string = '[EntryFormAbility]';

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    let formId: string = want.parameters?.[formInfo.FormParam.IDENTITY_KEY] as string;
    Logger.info(TAG, `onAddForm formId: ${formId}`);
    if (formId) {
      WidgetUtil.addFormId(formId, this.context);
      WidgetUtil.publishFormId(formId, false);
    }
    return formBindingData.createFormBindingData('');
  }

  onFormEvent(formId: string, message: string) {
    Logger.info(TAG, `FormAbility onFormEvent, formId = ${formId}, message: ${JSON.stringify(message)}`);
    WidgetUtil.publishFormClick(formId);
  }

  onRemoveForm(formId: string) {
    Logger.info(TAG, `FormAbility onRemoveForm, formId = ${formId}`);
    WidgetUtil.delFormId(formId, this.context);
    WidgetUtil.publishFormId(formId, true);
  }

  onAcquireFormState(want: Want) {
    return formInfo.FormState.READY;
  }
}