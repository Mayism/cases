import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { authentication } from '@kit.AccountKit';
import { AppStorageV2, promptAction } from '@kit.ArkUI';
import { FunctionalButton, functionalButtonComponentManager } from '@kit.ScenarioFusionKit';
import { RouterModule, RouterMap, PreferencesUtil, Logger, UserInfoModel, LoginModel, AccountUtil } from 'commonlib';
import { BaseTitle, GlobalDialog } from 'componentlib';
import { GetUserInfoResp, HttpRequestApi } from 'network';
import { QuitLoginDialog } from '../viewModels/QuitLoginDialog';
import { MainPageVM } from '../viewModels/MainPageVM';
import { maskPhone } from '../utils/Util';
import { saveAvatarToSandbox, getAvatarDisplayPath } from '../utils/AvatarUtil';

const TAG = '[MinePage]'

@Builder
export function minePageBuilder() {
  MinePage()
}

@ComponentV2
struct MinePage {
  dialog: CustomDialogController = new CustomDialogController({
    builder: QuitLoginDialog({
      cancel: () => {
        this.onCancel()
      },
      confirm: () => {
        this.onConfirm()
      },
    }),
    cancel: this.onCancel,
    autoCancel: true,
    gridCount: 4,
    customStyle: false,
    alignment: DialogAlignment.Bottom
  })
  onCancel() {
    this.dialog?.close()
  }

  onConfirm() {
    AppStorage.set<string>('userAccount', '');
  }

  build() {
    Column({space: 10}) {
      BaseTitle({
        customTitle: () => {
          this.MineTitleBuilder()
        },
      })
      Scroll() {
        Column() {
          UserMsgCard()
          HelpCenter()
        }
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top);
    }
    .width('100%')
    .height('100%')
    .padding({
      left: 12,
      right: 12,
    })
    .backgroundColor($r('app.color.bgc'));
  }

  @Builder
  MineTitleBuilder() {
    Text('我的')
      .fontSize(24)
      .fontWeight(FontWeight.Bold)
  }
}

@ComponentV2
struct UserMsgCard {
  vm: MainPageVM = MainPageVM.instance;
  @Local loading: boolean = false;
  @Local authCode: string = ''
  @Local userName: string = ''
  @Local userIconPath: string = ''
  @Local userTel: string = ''
  @Local userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Local loginInfo: LoginModel = AppStorageV2.connect(LoginModel, () => new LoginModel())!
  private filesDir: string = '';

  aboutToAppear(): void {
    this.filesDir = getContext(this).filesDir;
    this.change()
  }

  change() {
    if (this.userInfo.phoneNumber) {
      let phone = this.userInfo.phoneNumber
      this.userInfo.phoneNumber = maskPhone(phone)
    }
  }

