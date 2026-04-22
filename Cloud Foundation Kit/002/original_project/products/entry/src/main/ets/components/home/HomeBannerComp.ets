import { AppStorageV2 } from '@kit.ArkUI';
import { AppInfoModel, BreakpointNameEnum, BreakpointType, Constants, GridRowColSetting } from 'common/Index';
import { AdvertisementComponent } from './Advertisement';

@ComponentV2
export struct HomeBannerComp {
  @Param breakpoint: string = ''
  @Param bannerList: string[] = []
  @Local adVisibilityState: Visibility = Visibility.None;
  @Local appInfoModel: AppInfoModel = AppStorageV2.connect(AppInfoModel, () => new AppInfoModel())!;
  private indicatorController: IndicatorComponentController = new IndicatorComponentController();
  private swiperController: SwiperController = new SwiperController();

  aboutToAppear(): void {
    this.adVisibilityState = Visibility.Visible;
  }

  build() {
    Column() {
      Swiper(this.swiperController) {
        if (this.adVisibilityState === Visibility.Visible) {
          AdvertisementComponent({
            adId: Constants.AD_INFO, adVisibilityState: this.adVisibilityState, changeAdShow: (state: Visibility) => {
              this.adVisibilityState = state
            },
          })
        }
        ForEach(this.bannerList, (item: string) => {
            Image(`${this.appInfoModel.imgBaseUrl}${item}`)
              .aspectRatio(16 / 9)
              .objectFit(ImageFit.Fill)
              .borderRadius(20)
        }, (item: string) => item);
      }
      .displayCount(new BreakpointType<number>({
        [BreakpointNameEnum.SM]: 1,
        [BreakpointNameEnum.MD]: 2,
        [BreakpointNameEnum.LG]: 3,
        [BreakpointNameEnum.XL]: 3,
      }).getValue(this.breakpoint))
      .nextMargin(new BreakpointType<number>({
        [BreakpointNameEnum.SM]: 0,
        [BreakpointNameEnum.MD]: 36,
        [BreakpointNameEnum.LG]: 0,
        [BreakpointNameEnum.XL]: 0,
      }).getValue(this.breakpoint))
      .itemSpace(12)
      .width(Constants.FULL_SIZE)
      .loop(true)
      .autoPlay(true)
      .indicator(this.indicatorController)
      .interval(2000)
      .padding({
        left: GridRowColSetting.getPageMargin(this.breakpoint),
        right: GridRowColSetting.getPageMargin(this.breakpoint),
      });

      Row() {
        IndicatorComponent(this.indicatorController)
          .initialIndex(0)
          .style(
            new DotIndicator()
              .itemWidth(6)
              .itemHeight(6)
              .selectedItemWidth(12)
              .selectedItemHeight(6)
              .color($r('sys.color.comp_background_secondary'))
              .selectedColor($r('sys.color.multi_color_09')))
          .loop(true)
          .count(this.bannerList.length)
          .vertical(true)
      }
      .width(Constants.FULL_SIZE)
      .height(32)
      .padding({ top: 12, bottom: 12 })
      .justifyContent(FlexAlign.Center)
      .margin({ top: 4 })
    }
  }
}
