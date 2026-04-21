import { AccountUtil, RouterModule, UserInfoModel } from 'commonlib';

const TAG: string = 'HomePageVM';

@ObservedV2
export class HomePageVM {
  private static _instance: HomePageVM;

  @Trace navStack: NavPathStack = RouterModule.getStack();

  @Trace curIndex: number = 0;

  @Trace userInfo: UserInfoModel = AccountUtil.getUserInfo();
  @Trace changeFontSize: number = 0;
  @Trace comment: string = '';

  public static get instance() {
    if (!HomePageVM._instance) {
      HomePageVM._instance = new HomePageVM();
    }
    return HomePageVM._instance;
  }

  // 初始化
  public async init() {
  }
}