  build() {
    Row() {
      Row() {
        if (this.loginInfo.isLogin) {
          FunctionalButton({
            params: {
              openType: functionalButtonComponentManager.OpenType.CHOOSE_AVATAR,
              label: '',
              styleOption: {
                styleConfig: new functionalButtonComponentManager.ButtonConfig()
                  .type(ButtonType.Normal)
                  .backgroundImage(getAvatarDisplayPath(this.userInfo.avatar))
                  .backgroundImageSize(ImageSize.Cover)
                  .width(64)
                  .height(64)
                  .borderRadius(32)
                  .backgroundColor('#E5E5E5')
              },
            },
            controller: new functionalButtonComponentManager.FunctionalButtonController().onChooseAvatar((err, data) => {
              if (err) {
                Logger.error(TAG, 'Choose avatar error: ' + err.message);
                return;
              }
              const avatarUri = data.avatarUri;
              if (avatarUri) {
                const sandboxPath = saveAvatarToSandbox(avatarUri, this.filesDir);
                if (sandboxPath) {
                  this.userInfo.avatar = sandboxPath;
                }
              }
            })
          })
        } else {
          Image($r('app.media.ic_default_hd'))
            .width(64)
            .height(64)
            .borderRadius(50)
        }

        Column() {
          if (this.loginInfo.isLogin) {
            Text(this.userInfo.name)
              .fontSize(`${ this.vm.changeFontSize + 18 }`)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))

            Row() {
              Image($r('app.media.icon_phone')).width(16)
              Text(this.userInfo.phoneNumber)
                .fontSize(`${ this.vm.changeFontSize + 12 }`)
                .fontColor($r('sys.color.font_secondary'))
                .margin({ left: 2 })
            }.margin({ top: 12, left: 1 })
            .visibility(this.vm.userInfo.isAssociate ? Visibility.Visible : Visibility.None)
          } else {
            Text('华为用户').fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_secondary'))
          }
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 12 })
        .onClick(() => {
          if (this.loginInfo.isLogin) {
            RouterModule.push({
              url: RouterMap.USER_INFO_SETTING
            })
          }
        })
      }

      Row() {
        Row() {
          Image(this.vm.userInfo.isAssociate ? $r('app.media.ic_relatived') : $r('app.media.connect'))
            .width(12)
            .height(12)
            .margin({ right: 4 })
          Text(this.vm.userInfo.isAssociate ? '解除关联' : '关联账号')
            .fontSize(`${ this.vm.changeFontSize + 12 }`)
            .fontColor(this.vm.userInfo.isAssociate ? $r('sys.color.font_on_primary') : $r('sys.color.comp_background_emphasize'))
        }
        .padding({
          left: 10,
          right: 10,
          top: 6,
          bottom: 6,
        })
        .borderRadius(14)
        .backgroundColor(this.vm.userInfo.isAssociate ? $r('sys.color.comp_background_emphasize') : $r('sys.color.background_secondary'))
        .onClick(() => {
          if (this.vm.userInfo.isAssociate) {
            GlobalDialog.showTextDialog({
              title: '账号解除关联',
              content: '请确认是否解除账号关联？',
              primaryButName: '确定',
              secondaryButName: '取消',
              primaryButAction: async () => {
                this.loading = true
                this.cancelRelative()
                // 关闭账号关联弹框
                await GlobalDialog.close()
                // loading弹框
                await GlobalDialog.showLoadingDialog()
              },
              secondaryButAction: () => {
                GlobalDialog.close()
              },
            })
          } else {
            // 关闭账号关联弹框
            GlobalDialog.close()
            // loading弹框
            GlobalDialog.showLoadingDialog()
            this.getQuickLoginAnonymousPhone()
          }
        })
      }
      .height('100%')
      .alignItems(VerticalAlign.Center)

    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .height(112)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius(16)
    .padding({
      left: 16,
      right: 16,
      top: 24,
      bottom: 24,
    })
  }

  getQuickLoginAnonymousPhone() {
    // 创建授权请求，并设置参数
    const authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    // 获取手机号需要传如下scope，传参数之前需要先申请对应scope权限,才能返回对应数据
    authRequest.scopes = ['phone'];
    // 获取code需传如下permission
    authRequest.permissions = ['serviceauthcode'];
    // 用户是否需要登录授权，该值为true且用户未登录或未授权时，会拉起用户登录或授权页面
    authRequest.forceAuthorization = true;
    // 用于防跨站点请求伪造
    authRequest.state = util.generateRandomUUID();
    try {
      const controller = new authentication.AuthenticationController(getContext(this));
      controller.executeRequest(authRequest).then((data) => {
        const authorizationWithHuaweiIDResponse = data as authentication.AuthorizationWithHuaweiIDResponse;
        const state = authorizationWithHuaweiIDResponse.state;
        if (state !== undefined && authRequest.state !== state) {
          Logger.error(TAG, `Failed to authorize. The state is different, response state: ${state}`)
          return;
        }
        Logger.info(TAG, 'Succeeded in authentication.')
        const authorizationWithHuaweiIDCredential = authorizationWithHuaweiIDResponse.data!;
        const code = authorizationWithHuaweiIDCredential.authorizationCode;
        this.authCode = code ?? '';
        // 开发者处理code
        if (code) {
          HttpRequestApi.getOpenLoginHm(encodeURIComponent(code)).then((res) => {
            if (res.status === 1) {
              let tel = res.userTel  as string ?? ''
              this.userInfo.phoneNumber = maskPhone(tel)
              this.userInfo.name = this.userInfo.name || res.name
              this.vm.userInfo.isAssociate = true
            } else {
              promptAction.showToast({ message: '账号关联失败，请重试~' })
            }
            GlobalDialog.close()
          }).catch(() => {
            promptAction.showToast({ message: '账号关联失败' })
            GlobalDialog.close()
          })
        } else {
          promptAction.showToast({ message: '账号关联失败' })
          GlobalDialog.close()
        }
      }).catch((err: BusinessError<Object>) => {
        // 为了不阻塞模板体验，不做失败拦截
        AccountUtil.onGetPhoneNumberFail((type) => {
          if (type === 1) {
            HttpRequestApi.getOpenLoginHm(encodeURIComponent('123')).then((res) => {
              if (res.status === 1) {
                let tel = res.userTel  as string ?? ''
                this.userInfo.phoneNumber = maskPhone(tel)
                this.userInfo.name = this.userInfo.name || res.name
                this.vm.userInfo.isAssociate = true
              } else {
                promptAction.showToast({ message: '账号关联失败，请重试~' })
              }
              GlobalDialog.close()
            })
          }
          GlobalDialog.close()
        })
      });
    } catch (error) {
      this.dealAllError(error);
    }
  }

  cancelRelative() {
    // 创建取消授权请求，并设置参数
    const cancelRequest = new authentication.HuaweiIDProvider().createCancelAuthorizationRequest();
    cancelRequest.state = util.generateRandomUUID(); // 建议使用generateRandomUUID生成state

    // 执行取消授权请求，并处理结果
    try {
      const controller = new authentication.AuthenticationController(getContext(this));
      controller.executeRequest(cancelRequest, (error: BusinessError<Object>, data) => {
        if (error) {
          // 为了不阻塞模板体验，不做失败拦截
          HttpRequestApi.getCloseLoginHm()
            .then((resp: GetUserInfoResp) => {
              this.vm.userInfo.isAssociate = false
              this.userInfo.phoneNumber = ''
              GlobalDialog.close()
            })
          return;
        }
        const cancelAuthorizationResponse = data as authentication.CancelAuthorizationResponse;
        const state = cancelAuthorizationResponse.state;
        if (state && cancelRequest.state !== state) {
          Logger.error(TAG, `Failed to cancel. The state is different, response state: ${state}`)
          return;
        }
        Logger.info(TAG, 'Succeeded in canceling.');
        HttpRequestApi.getCloseLoginHm()
          .then((resp: GetUserInfoResp) => {
            this.vm.userInfo.isAssociate = false
            this.userInfo.phoneNumber = ''
            if (resp) {
              console.info(`getCancelLoginUtil resp:${JSON.stringify(resp)}.`);
            } else {
              console.error(`getCancelLoginUtil error: ${JSON.stringify(resp)}.`);
            }
            GlobalDialog.close()
          })
          .catch((e: BusinessError) => {
            console.error(`getCancelLoginUtil error: ${JSON.stringify(e)}.`);
            GlobalDialog.close()
          })
      });
    } catch (error) {
      this.dealAllError(error);
    }
  }

  // 错误处理
  dealAllError(error: BusinessError<Object>): void {
    Logger.error(TAG, `Failed to login, errorCode is ${error.code}, errorMessage is ${error.message}`)
    promptAction.showToast({ message: '账号关联失败' })
    GlobalDialog.close()
  }
}

