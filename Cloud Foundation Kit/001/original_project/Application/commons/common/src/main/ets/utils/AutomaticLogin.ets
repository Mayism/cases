import { AccountUtils, UserInfo } from 'automatic_association_count';
import { CloudFunction } from '../cloudFunction/CloudFunction';
import { CloudFunctionUserResult } from '../model/CommonInterface';
import { commonToast } from './Toast';
import { BusinessError } from '@kit.BasicServicesKit';
import { PersistenceV2, promptAction } from '@kit.ArkUI';
import { UserState } from '../loginModel/LoginModel';

export class AutomaticQuickLogin {
  userState: UserState = PersistenceV2.connect(UserState, () => new UserState())!;

  public quickLogin() {
    AccountUtils.getQuickLoginAnonymousPhone(getContext(this), (code: string) => {
      this.onLogin(code)
    })
  }

  public mockLogin() {
    commonToast.show({
      type: 'dialog',
      hasTitle: '提示',
      message: '未正确配置账号信息，是否使用mock登录',
      confirmAction: () => {
        this.userState.isLogin = true
        this.userState.userInfo = {
          authCode: '',
          avatar: 'app.media.avatar_grey',
          idToken: '',
          phoneNumber: '123xxx456',
          userName: '华为用户',
        }
        commonToast.hide()
      },
    })
  }

  public onLogin(code: string) {
    /*
     * 获取到unionID以及idToken之后，使用云函数获取用户信息
     * 云函数、云数据库开发指导 https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/cloudfoundation-introduction-V5
     * 已获取到的unionID为例
     * */
    if (code === 'err') {
      this.mockLogin()
      return
    }
    commonToast.show({
      type: 'loading',
    })
    CloudFunction.getUserInfo(code).then((userInfo) => {
      if ((userInfo as CloudFunctionUserResult).result.ret.code === 0) {
        let userInfoRes: UserInfo = (userInfo as CloudFunctionUserResult).result.result[0]
        userInfoRes.userName = userInfoRes.userName ? userInfoRes.userName : '华为用户'
        this.userState.isLogin = true
        this.userState.userInfo = userInfoRes
      }
    }).catch((err: BusinessError) => {
      promptAction.showToast({ message: '获取用户信息失败！' })
    }).finally(() => {
      commonToast.hideAll()
    })
  }
}