import { getAnonymousTel } from '../utils/Utils';
import { ShoppingMall, UserInfo } from './ResponseModel';

// 应用信息
export class AppInfoModel {
  packageName: string = '';
}

// 店铺信息
@ObservedV2
export class MallModel {
  @Trace shoppingMall: ShoppingMall = new ShoppingMall()
}

// 用户信息
@ObservedV2
export class UserInfoModel {
  @Trace userInfo: UserInfo = new UserInfo()
  @Trace isRelative: boolean = false
  @Trace openId: string = ''
  @Trace unionId: string = ''

  getTel(): string {
    return getAnonymousTel(this.userInfo.userTel)
  }
}

// 用户头像持久化
@ObservedV2
export class UserIconModel {
  @Trace isSaved: boolean = false
  @Trace userIconPath: string = 'userImage.jpg'
}

// 窗口持久化
@ObservedV2
export class WindowModel {
  @Trace windowTopHeight: number = 38.77;
  @Trace windowBottomHeight: number = 28;

  getWindowTopHeight() {
    return this.windowTopHeight || 38.77;
  }

  getWindowBottomHeight() {
    return this.windowBottomHeight || 28;
  }
}

@ObservedV2
export class FormModel {
  @Trace id: number = 0
  @Trace url: string = ''
}

@ObservedV2
export class FormCardJump {
  @Trace form: FormModel = new FormModel()
}