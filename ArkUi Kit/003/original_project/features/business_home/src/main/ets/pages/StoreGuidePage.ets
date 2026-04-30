import { Constants, NavHeaderBar } from 'lib_common';
import { GuideListComp } from '../components/GuideListComp';
import { Floor, StoreGuideViewModel } from '../viewmodel/StoreGuideViewModel';

@Builder
export function StoreGuidePageBuilder() {
  StoreGuidePage()
}

@ComponentV2
struct StoreGuidePage {
  @Local vm: StoreGuideViewModel = new StoreGuideViewModel()

  aboutToAppear(): void {
    this.vm.getService()
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: '', hasBgColor: true })
      Scroll() {
        Column() {
          Swiper() {
            ForEach(this.vm.floorImages, (item: Floor) => {
              Stack() {
                Image(item.img)
                  .width(Constants.FULL_SIZE)
                  .constraintSize({
                    maxHeight: '50%',
                  })
                Row() {
                  Image($r('app.media.ic_location')).width(16).height(16)
                  Text(item.text).fontSize(12).fontColor($r('sys.color.font_primary')).margin({ left: 4 })
                }
                .margin({ right: 32, bottom: 32 })
                .borderRadius(24)
                .padding({
                  top: 6,
                  bottom: 6,
                  left: 12,
                  right: 12,
                })
                .backgroundColor('#1AFFFFFF')
              }
              .alignContent(Alignment.BottomEnd)
              .onClick(() => {
                this.vm.goStore(item);
              })
            }, (item: ResourceStr) => (JSON.stringify(item)),
            );
          }
          .displayMode(SwiperDisplayMode.STRETCH)
          .loop(true)
          .autoPlay(false)
          .vertical(false)
          .interval(2000)
          .indicator(new DotIndicator().color($r('sys.color.comp_background_secondary')))
          .nestedScroll(SwiperNestedScrollMode.SELF_FIRST)
          .onChange((index) => {
            this.vm.swiperIndex = index;
          })

          GuideListComp({ vm: this.vm })
        }
      }
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1)

    }
    .hideTitleBar(true)
  }
}