@ComponentV2
struct HelpCenter {
  vm: MainPageVM = MainPageVM.instance;
  @Local callTelSheet: boolean = false

  aboutToAppear(): void {
    PreferencesUtil.getChangeFontSize().then((value:number) => {
      this.vm.changeFontSize = value;
      Logger.info('setfontsize', 'Get the value of changeFontSize: ' + this.vm.changeFontSize);
    });
  }

  build() {
    Column() {
      Row() {
        Row() {
          Text('常用服务')
            .fontSize(`${ this.vm.changeFontSize + 18 }`)
            .fontColor($r('sys.color.font_primary'))
            .fontWeight(FontWeight.Bold)
        }
      }
      .width('100%')
      .padding({top: 10, bottom: 8})

      Column() {
        CardItem({
          img: $r('app.media.my_collect'),
          label: '我的收藏',
          changeFontSize: this.vm.changeFontSize,
          onClickEvent: () => {
            RouterModule.push({ url: RouterMap.HISTORY_RECORD, param: '我的收藏' });
          }
        })
        Divider().margin({ left: 28, top: 6, bottom: 6 })

        CardItem({
          img: $r('app.media.my_comment'),
          label: '我的评论',
          changeFontSize: this.vm.changeFontSize,
          onClickEvent: () => {
            //跳转到评论
            RouterModule.push({ url: RouterMap.MY_COMMENT, param: null });
          }
        })
        Divider().margin({ left: 28, top: 6, bottom: 6 })

        CardItem({
          img: $r('app.media.my_record'),
          label: '浏览记录',
          changeFontSize: this.vm.changeFontSize,
          onClickEvent: () => {
            RouterModule.push({ url: RouterMap.HISTORY_RECORD, param: '浏览记录' });
          }
        })
        Divider().margin({ left: 28, top: 6, bottom: 6 })

        CardItem({
          img: $r('app.media.my_setting'),
          label: '设置',
          changeFontSize: this.vm.changeFontSize,
          onClickEvent: () => {
            RouterModule.push({ url: RouterMap.MY_SETTINGS, param: null });
          }
        })
      }
      .padding(12)
      .margin({ top: 12 })
      .width('100%')
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .borderRadius(16)
    }.margin({ top: 16 }).alignItems(HorizontalAlign.Start)
  }
}

@ComponentV2
struct CardItem {
  @Param @Require label: ResourceStr
  @Param @Require img: ResourceStr
  @Param @Require changeFontSize: number
  @Event onClickEvent: () => void = () => {}
  vm: MainPageVM = MainPageVM.instance;

  build() {
    Row() {
      Row() {
        Image(this.img).width(24).height(24)
          .fillColor($r('sys.color.icon_primary'))
        Text(this.label)
          .fontSize(`${ this.changeFontSize + 16 }`)
          .fontColor($r('sys.color.font_primary'))
          .margin({ left: 12 })
      }
      Image($r('app.media.right_arrow')).width(16).height(16)
        .fillColor($r('sys.color.icon_primary'))
    }
    .width('100%')
    .padding({ top:14, bottom:14})
    .justifyContent(FlexAlign.SpaceBetween)
    .onClick(() => {
      this.onClickEvent?.()
    })
  }
}