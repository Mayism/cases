import { CommonSheet, Constants, CONTAINER_STYLE } from 'common';
import { CHOOSE_NUM } from '../../constants/Constants';
import { QueueVM } from '../../viewmodels/QueueVM';

@ComponentV2
export struct QueueFilterListCom {
  vm: QueueVM = QueueVM.instance;

  build() {
    Column() {

        Row() {
          SymbolGlyph($r('sys.symbol.calendar_fill'))
            .fontSize(24)
            .fontColor([$r('sys.color.icon_secondary'), '#000000'])
            .margin({ right: $r('app.string.margin_16') })
          Text('就餐时间').descStyle()
          Row({ space: 4 }) {
            Text(this.vm.timeStr).valueStyle()
          }
        }
      Divider().margin({ left: 40,top:12,bottom:12 })

        Row() {
          SymbolGlyph($r('sys.symbol.person_2_fill'))
            .fontSize(24)
            .fontColor([$r('sys.color.icon_secondary'), '#000000'])
            .margin({ right: $r('app.string.margin_16') })
          Text('就餐人数').descStyle()
          Row({ space: 4 }) {
            Text(this.vm.headCount + '人').valueStyle()
            Image($r('app.media.ic_right_arrow')).width(16)
          }.onClick(() => {
            this.vm.showCount = true;
          })
      }.bindSheet($$this.vm.showCount, this.countBindSheetBuilder, { height: SheetSize.FIT_CONTENT })

    }
    .attributeModifier(CONTAINER_STYLE)
  }

  @Builder
  countBindSheetBuilder() {
    CommonSheet({
      title: '就餐人数',
      cancel: () => {
        this.vm.tempCountIndex = this.vm.headCount;
        this.vm.showCount = false;
      },
      confirm: () => {
        this.vm.headCount = CHOOSE_NUM[this.vm.tempCountIndex];
        this.vm.showCount = false;
      },
      ui: () => {
        this.textBuilder();
      },
    })
  }

  @Builder
  textBuilder() {
    TextPicker({ range: this.vm.countRange, selected: $$this.vm.tempCountIndex })
      .selectedTextStyle({ color: $r('app.color.brand_red') })
      .divider({
        strokeWidth: 0,
        startMargin: 98,
        endMargin: 98,
        color: '#00000000',
      })
      .height(200)
      .width(Constants.FULL_SIZE)
  }
}

@Extend(Text)
function valueStyle() {
  .fontSize(14)
  .fontColor($r('sys.color.font_secondary'))
}

@Extend(Text)
function descStyle() {
  .fontSize($r('sys.float.Subtitle_M'))
  .fontColor($r('sys.color.font_primary'))
  .fontWeight(FontWeight.Medium)
  .layoutWeight(1)
}