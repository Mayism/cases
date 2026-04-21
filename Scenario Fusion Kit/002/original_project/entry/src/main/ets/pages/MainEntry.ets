import { AppStorageV2, window } from '@kit.ArkUI';
import { common, ConfigurationConstant } from '@kit.AbilityKit';
import { CommonConstants, Logger, PreferencesUtil, WindowModel } from 'commonlib';
import { minePageBuilder } from 'mine';
import { homePageBuilder } from 'home';
import { videoViewBuilder } from 'video';
import { TabListItem } from '../types/Types';
import { MainEntryVM } from '../viewmodels/MainEntryVM';

@Entry
@ComponentV2
struct MainEntry {
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  // windowStage
  private windowStage: window.WindowStage = this.context.windowStage;
  // window
  private windowClass: window.Window = this.windowStage.getMainWindowSync();

  windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;

  vm: MainEntryVM = MainEntryVM.instance;

  @Monitor('windowModel.currentColorMode')
  onCurrentColorModeChange() {
    if (this.windowModel.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.windowClass.setWindowSystemBarProperties({
        statusBarContentColor: '#000000'
      })
    } else if (this.windowModel.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.windowClass.setWindowSystemBarProperties({
        statusBarContentColor: '#ffffff'
      })
    }
  }

  aboutToAppear(): void {
    this.vm.init()
  }

  onPageShow() {
    PreferencesUtil.getChangeFontSize().then((value) => {
      this.vm.changeFontSize = value;
      this.windowModel.fontSize = value
      Logger.info('changeFontSize', 'Get the value of changeFontSize: ' + this.vm.changeFontSize);
    });
    this.onCurrentColorModeChange()
  }

  build() {
    Navigation(this.vm.navStack) {
      Column() {
        Tabs({ barPosition: BarPosition.End, index: this.vm.curIndex }) {
          TabContent() {
            homePageBuilder()
          }
          .tabBar(this.tabBarBuilder(this.vm.tabList[0], 0));

          TabContent() {
            videoViewBuilder()
          }
          .tabBar(this.tabBarBuilder(this.vm.tabList[1], 1));

          TabContent() {
            minePageBuilder()
          }
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
          .tabBar(this.tabBarBuilder(this.vm.tabList[2], 2));
        }
        .scrollable(false)
        .height(CommonConstants.FULL_PERCENT)
        .barHeight($r('app.integer.tab_bar_height'))
        .animationDuration(0)
        .barMode(BarMode.Fixed)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
        .onChange((index: number) => {
          this.vm.curIndex = index;
          PreferencesUtil.getChangeFontSize().then((value) => {
            this.vm.changeFontSize = value;
            this.windowModel.fontSize = value
            Logger.info('changeFontSize', 'Get the value of changeFontSize: ' + this.vm.changeFontSize);
          });
        });
      }
      .backgroundColor($r('app.color.bgc'))
    }
    .hideTitleBar(true)
    .hideToolBar(true)
    .hideBackButton(true)
    .mode(NavigationMode.Stack);
  }

  @Builder
  tabBarBuilder(item: TabListItem, index: number) {
    Column({space: CommonConstants.SPACE_XS}) {
      Image(this.vm.curIndex === index ? item.iconChecked : item.icon)
        .width($r('app.integer.size_24'))
        .height($r('app.integer.size_24'))
        .fillColor(this.vm.curIndex === index ? $r('app.color.tab_icon_selected') : $r('sys.color.icon_secondary'))
      Text(item.label)
        .fontColor(this.vm.curIndex === index ? $r('app.color.icon_color_highlight') :
        $r('app.color.icon_color_level2'))
        .fontSize($r('app.integer.font_size_12'))
    }.width(CommonConstants.FULL_PERCENT);
  }
}