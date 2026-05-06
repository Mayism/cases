import { AppStorageV2 } from '@kit.ArkUI';
import {
  CommonUrl,
  Constants,
  DiamondZone,
  GuideRouter,
  HttpRequest,
  MenuModel,
  NavHeaderBar,
  RouterMap,
  RouterUtil,
  StoreGuide,
  TabBarType,
  UserInfoModel,
  WindowModel,
} from 'lib_common';

@Builder
export function HomePageBuilder() {
  HomePage()
}

@ComponentV2
struct HomePage {
  @Consumer('currentIndex') currentIndex?: TabBarType
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
  @Local userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Local swiperIndex: number = 0;
  private scroller: Scroller = new Scroller();
  @Local bannerList: Array<ResourceStr> = [$r('app.media.banner_1')]
  @Local imageList: Array<MenuModel> =
    [new MenuModel($r('app.media.advertising_1'), '3', '1'), new MenuModel($r('app.media.advertising_1'), '3', '2')]
  @Local diamondZoneList: Array<DiamondZone> = [
    new DiamondZone($r('app.media.ic_home_parking_pay'), '停车缴费', RouterMap.PARKING_PAYMENT_PAGE),
    new DiamondZone($r('app.media.ic_home_self_point'), '自助积分', RouterMap.SELF_SERVICE_POINT_PAGE),
    new DiamondZone($r('app.media.ic_home_considerate_service'), '贴心服务', RouterMap.CONSIDERATE_SERVICE_PAGE),
    new DiamondZone($r('app.media.ic_store_guide'), '店铺导购', RouterMap.STORE_GUIDE_PAGE),
  ];
  @Local storeGuideList: StoreGuide[] = [];

  aboutToAppear(): void {
    this.getStoreList();
  }

  @Monitor('currentIndex')
  infoChange(monitor: IMonitor) {
    if (monitor.value()?.now === TabBarType.HOME_PAGE) {
    }
  }

  @Styles
  cardStyle(){
    .width(Constants.FULL_SIZE)
    .margin({ left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH, bottom: 8 })
    .constraintSize({ maxWidth: Constants.FULL_SIZE })
    .borderRadius(16)
    .backgroundColor(Color.White);
  }

  getStoreList() {
    HttpRequest.getStoreGuide().then(res => {
      this.storeGuideList = res
    })
  }

  build() {
    Column() {
      Stack() {
        this.preloadImg()
        Image($r('app.media.main_bg')).width('100%')
        Column() {
          NavHeaderBar({
            title: '首页',
            isMainPage: true,
            hasBackButton: false,
            hasBgColor: false,
          })
          Scroll(this.scroller) {
            Column() {
              Swiper() {
                ForEach(this.bannerList, (item: ResourceStr) => {
                  Row() {
                    Image(item)
                      .width(Constants.FULL_SIZE)
                      .borderRadius(16)
                      .constraintSize({
                        maxHeight: '35%',
                      })
                      .onClick(() => {
                        RouterUtil.pushPathByName(RouterMap.INTRODUCE_PAGE);
                      })
                  };
                }, (item: ResourceStr) => (JSON.stringify(item)),
                );
              }
              .displayMode(SwiperDisplayMode.STRETCH)
              .loop(true)
              .autoPlay(true)
              .interval(2000)
              .vertical(false)
              .indicator(new DotIndicator().color($r('sys.color.comp_background_secondary')))
              .onChange((index) => {
                this.swiperIndex = index;
              })
              .margin({ top: 12 })

              // 金刚区
              Grid() {
                ForEach(this.diamondZoneList, (item: DiamondZone) => {
                  GridItem() {
                    Column() {
                      Image(item.icon).width(32).height(32)
                      Text(item.title).fontSize(12).fontColor($r('sys.color.font_primary')).margin({ top: 8 })
                    }
                    .onClick(() => {
                      RouterUtil.pushPathByName(item.url)
                    })
                  }
                }, (item: DiamondZone) => JSON.stringify(item))
              }
              .rowsGap(10)
              .columnsGap(10)
              .width(Constants.FULL_SIZE)
              .height(80)
              .borderRadius(16)
              .padding(12)
              .columnsTemplate('1fr 1fr 1fr 1fr')
              .backgroundColor($r('sys.color.background_primary'))
              .margin({ top: 12 })

              Column() {
                Row() {
                  Text($r('app.string.salon_selected'))
                    .fontSize(16)
                    .fontColor($r('sys.color.font_primary'))
                    .fontWeight(FontWeight.Medium)
                  Text($r('app.string.salon_selected_en'))
                    .fontSize(12)
                    .fontColor($r('sys.color.font_secondary'))
                    .margin({ left: 4 })
                }
                .margin({ top: 16 })

                List({ space: 12 }) {
                  ForEach(this.imageList, (item: MenuModel) => {
                    ListItem() {
                      Image(item.icon)
                        .width(227)
                        .height(125)
                        .borderRadius(16)
                        .onClick(() => {
                          const storeInfo = this.storeGuideList.find(v => v.id === item.title);
                          if (storeInfo) {
                            RouterUtil.pushPathByName(RouterMap.STORE_GUIDE_DETAIL_PAGE,
                              { guide: storeInfo } as GuideRouter)
                          }
                        })
                    }
                  }, (item: MenuModel) => JSON.stringify(item))
                }
                .listDirection(Axis.Horizontal)
                .margin({ top: 16 })
                .scrollBar(BarState.Off)
              }.alignItems(HorizontalAlign.Start).width(Constants.FULL_SIZE)

              // 底线
              Column() {
                Text($r('app.string.footer_line')).fontSize(10).fontColor($r('sys.color.font_secondary'))
              }
              .width(Constants.FULL_SIZE)
              .margin({
                left: 10,
                right: 10,
                top: 16,
                bottom: 16,
              })
            }
          }
          .layoutWeight(1)
          .scrollBar(BarState.Off)
          .edgeEffect(EdgeEffect.Spring)
          .align(Alignment.Top)
          .padding({ left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH })
        }
      }
      .alignContent(Alignment.Top)
    }
    .width('100%')
    .height(Constants.FULL_SIZE)
    .backgroundColor('#F1F3F5')
  }

  @Builder
  preloadImg() {
    Scroll() {
      Column() {
        ForEach(this.storeGuideList, (v: StoreGuide) => {
          Image(`${CommonUrl.CLOUD_STORAGE_URL}${v.bigImage}`)
          Image(`${CommonUrl.CLOUD_STORAGE_URL}${v.logo}`)
        }, (v: StoreGuide) => JSON.stringify(v))
      }
    }
    .width(10)
    .height(10)
    .visibility(Visibility.Hidden)
  }
}