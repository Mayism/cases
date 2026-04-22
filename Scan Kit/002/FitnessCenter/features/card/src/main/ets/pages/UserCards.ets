import { CardInfo, ConsumeType, DateUtil, MockService, UserCard } from 'external_interactions';
import { TitleBar } from 'module_recharge/src/main/ets/components/TitleBar';
import { ScreenPropStorage , AccountUpdate} from 'external_interactions'
import { AppStorageV2 } from '@kit.ArkUI';
@ComponentV2
export struct UserCards {
  @Local screenPropStorage : ScreenPropStorage = AppStorageV2.connect(ScreenPropStorage, 'ScreenPropStorage', () =>new ScreenPropStorage())!
  @Local topRectHeight: number = this.screenPropStorage.topRectHeight;
  @Local bottomRectHeight: number = this.screenPropStorage.bottomRectHeight;
  @Param @Once pathStack: NavPathStack = new NavPathStack()
  userCardList: UserCard[] = []

  @Monitor('screenPropStorage.topRectHeight', 'screenPropStorage.bottomRectHeight')
  onScreenPropStorage(mon: IMonitor) {
    this.topRectHeight = this.screenPropStorage.topRectHeight;
    this.bottomRectHeight = this.screenPropStorage.bottomRectHeight
  }

  @Builder
  cardItemBuilder(userCard: UserCard, cardDetail: CardInfo) {
    Row() {
      Image($r(cardDetail?.advImage))
        .width(80)
        .height(80)
        .borderRadius(8)
      Column() {
        Text(cardDetail?.name)
          .textAlign(TextAlign.Start)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
        Row() {
          Text(cardDetail?.consumeType === ConsumeType.TIMES ? cardDetail?.quota + '次' :
            MockService.getQuotaDurationDesc(cardDetail?.quota) + '卡')
            .fontSize(14)
          Text() {
            if (cardDetail?.consumeType === ConsumeType.TIMES) {
              Span('剩余次数:')
              Span(userCard.restQuota.toString())
                .fontColor('#FF9019')
            } else {
              Span('到期时间:')
              Span(DateUtil.formatDate(MockService.getCardExpireDate(userCard)))
                .fontColor('#FF9019')
            }
          }
          .fontSize(14)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceEvenly)
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 16 })
      .height(80)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .padding(16)
    .onClick(() => {
      this.pathStack.pushPath({ name: 'card/cardDetail', param: cardDetail })
    })
  }

  build() {
    NavDestination() {
      Column() {
        TitleBar({ title: '我的卡项', onBackClick:()=>{this.pathStack.pop()} })
        List({ space: 16 }) {
          ForEach(this.userCardList, (item: UserCard) => {
            if(item.restQuota > 0){
              ListItem() {
                this.cardItemBuilder(item, MockService.getCardById(item.cardId))
              }
            }
          }, (item: UserCard) => JSON.stringify(item))
        }
        .margin({ bottom: 28 })
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        .width('100%')
        .height('100%')
        .layoutWeight(1)
      }.margin({ left: 16, right: 16 })
    }
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx?.pathStack
      MockService.userCardList.forEach((item: UserCard) => {
        if (MockService.userCardCanUse(item)) {
          if(item.restQuota > 0){
            this.userCardList.push(item)
          }
        }
      })
    })
    .hideTitleBar(true)
    .padding({ top: this.getUIContext().px2vp(this.topRectHeight) })
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.main_background_color'))
  }
}