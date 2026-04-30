import { AppStorageV2 } from '@kit.ArkUI';
import {
  Constants,
  RouterMap,
  RouterUtil,
  UserInfoModel,
  TabBarData,
  TabBarType,
  LoginButtonIcon,
} from 'lib_common';
import { TABS_INFO } from '../common/Constants';

@ComponentV2
export struct CustomTabBar {
  @Consumer('currentIndex') currentIndex: TabBarType = TabBarType.HOME_PAGE;
  @Local windowBottomHeight: number = AppStorage.get('windowBottomHeight') as number || 28;

  onChange(index: TabBarType): void {
    this.currentIndex = index;
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      ForEach(TABS_INFO, (value: TabBarData) => {
        TabItem({
          selectedIndex: this.currentIndex,
          index: value.id,
          onChange: (index: number) => this.onChange(index),
        })
      }, (value: TabBarData) => value.id.toString())
    }
    .backgroundColor($r('sys.color.background_primary'))
    .shadow({
      radius: 30,
      color: '#33000000',
      offsetX: 0,
      offsetY: 10,
    })
    .padding({
      top: 4,
      left: 28,
      right: 28,
      bottom: this.windowBottomHeight + 4,
    })
    .clip(false)
    .width(Constants.FULL_SIZE)
  }
}

@ComponentV2
struct TabItem {
  @Param @Require selectedIndex: number;
  @Param @Require index: number
  @Local userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Event onChange: (index: number) => void = () => {
  };

  build() {
    if (this.index === TabBarType.ONE_CODE_PASS) {
      Column() {
        if (this.userInfo.isRelative) {
          Image(this.selectedIndex === this.index ?
            TABS_INFO[this.index].activeIcon :
            TABS_INFO[this.index].defaultIcon)
            .width(48)
            .height(48)
            .position({ y: -30 })
            .onClick(() => {
              RouterUtil.pushPathByName(RouterMap.MEMBER_SHIP_PAGE);
            })
        } else {
          LoginButtonIcon({
            callback: () => {
              RouterUtil.pushPathByName(RouterMap.MEMBER_SHIP_PAGE);
            }
          }).position({ y: -30 })
        }
      }
      .width(48)
    } else {
      Column() {
        Image(this.selectedIndex === this.index ? TABS_INFO[this.index].activeIcon : TABS_INFO[this.index].defaultIcon)
          .width(24).height(24).borderRadius(50)
        Text(TABS_INFO[this.index].title)
          .fontSize(10)
          .lineHeight(14)
          .fontColor(this.index === this.selectedIndex ? ($r('app.color.app_theme')) :
          $r('app.color.tab_color_default'))
          .margin({ top: 2 })
      }.width(71).onClick(() => this.onChange(this.index))
    }

  }
}