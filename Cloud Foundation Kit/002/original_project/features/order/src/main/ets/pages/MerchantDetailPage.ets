import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { AppStorageV2 } from '@kit.ArkUI';
import { callTelSheetBuilder } from 'base_ui';
import {
  CommonUrl,
  Constants,
  HwMapModel,
  ImageRouter,
  NavHeaderBar,
  RouterMap,
  RouterModule,
  StoreInfoModel,
} from 'common/Index';

@Builder
export function MerchantDetailPageBuilder() {
  MerchantDetailPage()
}

@ComponentV2
struct MerchantDetailPage {
  @Local storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!;
  @Local webFilePath: string = ''
  @Local callTelSheet: boolean = false
  private scroller: Scroller = new Scroller()

  @Styles
  cardStyle(){
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
    .constraintSize({ maxWidth: Constants.FULL_SIZE })
    .padding({
      left: 12,
      right: 12,
      top: 16,
      bottom: 16,
    })
    .margin({
      left: 12,
      right: 12,
    })
  }

  build() {
    NavDestination() {
      Column() {
        NavHeaderBar({ title: $r('app.string.store_detail') })

        Scroll(this.scroller) {
          Column({ space: 12 }) {
            Column() {
              Row() {
                Row() {
                  Image(`${CommonUrl.CLOUD_STORAGE_URL}${this.storeModel.storeInfo?.logo}`)
                    .width(40)
                    .height(40)
                    .borderRadius(8)
                  Column() {
                    Text(this.storeModel.storeInfo?.name)
                      .fontSize($r('sys.float.Body_L'))
                      .fontWeight(FontWeight.Medium)
                      .fontColor($r('sys.color.font_primary'))
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    Text(this.storeModel.storeInfo?.address)
                      .fontSize($r('sys.float.Body_S'))
                      .fontColor($r('sys.color.font_secondary'))
                      .constraintSize({ maxWidth: 190 })
                      .margin({ top: 2 })
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }.margin({ left: 8 }).alignItems(HorizontalAlign.Start).layoutWeight(1)
                }.layoutWeight(1)

                Row() {
                  Image($r('app.media.ic_tel')).width(24)
                    .onClick(() => {
                      this.callTelSheet = true
                    })
                    .bindSheet($$this.callTelSheet, callTelSheetBuilder(this.storeModel.storeInfo?.tel || '', () => {
                      this.callTelSheet = false
                    }), {
                      detents: [309, 310],
                      backgroundColor: $r('sys.color.background_fourth'),
                      blurStyle: BlurStyle.Thick,
                      preferType: SheetType.CENTER,
                      title: { title: $r('app.string.contact_us') },
                    });
                  Image($r('app.media.ic_map')).width(24).margin({ left: 12 })
                    .onClick(() => {
                      let coordinates = this.storeModel.storeInfo?.coordinates?.split(',')
                      if (coordinates?.length === 2) {
                        let latitude: number = Number(coordinates[0])
                        let longitude: number = Number(coordinates[1])
                        RouterModule.push(RouterMap.HW_MAP_PAGE, { latitude, longitude } as HwMapModel)
                      } else {
                        promptAction.showToast({ message: '商户地址错误！' })
                      }

                    })
                }.width(80).justifyContent(FlexAlign.End)
              }
              .width(Constants.FULL_SIZE)
              .constraintSize({ maxWidth: Constants.FULL_SIZE })
              .justifyContent(FlexAlign.SpaceBetween)

              Divider().margin({ top: 12, bottom: 12 })
              Row() {
                Image($r('app.media.clock')).width(14)
                Text() {
                  Span($r('app.string.monday_to_sunday'))
                  Span(this.storeModel.storeInfo.time1)
                  Span('-')
                  Span(Constants.MID_DAY_TIME)
                  Span('  ')
                  Span(Constants.MID_DAY_TIME)
                  Span('-')
                  Span(this.storeModel.storeInfo.time2)
                }
                .margin({ left: 9 })
                .fontSize($r('sys.float.Body_S'))
                .fontColor($r('sys.color.font_secondary'))
              }
              .width(Constants.FULL_SIZE)
              .justifyContent(FlexAlign.Start)
            }.cardStyle()

            // 商家资质
            Column() {
              Column() {
                Text($r('app.string.merchant_qualifications'))
                  .fontSize($r('sys.float.Body_M'))
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('sys.color.font_primary'))
                Grid() {
                  GridItem() {
                    Image(`${CommonUrl.CLOUD_STORAGE_URL}${this.storeModel.storeInfo.businessLicense}`)
                      .width(100)
                      .height(70)
                      .draggable(false)
                      .borderRadius(8)
                  }

                  GridItem() {
                    Image(`${CommonUrl.CLOUD_STORAGE_URL}${this.storeModel.storeInfo.foodLicense}`)
                      .width(100)
                      .height(70)
                      .draggable(false)
                      .borderRadius(8)
                  }
                }.rowsGap(5).columnsGap(5).maxCount(3).margin({ top: 12 })
              }
              .width(Constants.FULL_SIZE)
              .alignItems(HorizontalAlign.Start)
            }.cardStyle()

            if (this.storeModel.storeInfo.environment) {
              // 商家环境
              Column() {
                Column() {
                  Text($r('app.string.merchant_env'))
                    .fontSize($r('sys.float.Body_M'))
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('sys.color.font_primary'))
                  Grid() {
                    ForEach(this.storeModel.storeInfo.environment, (item: string) => {
                      GridItem() {
                        Image(`${CommonUrl.CLOUD_STORAGE_URL}${item}`)
                          .width(100)
                          .height(70)
                          .draggable(false)
                          .borderRadius(8)
                          .onClick(() => {
                            RouterModule.push(RouterMap.PREVIEW_IMAGE_PAGE, { imageSrc: `${item}` } as ImageRouter)
                          })
                      }
                    }, (item: string) => item)
                  }.rowsGap(4).columnsGap(4).maxCount(3).margin({ top: 12 })
                }
                .width(Constants.FULL_SIZE)
                .alignItems(HorizontalAlign.Start)
              }.cardStyle()
            }

            // 商家承诺
            Column() {
              Text($r('app.string.merchant_commitment'))
                .fontSize($r('sys.float.Body_M'))
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_primary'))
              Row() {
                Text($r('app.string.food_safe'))
                  .fontSize($r('sys.float.Body_S'))
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('sys.color.font_secondary'))
                Row() {
                  Image($r('app.media.ic_store_security')).width(16)
                  Text($r('app.string.licensed'))
                    .fontSize($r('sys.float.Body_S'))
                    .fontColor($r('sys.color.font_secondary'))
                    .margin({ left: 4 })
                }.margin({ left: 24 })

                Row() {
                  Image($r('app.media.ic_store_security')).width(16)
                  Text($r('app.string.worry_free'))
                    .fontSize($r('sys.float.Body_S'))
                    .fontColor($r('sys.color.font_secondary'))
                    .margin({ left: 4 })
                }.margin({ left: 16 })
              }.margin({ top: 12 })

              Row() {
                Text($r('app.string.basic_service'))
                  .fontSize($r('sys.float.Body_S'))
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('sys.color.font_secondary'))
                Row() {
                  Image($r('app.media.ic_store_wifi')).width(16)
                  Text($r('app.string.free_wifi'))
                    .fontSize($r('sys.float.Body_S'))
                    .fontColor($r('sys.color.font_secondary'))
                    .margin({ left: 4 })
                }.margin({ left: 24 })

                Row() {
                  Image($r('app.media.ic_store_car')).width(16)
                  Text($r('app.string.free_parking'))
                    .fontSize($r('sys.float.Body_S'))
                    .fontColor($r('sys.color.font_secondary'))
                    .margin({ left: 4 })
                }.margin({ left: 16 })
              }.margin({ top: 8 })
            }.cardStyle().width(Constants.FULL_SIZE).padding(12).alignItems(HorizontalAlign.Start)

            // 商家公告
            Column() {
              Column() {
                Text($r('app.string.store_announce'))
                  .fontSize($r('sys.float.Body_M'))
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('sys.color.font_primary'))
                Row() {
                  Image($r('app.media.news')).width(16)
                  Text(this.storeModel.storeInfo.announcement)
                    .fontSize($r('sys.float.Body_S'))
                    .fontColor($r('sys.color.font_secondary'))
                    .layoutWeight(1)
                    .margin({ left: 4 })
                }.margin({ top: 12 }).alignItems(VerticalAlign.Top)
              }
              .width(Constants.FULL_SIZE)
              .alignItems(HorizontalAlign.Start)
            }.cardStyle()

          }
        }
        .backgroundColor($r('sys.color.background_secondary'))
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .layoutWeight(1)
        .padding({ top: 12 })
        .align(Alignment.Top)
      }

    }.hideTitleBar(true)
  }
}
