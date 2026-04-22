import { Constants } from '../../../../Index';
import { RouterModule } from '../utils/RouterModule';

class HeaderConstant {
  // 返回图标尺寸_内
  static readonly ICON_SIZE_INNER: Length = 24;
  // 返回图标尺寸_外
  static readonly ICON_SIZE_OUTER: Length = 40;
  //返回图标背景色
  static readonly ICON_BG_COLOR: Length = $r('sys.color.comp_background_tertiary');
  // 标题字体颜色
  static readonly FONT_COLOR: ResourceStr = $r('sys.color.font_primary');
  // 基础高度
  static readonly HEIGHT: number = 56;
  // 内边距
  static readonly PADDING: Length = 16;
  // 外边距
  static readonly MARGIN: Length = 8;
}

@ComponentV2
export struct CommonHeader {
  // 标题文字
  @Param title: string = '';
  // 返回动画
  @Param backAnimation: boolean = true;
  // 是否展示返回按钮
  @Param showBackButton: boolean = true;

  build() {
    Row() {
      if (this.showBackButton) {
        Row() {
          Image($r('app.media.ic_back_inner')).width(HeaderConstant.ICON_SIZE_INNER)
        }
        .justifyContent(FlexAlign.Center)
        .width(HeaderConstant.ICON_SIZE_OUTER)
        .height(HeaderConstant.ICON_SIZE_OUTER)
        .margin({ right: HeaderConstant.MARGIN })
        .backgroundColor(HeaderConstant.ICON_BG_COLOR)
        .borderRadius('50%')
        .onClick(() => {
          RouterModule.pop(this.backAnimation);
        })
      }
      Text(this.title)
        .fontWeight(this.showBackButton ? FontWeight.Bold : FontWeight.Medium)
        .fontSize(this.showBackButton ? $r('sys.float.Title_S') : $r('sys.float.Title_M'))
        .fontColor(HeaderConstant.FONT_COLOR)
        .padding({ left: this.showBackButton ? 0 : 8 })
    }
    .height(HeaderConstant.HEIGHT)
    .width(Constants.FULL_SIZE)
    .justifyContent(FlexAlign.Start)
    .backgroundColor(Color.Transparent)
    .padding({ left: HeaderConstant.PADDING })
    .margin({ bottom: 12 })
    .expandSafeArea([SafeAreaType.KEYBOARD])
    .zIndex(1)
  }
}