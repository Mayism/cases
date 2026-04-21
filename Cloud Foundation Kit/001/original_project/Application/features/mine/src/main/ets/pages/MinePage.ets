import {
  getDataFromJSON,
  UserState,
  Constants,
  CardInfo,
  MineGridInfo,
  SettingItem,
  ProgressItem,
  NavigationParams,
  DividerTmp,
  AutomaticQuickLogin,
} from 'common';
import { PersistenceV2 } from '@kit.ArkUI';
import { CallContentBuilder, ServiceTitle, TitleBuilder } from 'components';
import { AutomaticAssociationCount, UserInfo } from 'automatic_association_count'

@ComponentV2
export struct MinePage {
  gridItems: MineGridInfo[] = [];
  cardItems: CardInfo[] = [];
  settingItems: SettingItem[] = [];
  progressList: ProgressItem[] = []
  @Local automaticQuickLogin: AutomaticQuickLogin = new AutomaticQuickLogin()
  @Local egDivider: DividerTmp = new DividerTmp(1, 10, 10, '#ffe9f0f0')
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  @Local userState: UserState = PersistenceV2.connect(UserState, () => new UserState())!;
  @Local modelShow: boolean = false

  initDataSource() {
    this.settingItems = getDataFromJSON<SettingItem>('MinePage-SettingItems.json', this);
    this.progressList = getDataFromJSON<SettingItem>('Progress_Mock.json', this);
    PersistenceV2.save(UserState);
  }

  @Builder
  certificationProgress() {
    Column({ space: Constants.CONTAINER_SPACE_TWENTY }) {
      Column() {
        Text($r('app.string.certification_progress'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Subtitle_L'))
      }
      .width(Constants.FULL_PERCENT_WIDTH)
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 12 })

      Row() {
        ForEach(this.progressList, (item: ProgressItem) => {
          Column({ space: Constants.CONTAINER_SPACE_FIVE }) {
            Image($r(item.icon)).width($r('app.float.mine_progress_width')).height($r('app.float.mine_progress_height'))
            Text(item.name)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
              .fontSize($r('sys.float.Body_S'))
          }.onClick(() => {
            this.pageInfos.pushPathByName('progress', new NavigationParams(item.name))
          })
        }, (item: ProgressItem) => item.id)

      }
      .width(Constants.FULL_PERCENT_WIDTH)
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor($r('sys.color.background_primary'))
      .borderRadius(Constants.RADIUS_SIXTY)
      .padding({
        top: $r('app.float.common_padding_twelve'),
        bottom: $r('app.float.common_padding_sixty'),
        left: $r('app.float.common_padding_thirty_one'),
        right: $r('app.float.common_padding_thirty_one'),
      })
    }
    .margin({ top: $r('app.float.mine_progress_margin_top') })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Scroll() {
        Column() {
          /*
           * 个人信息
           * */
          AutomaticAssociationCount({
            userInfo: this.userState.userInfo!!,
            isLogin: this.userState.isLogin!!,
            onLogin: (code: string) => {
              this.automaticQuickLogin.onLogin(code)
            },
            onLoginOut:() => {
              this.userState.isLogin = false
              this.userState.userInfo = new UserInfo()
            }
          })
          /*
           * 办证进度
           * */
          this.certificationProgress()
          /*
           * 构建配置视图
           * */
          this.buildSettingsView()
        }
        .width(Constants.FULL_PERCENT_WIDTH)
        .constraintSize({ minHeight: Constants.FULL_PERCENT_WIDTH })
        .alignItems(HorizontalAlign.Start)
      }
      .padding({
        top: Number(AppStorage.get('topRectHeight')) + Constants.SAFE_AREA_FORTY,
        left: $r('app.float.mine_progress_padding_left'),
        right: $r('app.float.mine_progress_padding_left'),
      })
      .width(Constants.FULL_PERCENT_WIDTH)
      .height(Constants.FULL_PERCENT_HEIGHT)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Auto)
      .edgeEffect(EdgeEffect.Spring)
      .backgroundColor($r('app.color.mine_bg'))
      .linearGradient({
        angle: 180,
        colors: [
          ['#CBE1F7', 0.0],
          ['#FFFFFF', 1.0],
        ],
      })

      ServiceTitle({
        title: $r('app.string.mine_title'),
      })
    }
  }

  @Builder
  buildSettingsView() {
    List() {
      ForEach(this.settingItems, (settingItem: SettingItem, idx: number) => {
        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Row() {
              Image($r(settingItem.icon))
                .width($r('app.float.mine_setting_width'))
                .height($r('app.float.mine_setting_height'))
                .margin({ right: $r('app.float.mine_setting_margin_right') })
                .syncLoad(false)
                .objectFit(ImageFit.Cover);
              Text(`${settingItem.name}`)
                .fontColor($r('sys.color.font_primary'))
                .fontWeight(FontWeight.Regular)
                .fontSize($r('sys.float.Body_M'));
            }

            Image($r(settingItem.moreIcon))
              .width($r('app.float.mine_more_width'))
              .height($r('app.float.mine_more_height'))
              .syncLoad(false)
              .objectFit(ImageFit.Fill)
          }
          .width(Constants.FULL_PERCENT_WIDTH)
          .padding({
            top: $r('app.float.mine_setting_padding_top'),
            left: $r('app.float.mine_setting_padding_left'),
            bottom: $r('app.float.mine_setting_padding_bottom'),
            right: $r('app.float.mine_setting_padding_right'),
          })
          .onClick(() => {
            if (settingItem.id === 'personal') {
              this.pageInfos.pushPathByName('setting', new NavigationParams(settingItem.name))
            } else if (settingItem.id === 'contact') {
              this.modelShow = !this.modelShow
            } else {
              this.pageInfos.pushPathByName('aboutUs', null)
            }
          })
        }
      }, (settingItem: SettingItem) => settingItem.name);
    }
    .divider(this.egDivider)
    .borderRadius(Constants.RADIUS_SIXTY)
    .backgroundColor($r('sys.color.background_primary'))
    .margin({ top: $r('app.float.mine_service_margin_top') })
    .bindSheet($$this.modelShow, CallContentBuilder(() => {
      this.modelShow = !this.modelShow
    }), {
      height: $r('app.float.mine_sheet_height'),
      title: TitleBuilder,
      blurStyle: BlurStyle.COMPONENT_THICK,
      preferType: SheetType.BOTTOM,
    })
  }

  onPageShow() {
  }

  onPageHide() {
  }

  onBackPress() {
  }

  aboutToDisappear() {
  }

  aboutToAppear() {
    this.initDataSource()
  }
}
