import { CommonUrl, Constants, NavHeaderBar, RouterMap, RouterUtil, WebRouter } from 'lib_common';

@Builder
export function ConsiderateServicePageBuilder() {
  ConsiderateServicePage()
}

@ComponentV2
struct ConsiderateServicePage {
  @Styles
  cardStyle(){
    .padding(12)
    .height(64)
    .borderRadius(12)
    .layoutWeight(1)
    .backgroundImage($r('app.media.bg_membership'))
    .backgroundImageSize(ImageSize.Cover)
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: '贴心服务', hasBgColor: false })
      Column() {
        Column({ space: 12 }) {
          Row() {
            Image($r('app.media.ic_enjoy')).width(36).height(36)
            Text('会员尊享服务')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
              .margin({ left: 8 })
          }.width(Constants.FULL_SIZE)

          Column({ space: 12 }) {
            Row({ space: 12 }) {
              Row() {
                Text('母婴室').fontSize(14).fontWeight(FontWeight.Medium).fontColor('#D17E18')
              }.cardStyle()
              .alignItems(VerticalAlign.Center)
              .onClick(() => {
                RouterUtil.pushPathByName(RouterMap.SERVICE_DETAIL_PAGE, { index: 1 } as WebRouter)
              })

              Row() {
                Column() {
                  Text('物品寄存').fontSize(14).fontWeight(FontWeight.Medium).fontColor('#D17E18')
                  Text('失物招领').fontSize(14).fontWeight(FontWeight.Medium).fontColor('#D17E18')
                }.alignItems(HorizontalAlign.Start)
              }.cardStyle().alignItems(VerticalAlign.Center).onClick(() => {
                RouterUtil.pushPathByName(RouterMap.SERVICE_DETAIL_PAGE, { index: 2 } as WebRouter)
              })
            }.width(Constants.FULL_SIZE)

            Row({ space: 12 }) {
              Row() {
                Column({ space: 4 }) {
                  Text('租借服务').fontSize(14).fontWeight(FontWeight.Medium).fontColor('#D17E18')
                  Text('雨伞/轮椅/童车等')
                    .fontSize(10)
                    .fontColor('#E08A21')
                    .backgroundColor('#33FFFFFF')
                    .backdropBlur(10)
                    .borderRadius(4)
                    .padding({
                      top: 4,
                      bottom: 4,
                      left: 8,
                      right: 8,
                    })
                }.alignItems(HorizontalAlign.Start)
              }.cardStyle().alignItems(VerticalAlign.Center).onClick(() => {
                RouterUtil.pushPathByName(RouterMap.SERVICE_DETAIL_PAGE, { index: 3 } as WebRouter)
              })

              Row() {
                Text('急救药箱').fontSize(14).fontWeight(FontWeight.Medium).fontColor('#D17E18')
              }.cardStyle().alignItems(VerticalAlign.Center).onClick(() => {
                RouterUtil.pushPathByName(RouterMap.SERVICE_DETAIL_PAGE, { index: 4 } as WebRouter)
              })

            }.width(Constants.FULL_SIZE)

            Row({ space: 12 }) {
              Row() {
                Text('礼品包装').fontSize(14).fontWeight(FontWeight.Medium).fontColor('#D17E18')
              }.cardStyle().alignItems(VerticalAlign.Center).onClick(() => {
                RouterUtil.pushPathByName(RouterMap.SERVICE_DETAIL_PAGE, { index: 5 } as WebRouter)
              })

              Row() {
                Text('停车优惠').fontSize(14).fontWeight(FontWeight.Medium).fontColor('#D17E18')
              }.cardStyle().alignItems(VerticalAlign.Center).onClick(() => {
                RouterUtil.pushPathByName(RouterMap.SERVICE_DETAIL_PAGE, { index: 6 } as WebRouter)
              })
            }.width(Constants.FULL_SIZE)
          }
        }
        .borderRadius(16)
        .padding(12)
        .backgroundColor($r('sys.color.background_primary'))
        .width(Constants.FULL_SIZE)

        this.preloadImg()
      }
      .width(Constants.FULL_SIZE)
      .padding({ top: 12, left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH })
    }
    .hideTitleBar(true)
    .backgroundImage($r('app.media.member_service_bg'))
    .backgroundImageSize(ImageSize.Cover)
  }

  @Builder
  preloadImg() {
    Column() {
      Image(`${CommonUrl.CLOUD_STORAGE_URL}ShoppingMall/service_babycare.png`)
      Image(`${CommonUrl.CLOUD_STORAGE_URL}ShoppingMall/service_lost.png`)
      Image(`${CommonUrl.CLOUD_STORAGE_URL}ShoppingMall/service_medical.png`)
      Image(`${CommonUrl.CLOUD_STORAGE_URL}ShoppingMall/service_gift.png`)
      Image(`${CommonUrl.CLOUD_STORAGE_URL}ShoppingMall/service_park.png`)
    }
    .visibility(Visibility.Hidden)
  }
}
