import { ExtensionAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import formBindingData from '@ohos.app.form.formBindingData';
import formProvider from '@ohos.app.form.formProvider';

const DOMAIN = 0x0000;
const TAG = 'WidgetAbility';

export default class WidgetAbility extends ExtensionAbility {
  onAddForm(want: Want): formBindingData.FormBindingData {
    hilog.info(DOMAIN, TAG, 'onAddForm');
    return formBindingData.createFormBindingData({
      title: '课程助手',
      homeAction: 'GO_TO_HOME_PAGE',
      checkinAction: 'GO_TO_CHECKIN_PAGE'
    });
  }

  onUpdateForm(formId: string): void {
    hilog.info(DOMAIN, TAG, 'onUpdateForm, formId: %{public}s', formId);
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData({
      title: '课程助手',
      homeAction: 'GO_TO_HOME_PAGE',
      checkinAction: 'GO_TO_CHECKIN_PAGE'
    });
    formProvider.updateForm(formId, formData);
  }

  onRemoveForm(formId: string): void {
    hilog.info(DOMAIN, TAG, 'onRemoveForm, formId: %{public}s', formId);
  }
}