import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { UtilLog } from '@hw-agconnect/util-log';
import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import {
  Constants,
  GridRowColSetting,
  LoadingDialogUtil,
  RouterMap,
  RouterModule,
  StoreInfoModel,
  UserInfoModel
} from 'common/Index';
import * as API from '../../api/Index';
import { FunctionalButton, functionalButtonComponentManager } from '@kit.ScenarioFusionKit';
const TAG = '[HomeCardComp]'

@ComponentV2
export struct HomeCardComp {
  @Consumer('currentIndex') currentIndex: number = 0
  @Param breakpoint: string = '';
  @Local storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!;
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!;

  @Builder
  loginButtonBuilder() {
    FunctionalButton({
      params: {
        // OpenType.GET_PHONE_NUMBER表示该按钮用于快速验证手机号码。
        openType: functionalButtonComponentManager.OpenType.GET_PHONE_NUMBER,
        label: '',
        // 调整按钮样式。
        styleOption: {
          styleConfig: new functionalButtonComponentManager.ButtonConfig()
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .width(Constants.FULL_SIZE)
            .height(Constants.FULL_SIZE)
            .align(Alignment.End),
        },
      },
      // 当OpenType为GET_PHONE_NUMBER时，回调必须为onGetPhoneNumber。
      controller: new functionalButtonComponentManager.FunctionalButtonController()
        .onGetPhoneNumber((err, data) => {
          if (err) {
            // 错误日志处理。
            UtilLog.error(TAG, 'error: %{public}d %{public}s', err.code, err.message);
            // todo 未获取权限时模拟登录成功
            this.bindPhoneMock()
            return;
          }
          // 成功日志处理。
          UtilLog.info(TAG, 'succeeded in authenticating');
          // 授权码处理。
          let authorizationCode = data.code;
          LoadingDialogUtil.openLoadingDialog()
          if (authorizationCode) {
            this.login(authorizationCode)
          } else {
            promptAction.showToast({ message: '账号关联失败' })
            LoadingDialogUtil.close()
          }
        }),
    })
      .zIndex(1)
  }

  build() {
    Row({ space: 12 }) {
      Column() {
        Stack() {
          Column() {
            Column({ space: 4 }) {
              Text($r('app.string.scan'))
                .fontSize($r('sys.float.Subtitle_L'))
                .fontWeight(FontWeight.Bold)
                .fontColor($r('sys.color.font_primary'))
              Text($r('app.string.scan_desc')).fontSize($r('sys.float.Caption_M')).fontColor($r('sys.color.font_tertiary'))
            }
            .width(Constants.FULL_SIZE)
            .alignItems(HorizontalAlign.Start)
            .margin({ top: 12, left: 12 })
            .constraintSize({ maxWidth: Constants.FULL_SIZE })

            Image($r('app.media.bg_scan')).width(158).height(133).objectFit(ImageFit.Fill)
          }
          .layoutWeight(1)
          if (!this.userInfoModel.isRelative) {
            this.loginButtonBuilder()
          }
        }
        .alignContent(Alignment.BottomEnd)
        .width(Constants.FULL_SIZE)
        .height(Constants.FULL_SIZE)
      }
      .cardStyle()
      .layoutWeight(1)
      .height(208)
      .justifyContent(FlexAlign.SpaceBetween)

      Column({ space: 12 }) {
        Column() {
          Stack() {
            Column({ space: 4 }) {
              Text($r('app.string.preorder'))
                .fontSize($r('sys.float.Subtitle_L'))
                .fontWeight(FontWeight.Bold)
                .fontColor($r('sys.color.font_primary'))
              Text($r('app.string.preorder_desc'))
                .fontSize($r('sys.float.Caption_M'))
                .fontColor($r('sys.color.font_tertiary'))
            }
            .width(Constants.FULL_SIZE)
            .height(Constants.FULL_SIZE)
            .alignItems(HorizontalAlign.Start)
            .margin({ top: 12, left: 12 })
            .constraintSize({ maxWidth: Constants.FULL_SIZE, maxHeight: Constants.FULL_SIZE })

            Image($r('app.media.bg_preorder')).width(97).height(56)

            if (!this.userInfoModel.isRelative) {
              this.loginButtonBuilder()
            }

          }.alignContent(Alignment.BottomEnd).height(Constants.FULL_SIZE)
        }.cardStyle().height(98)
        .onClick(() => {
          if (this.userInfoModel.isRelative) {
            RouterModule.push(RouterMap.BOOK_PAGE)
          }
        })

        Column() {
          Stack() {
            Column({ space: 4 }) {
              Text($r('app.string.queue'))
                .fontSize($r('sys.float.Subtitle_L'))
                .fontWeight(FontWeight.Bold)
                .fontColor($r('sys.color.font_primary'))
              Text($r('app.string.queue_desc'))
                .fontSize($r('sys.float.Caption_M'))
                .fontColor($r('sys.color.font_tertiary'))
            }
            .width(Constants.FULL_SIZE)
            .height(Constants.FULL_SIZE)
            .alignItems(HorizontalAlign.Start)
            .margin({ top: 12, left: 12 })
            .constraintSize({ maxWidth: Constants.FULL_SIZE, maxHeight: Constants.FULL_SIZE })

            Image($r('app.media.bg_queue')).width(97).height(56)

            if (!this.userInfoModel.isRelative) {
              this.loginButtonBuilder()
            }

          }.alignContent(Alignment.BottomEnd).height(Constants.FULL_SIZE)
        }.cardStyle().height(98).onClick(() => {
          if (this.userInfoModel.isRelative) {
            RouterModule.push(RouterMap.QUEUE_PAGE)
          }
        })
      }.layoutWeight(1)
    }.margin({
      left: GridRowColSetting.getPageMargin(this.breakpoint),
      right: GridRowColSetting.getPageMargin(this.breakpoint),
    })
  }

  login(code: string) {
    API.getOpenLoginHm(encodeURIComponent(code)).then((res) => {
      let tel = res.userTel ?? ''
      this.userInfoModel.userInfo.userTel =
        `${tel.substring(0, tel.length - 8)}****${tel.substring(tel.length - 4)}`
      this.userInfoModel.isRelative = true
      if (!code) {
        promptAction.showToast({ message: '手机号绑定成功！当前手机号为mock数据，非华为账号真实手机号' });
      }
    }).catch(() => {
      promptAction.showToast({ message: '账号关联失败' })
    }).finally(() => {
      LoadingDialogUtil.close()
    })
  }

  async bindPhoneMock() {
    RouterModule.push<Record<string, string>>(RouterMap.CONFIRM_DIALOG,
      { 'title': '提示', 'message': '元服务未获取phone权限或用户授权，点击确定将根据openId创建一个mock账号。' },
      async (value) => {
        const result = value.result as Record<string, boolean>;
        if (result.param) {
          this.login('')
        }
      });
  }

  @Styles
  cardStyle(){
    .borderRadius(20).backgroundColor($r('sys.color.background_primary')).clip(true)
  }
}
