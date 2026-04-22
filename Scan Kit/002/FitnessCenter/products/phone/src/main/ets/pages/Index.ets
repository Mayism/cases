import { BookMain } from 'course';
import { MockService, EmitterConstant, BreakpointUtils } from 'external_interactions';
import { Home } from './Home';
import { Mine } from './Mine';
import { AppStorageV2 } from '@kit.ArkUI';
import { ScreenPropStorage , JumpLogin, LoginState, BookJumpSearch} from 'external_interactions'
import { emitter } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

@Entry
@ComponentV2
struct Index {
  @Local currentIndex: number = 0
  pathStack: NavPathStack = new NavPathStack()
  tabController: TabsController = new TabsController()
  @Local screenPropStorage : ScreenPropStorage = AppStorageV2.connect(ScreenPropStorage, 'ScreenPropStorage', () =>new ScreenPropStorage())!
  @Local jumpLoginStorage : JumpLogin = AppStorageV2.connect(JumpLogin, 'JumpLogin', () =>new JumpLogin())!
  @Local bookJumpSearchStorage : BookJumpSearch = AppStorageV2.connect(BookJumpSearch, 'BookJumpSearch', () =>new BookJumpSearch())!
  @Local bookJumpSearch: string = this.bookJumpSearchStorage.bookJumpSearch;
  @Local jumpLogin: boolean = this.jumpLoginStorage.jumpLogin
  @Local loginStateStorage : LoginState = AppStorageV2.connect(LoginState, 'LoginState', () =>new LoginState())!
  breakpoint: BreakpointUtils | null = null;

  aboutToAppear(): void {
    MockService.init(this.getUIContext().getHostContext() as common.UIAbilityContext);
    this.breakpoint = new BreakpointUtils(this.getUIContext().getMediaQuery());
    this.breakpoint?.register()
    try {
      emitter.on(EmitterConstant.CLICK_BOOK_DETAIL, () =>{
        if(this.loginStateStorage.loginState === false){
          this.changeIndex('jumpLogin')
        }else{
          this.changeIndex('bookJumpSearch')
        }
      })
    } catch (e) {
      console.error(`emitter on failed. error: ${JSON.stringify(e)}`)
    }
  }

  aboutToDisappear(): void {
    this.breakpoint?.unRegister();
  }

  @Builder
  tabBarBuilder(title: string, image: ResourceStr, index: number) {
    Column() {
      Image(image)
        .width(24)
        .height(24)
        .fillColor(this.currentIndex === index ? Color.Orange : '#666666')
      Text(title)
        .fontSize(10)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.currentIndex === index ? Color.Orange : '#666666')
    }
    .margin({ bottom: 15 })
  }

  build() {
    Navigation(this.pathStack) {
      Tabs({ barPosition: BarPosition.End, index: $$this.currentIndex, controller: this.tabController }) {
        TabContent() {
          // 首页
          Home({ pathStack: this.pathStack })
        }
        .tabBar(this.tabBarBuilder('首页', $r('app.media.home'), 0))

        TabContent() {
          // 预约页
          BookMain({ pathStack: this.pathStack, mainTabIndex: this.currentIndex })
        }
        .tabBar(this.tabBarBuilder('预约', $r('app.media.booking'), 1))

        TabContent() {
          // 个人页
          Mine({ pathStack: this.pathStack })
        }
        .tabBar(this.tabBarBuilder('我的', $r('app.media.mine'), 2))
      }
      .barHeight(70)
      .scrollable(false)
      .width('100%')
      .height('100%')
      .margin({ left: 10, right: 10 })
    }
    .hideTitleBar(true)
    .width('100%')
    .height('100%')
    .mode(NavigationMode.Stack)
  }

  @Monitor('jumpLoginStorage.jumpLogin', 'bookJumpSearchStorage.bookJumpSearch', 'this.bookJumpSearchStorage', 'bookJumpSearchStorage')
  changeIndex(propertyName: string) {
    if (propertyName === 'bookJumpSearch') {
      this.tabController.changeIndex(1)
    } else if (propertyName === 'jumpLogin') {
      this.getUIContext().getPromptAction().showToast({message: '请先关联账号', duration: 2000})
      this.tabController.changeIndex(2)
    }
  }
}