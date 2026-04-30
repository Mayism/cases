import { FunctionalButton, functionalButtonComponentManager } from '@kit.ScenarioFusionKit';
import { LoginUtils } from '../utils/LoginUtils';
import { LoadingDialogUtil } from './LoadingDialog';

/**
 * 登录按钮图标样式
 */
@ComponentV2
export struct LoginButtonIcon {
  @Event callback?: () => void = () => {
  };

  build() {
    Row() {
      FunctionalButton({
        params: {
          openType: functionalButtonComponentManager.OpenType.GET_PHONE_NUMBER,
          label: '',
          styleOption: {
            styleConfig: new functionalButtonComponentManager
              .ButtonConfig()
              .size({ width: 48, height: 48 })
              .backgroundImage($r('app.media.ic_tab_code_pass'))
              .backgroundImageSize(ImageSize.Cover)
              .borderRadius('50%')
          },
        },
        controller: new functionalButtonComponentManager.FunctionalButtonController()
          .onGetPhoneNumber((err, data) => {
            if (err) {
              LoginUtils.onBindFail(this.callback);
              return;
            }
            LoginUtils.onBindSuccess(data.code || '', this.callback);
          }),
      })
        .id('phoneFunctionalButtonId1')
        .onClick(() => {
          LoadingDialogUtil.openLoadingDialog();
        })
    }
  }
}

/**
 * 登录按钮文字样式
 */
@ComponentV2
export struct LoginButtonText {
  @Param label: ResourceStr = '';
  @Event callback?: () => void = () => {
  };

  build() {
    Row() {
      FunctionalButton({
        params: {
          openType: functionalButtonComponentManager.OpenType.GET_PHONE_NUMBER,
          label: this.label,
          styleOption: {
            plain: true,
            styleConfig: new functionalButtonComponentManager
              .ButtonConfig()
              .fontSize(14)
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Regular)
              .backgroundColor(Color.Transparent)
              .padding(0)
              .height(20)
          },
        },
        controller: new functionalButtonComponentManager.FunctionalButtonController()
          .onGetPhoneNumber((err, data) => {
            if (err) {
              LoginUtils.onBindFail(this.callback);
              return;
            }
            LoginUtils.onBindSuccess(data.code || '', this.callback);
          }),
      })
        .id('phoneFunctionalButtonId2')
        .onClick(() => {
          LoadingDialogUtil.openLoadingDialog();
        })
    }
  }
}