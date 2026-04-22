import { UtilLog } from '@hw-agconnect/util-log';
import { CommonButton, CommonPage, Constants, CONTAINER_STYLE } from 'common';
import { BookInputSheetCom } from '../../components/book/BookInputSheetCom';
import { BookOrderInfoCom } from '../../components/book/BookOrderInfoCom';
import { BookSpecialServiceCom } from '../../components/book/BookSpecialServiceCom';
import { BookVM } from '../../viewmodels/BookVM';

@ComponentV2
export struct BookOrderPage {
  vm: BookVM = BookVM.instance;
  @Local isShowRemarkSheet: boolean = false;

  aboutToAppear(): void {
    this.vm.resetBookOrderParams();
  }

  build() {
    CommonPage({
      title: '预约信息',
      mainUi: () => {
        this.bookOrderMainUiBuilder();
      },
      bottomUi: () => {
        this.bookOrderBottomUiBuilder();
      },
    })
  }

  @Builder
  bookOrderMainUiBuilder() {
    /** 就餐信息 **/
    this.bookDinnerInfoBuilder()

    /** 基本信息 **/
    BookOrderInfoCom()

    /** 特殊需求 **/
    BookSpecialServiceCom()

    /** 备注信息 **/
    this.tipsBuilder()

    Blank().layoutWeight(1)
  }

  @Builder
  bookOrderBottomUiBuilder() {
    CommonButton({
      title: '立即预订',
      handleClick: async () => {
        await this.vm.createBookOrder();
      },
    })
  }

  @Builder
  bookDinnerInfoBuilder() {
    Column() {
      Row() {
        Text('就餐信息').fontSize($r('sys.float.Subtitle_L'))
          .fontColor($r('sys.color.font_on_primary'))
          .fontWeight(FontWeight.Bold).layoutWeight(1)
        Image($r('app.media.ic_book_order')).width(40).height(40)
      }
      .width(Constants.FULL_SIZE)
      .height(56)
      .linearGradient({ direction: GradientDirection.Left, colors: [['#ED6F21', 1], ['#ED6F21', 0.6]] })
      .padding({ left: 16, right: 12 })

      Column() {
        Row() {
          SymbolGlyph($r('sys.symbol.calendar_fill'))
            .fontSize(24)
            .fontColor([$r('sys.color.icon_secondary'), '#000000'])
          Text('预约时间').primaryTextStyle().layoutWeight(1).margin({ left: $r('app.string.margin_16') })
          Text(this.vm.timeStr).secondaryTextStyle()
        }

        Divider().margin({ left: 40, top: 12, bottom: 12 })

        Row() {
          SymbolGlyph($r('sys.symbol.person_2_fill'))
            .fontSize(24)
            .fontColor([$r('sys.color.icon_secondary'), '#000000'])
          Text('就餐人数').primaryTextStyle().layoutWeight(1).margin({ left: $r('app.string.margin_16') })
          Text(`${this.vm.headCount}人`).secondaryTextStyle()
        }

        Divider().margin({ left: 40, top: 12, bottom: 12 })

        Row() {
          Image($r('app.media.ic_door_service_fill')).width(24).height(24)
          Text('预约包间').primaryTextStyle().layoutWeight(1).margin({ left: $r('app.string.margin_16') })
          Toggle({ type: ToggleType.Switch, isOn: $$this.vm.isPrivateRoom })
            .size({ height: 20, width: 36 })
            .enabled(false)
        }
      }.padding($r('app.string.padding_12')).backgroundColor($r('app.color.system_color_background_white'))
    }.width(Constants.FULL_SIZE)
    .borderRadius($r('app.string.border_radius_16'))
    .clip(true)

  }

  @Builder
  tipsBuilder() {
    Column() {
      Text('备注').titleTextStyle()
      Stack() {
        TextArea({ text: $$this.vm.tips, placeholder: '请填写备注信息' })
          .enabled(false)
          .placeholderColor($r('sys.color.font_secondary'))
          .placeholderFont({ size: $r('sys.float.Body_L') })
          .maxLength(50)
          .showCounter(true)
          .width(Constants.FULL_SIZE)
          .height(84)
          .borderRadius($r('app.string.border_radius_8'))
          .backgroundColor($r('sys.color.comp_background_primary'))
      }
      .attributeModifier(CONTAINER_STYLE)
      .bindSheet($$this.isShowRemarkSheet, this.remarkSheet(), {
        height: 500,
        backgroundColor: $r('sys.color.background_secondary'),
        showClose: false,
        preferType:SheetType.BOTTOM,
        blurStyle: BlurStyle.Regular,
      })
      .onClick(() => {
        this.isShowRemarkSheet = true;
      })
    }
  }

  @Builder
  remarkSheet() {
    BookInputSheetCom({
      remark: this.vm.tipTemps,
      confirmRemarks: (remark) => {
        this.isShowRemarkSheet = false;
        this.vm.tips = remark;
        this.vm.tipTemps = remark;
      },
      close: (remark) => {
        this.vm.tipTemps = remark;
        this.isShowRemarkSheet = false;
      }
    });
  }
}

@Extend(Text)
function titleTextStyle() {
  .fontSize($r('sys.float.Subtitle_L'))
  .fontColor($r('sys.color.font_primary'))
  .fontWeight(FontWeight.Bold)
  .width(Constants.FULL_SIZE)
  .padding({ top: 12, bottom: 8 })
}

@Extend(Text)
function primaryTextStyle() {
  .fontSize($r('sys.float.Body_M'))
  .fontColor($r('sys.color.font_primary'))
  .fontWeight(FontWeight.Medium)
}

@Extend(Text)
function secondaryTextStyle() {
  .fontSize($r('sys.float.Body_M'))
  .fontColor($r('sys.color.font_secondary'))
}

@Builder
export function bookOrderPageBuilder() {
  BookOrderPage()
}