import { TitleBar, CommonConst } from 'foundation';
import { HomeTabVM } from '../viewmodels/HomeTabVM';

@ComponentV2
struct HomeTab {

  private model: HomeTabVM = HomeTabVM.getInstance();

  public build(): void {
    Column() {
      TitleBar({ title: '首页' })
      Scroll() {
        GridRow({
          columns: 12,
          breakpoints: { value: ['320vp', '600vp', '840vp'] }
        }) {
          GridCol({
            span: { xs: 12, sm: 12, md: 10, lg: 8 },
            offset: { xs: 0, sm: 0, md: 1, lg: 2 }
          }) {
            Column({ space: 12 }) {
              this.buildBannerSwiper()
              this.buildCheckInButton()
            }
            .width('100%')
            .padding({ left: 16, right: 16, bottom: 12 })
            .justifyContent(FlexAlign.Start)
          }
        }
        .constraintSize({ minHeight: '100%' })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
  }

  @Builder
  private buildBannerSwiper(): void {
    Swiper() {
      ForEach(CommonConst.HOME_BANNER_LIST, (item: ResourceStr) => {
        Image(item)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
          .draggable(false)
      }, (item: ResourceStr, index: number) => index + String(item))
    }
    .width('100%')
    .aspectRatio(21 / 10) // AspectRatio = Width / Height
    .indicator(Indicator.dot().selectedColor($r('sys.color.multi_color_09')))
    .loop(true)
    .autoPlay(true)
    .borderRadius(16)
    .backgroundColor(Color.Gray)
  }

  @Builder
  private buildCheckInButton(): void {
    Stack({ alignContent: Alignment.Start}) {
      RelativeContainer() {
        Image($r('app.media.ic_check_in_shadow'))
          .height(72)
          .draggable(false)
          .objectFit(ImageFit.Contain)
          .alignRules({
            center: { anchor: 'ic_check_in', align: VerticalAlign.Center },
            middle: { anchor: 'ic_check_in', align: HorizontalAlign.Center }
          })
          .translate({ x: -6, y: 6, z: -72 })
        Image($r('app.media.ic_check_in'))
          .height(72)
          .margin({ left: 16 })
          .draggable(false)
          .objectFit(ImageFit.Contain)
          .offset({ y: -4 })
          .id('ic_check_in')
      }
      .width('auto')
      .height('auto')
      Text('去签到')
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontColor($r('sys.color.font_on_primary'))
        .fontSize($r('sys.float.Title_M'))
        .fontWeight(FontWeight.Bold)
        .offset({ y: -8 })
      Row() {
        Button() {
          SymbolGlyph($r('sys.symbol.chevron_forward'))
            .fontSize(24)
            .fontColor([$r('sys.color.multi_color_09')])
            .fontWeight(FontWeight.Normal)
        }
        .width(40)
        .height(40)
        .margin({ right: 16, bottom: 16 })
        .type(ButtonType.Circle)
        .backgroundColor($r('sys.color.comp_background_primary'))
      }
      .width('100%')
      .height('100%')
      .alignItems(VerticalAlign.Bottom)
      .justifyContent(FlexAlign.End)
    }
    .width('100%')
    .height(96)
    .clip(true)
    .borderRadius(16)
    .linearGradient({
      angle: '270deg',
      colors: [['#FFED6F21', 0], ['#FFFFC39F', 1]]
    })
    .onClick(() => this.model.goToCheckinPage())
  }
}

@Builder
export function buildHomeTab(): void {
  HomeTab()
}
