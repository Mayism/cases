import { AccountUtil, HuaweiIDResp, Logger, LoginModel, RouterModule, UserInfoModel } from 'commonlib';
import { TabListItem } from '../types/Types';
import { AppStorageV2 } from '@kit.ArkUI';

const TAG = '[MainEntryVM]'

@ObservedV2
export class MainEntryVM {
  private static _instance: MainEntryVM;

  @Trace navStack: NavPathStack = RouterModule.getStack();

  @Trace curIndex: number = 0;

  @Trace changeFontSize: number = 0;
  @Trace userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Trace loginInfo: LoginModel = AppStorageV2.connect(LoginModel, () => new LoginModel())!;

  tabList: TabListItem[] = [
    {
      label: '首页',
      icon: $r('app.media.ic_home'),
      iconChecked: $r('app.media.ic_home_checked'),
    },
    {
      label: '视频',
      icon: $r('app.media.ic_video'),
      iconChecked: $r('app.media.ic_video_checked'),
    },
    {
      label: '我的',
      icon: $r('app.media.ic_mine'),
      iconChecked: $r('app.media.ic_mine_checked'),
    }
  ]

  public static get instance() {
    if (!MainEntryVM._instance) {
      MainEntryVM._instance = new MainEntryVM();
    }
    return MainEntryVM._instance;
  }

  // 初始化
  public async init() {
    AccountUtil.silentLogin().then((res: HuaweiIDResp) => {
      // 为了不阻塞模板体验，不做失败拦截
      this.loginInfo.isLogin = true
      this.userInfo.id = 1
      this.userInfo.name = '华为用户'
    })
  }
}
