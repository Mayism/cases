import { AppStorageV2 } from '@kit.ArkUI';
import { AccountUtil, LoginModel, RouterModule, UserInfoModel } from 'commonlib';

const TAG: string = 'MainPageVM';

@ObservedV2
export class MainPageVM {
  private static _instance: MainPageVM;
  @Trace navStack: NavPathStack = RouterModule.getStack();

  @Trace curIndex: number = 0;
  @Trace userInfo: UserInfoModel = AccountUtil.getUserInfo();
  @Trace loginInfo: LoginModel = AppStorageV2.connect(LoginModel, () => new LoginModel())!
  @Trace changeFontSize: number = 0;
  @Trace fontSizeText: string = '标准';
  @Trace comment: string = '真是一个好消息～哈哈哈～';

  public static get instance() {
    if (!MainPageVM._instance) {
      MainPageVM._instance = new MainPageVM();
    }
    return MainPageVM._instance;
  }

  // 初始化
  public async init() {
  }
}


@ObservedV2
export class UserInfoStorage {
  idToken: string = ''
  authCode: string = ''
  @Trace avatar: string = ''
  @Trace phoneNumber: string = ''
  @Trace userName: string = ''
}