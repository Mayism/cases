import { DECORATIONS, TABLE_WARES } from '../../constants/Constants';
import { BookVM } from '../../viewmodels/BookVM';
import { LengthUnit } from '@kit.ArkUI';
import { Constants, CONTAINER_STYLE } from 'common';

@ComponentV2
export struct BookSpecialServiceCom {
  vm: BookVM = BookVM.instance;

  getFontColor(onlyOne: boolean, value: string) {
    if (onlyOne) {
      return this.vm.decoration === value ? $r('app.color.system_color_background_white') :
      $r('sys.color.font_primary');
    }
    return this.vm.tableWares.includes(value) ? $r('app.color.system_color_background_white') :
    $r('sys.color.font_primary');
  }

  getBgColor(onlyOne: boolean, value: string) {
    if (onlyOne) {
      return this.vm.decoration === value ? $r('app.color.brand_red') : $r('sys.color.comp_background_tertiary');
    }
    return this.vm.tableWares.includes(value) ? $r('app.color.brand_red') : $r('sys.color.comp_background_tertiary');
  }

  build() {
    Column(){
      Text('特殊需求').fontSize($r('sys.float.Subtitle_L'))
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Bold)
        .width(Constants.FULL_SIZE)
        .padding({top:12,bottom:8})
      Column({ space: 12 }) {
        this.decorationsBuilder()
        this.tableWaresBuilder()
      }
      .attributeModifier(CONTAINER_STYLE)
    }
  }

  @Builder
  decorationsBuilder() {
    Column({ space: 16 }) {
      Text('装饰类').titleTextStyle()
      Flex({
        wrap: FlexWrap.Wrap,
        space: { main: { value: 12, unit: LengthUnit.VP }, cross: { value: 12, unit: LengthUnit.VP } },
      }) {
        ForEach(DECORATIONS, (item: string) => {
          this.btnBuilder(true, item)
        }, (item: string, index) => item + '_' + index)
      }
    }
  }

  @Builder
  tableWaresBuilder() {
    Column({ space: 16 }) {
      Text('餐具类').titleTextStyle()
      Flex({
        wrap: FlexWrap.Wrap,
        space: { main: { value: 12, unit: LengthUnit.VP }, cross: { value: 12, unit: LengthUnit.VP } },
      }) {
        ForEach(TABLE_WARES, (item: string) => {
          this.btnBuilder(false, item)
        }, (item: string, index) => item + '_' + index)
      }
    }
  }

  @Builder
  btnBuilder(onlyOne: boolean, value: string) {
    Text(value)
      .lineHeight(13)
      .fontSize($r('sys.float.Caption_M'))
      .padding({
        left: 8,
        right: 8,
        top: 5,
        bottom: 5,
      })
      .fontColor(this.getFontColor(onlyOne, value))
      .backgroundColor(this.getBgColor(onlyOne, value))
      .onClick(() => this.vm.specialOpt(onlyOne, value))
      .borderRadius($r('app.string.border_radius_8'))
  }
}

@Extend(Text)
function titleTextStyle() {
  .fontSize($r('sys.float.Subtitle_M'))
  .fontColor($r('sys.color.font_primary'))
  .fontWeight(FontWeight.Medium)
  .width(Constants.FULL_SIZE)
}
