import { AppStorageV2 } from '@kit.ArkUI';
import {
  CommonConstants,
  NewsTypeModel,
  NewsViewModel,
  WindowModel,
} from 'commonlib';
import { BaseTitle } from 'componentlib';
import { HomeContentView } from '../components/HomeContentView';


@Builder
export function homePageBuilder() {
  HomePage()
}

@ComponentV2
export struct HomePage {
  @Param initSize: number = 0;
  @Local tabBarArray: NewsTypeModel[] = new NewsViewModel().getDefaultTypeList();
  @Local currentIndex: number = 0;
  windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;

  build() {
    Column() {
      BaseTitle({
        customTitle: () => {
          this.HomeTitleBuilder()
        },
      })
      Tabs({ barPosition: BarPosition.Start }) {
        ForEach(this.tabBarArray, (tabsItem: NewsTypeModel, index: number) => {
          TabContent() {
            HomeContentView()
          }
          .backgroundColor($r('app.color.bgc'))
          .padding({top: 8})
          .tabBar(
            new SubTabBarStyle(tabsItem.name)
              .labelStyle({
                unselectedColor: $r('app.color.news_time_fontColor'),
                selectedColor: $r('app.color.fontColor_text3'),
                font: {
                  size: 16 + this.windowModel.fontSize,
                  weight: this.currentIndex === index ? FontWeight.Bold : FontWeight.Regular
                }
              })
              .indicator({
                color: $r('app.color.tab_indicator_color'),
                height: 2,
                width: 20,
                marginTop: 8,
                borderRadius: 2
              })
              .padding({left: 10, right: 10, top: 8, bottom: 8 })
          )
        }, (item: NewsTypeModel) => JSON.stringify(item));
      }
      .barHeight(48)
      .barMode(BarMode.Scrollable)
      .barWidth(CommonConstants.FULL_PERCENT)
      .vertical(false)
      .onAnimationStart((_index: number, targetIndex: number, _event: TabsAnimationEvent) => {
        this.currentIndex = targetIndex;
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  HomeTitleBuilder() {
    Text('首页')
      .fontSize(24)
      .fontWeight(FontWeight.Bold)
  }
}