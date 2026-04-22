import { CommonSheet, Constants, CONTAINER_STYLE, formatDateToMonthDay } from 'common';
import { CHOOSE_NUM, CHOOSE_TIME, WEEK_DAYS } from '../../constants/Constants';
import { BookVM } from '../../viewmodels/BookVM';

@ComponentV2
export struct BookFilterListCom {
  vm: BookVM = BookVM.instance;

  build() {
    Column() {

      Row() {
        SymbolGlyph($r('sys.symbol.calendar_fill'))
          .fontSize(24)
          .fontColor([$r('sys.color.icon_secondary'), '#000000'])
          .margin({ right: $r('app.string.margin_16') })
        Text('预约时间').descTextStyle()
        Row({ space: 4 }) {
          Text(this.vm.timeStr).valueTextStyle()
          Image($r('app.media.ic_right_arrow')).width(16)
        }.onClick(() => {
          this.vm.tempDayIndex = this.vm.filterIndexes[1];
          this.vm.tempTimeIndex = this.vm.filterIndexes[2];
          this.vm.showTime = true;
        })
      }.height(56).bindSheet($$this.vm.showTime, this.timeBindSheetBuilder, { height: SheetSize.FIT_CONTENT })

      Divider().margin({ left: 40 })
      Row() {
        SymbolGlyph($r('sys.symbol.person_2_fill'))
          .fontSize(24)
          .fontColor([$r('sys.color.icon_secondary'), '#000000'])
          .margin({ right: $r('app.string.margin_16') })
        Text('预定就餐人数').descTextStyle()
        Row({ space: 4 }) {
          Text(this.vm.headCount + '人').valueTextStyle()
          Image($r('app.media.ic_right_arrow')).width(16)
        }.onClick(() => {
          this.vm.showCount = true;
        })
      }.height(56).bindSheet($$this.vm.showCount, this.countBindSheetBuilder, { height: SheetSize.FIT_CONTENT })

      Divider().margin({ left: 40 })
      Row() {
        Image($r('app.media.ic_door_service_fill')).width(24).height(24).margin({ right: $r('app.string.margin_16') })
        Text('预订包间').descTextStyle()
        Toggle({ type: ToggleType.Switch, isOn: $$this.vm.isPrivateRoom }).size({ height: 20, width: 36 })
      }.height(56)
    }
    .attributeModifier(CONTAINER_STYLE).bindSheet(true, this.initBindSheetBuilder, {
      height: SheetSize.FIT_CONTENT,
      showClose: true,
      preferType: SheetType.CENTER,
      title: { title: '' },
      onAppear: () => {
        this.vm.timeListController.scrollToIndex(this.vm.filterIndexes[2])
      },
    })
  }

  @Builder
  initBindSheetBuilder() {
    Column({ space: 22 }) {
      Column({ space: 16 }) {
        List({ space: 12 }) {
          ForEach(CHOOSE_NUM, (num: number, index) => {
            ListItem() {
              Text(num + '人')
                .fontSize(12)
                .fontColor(this.vm.filterIndexes[0] === index ?
                  $r('app.color.system_color_background_white') : $r('sys.color.font_primary'))
            }
            .onClick(() => {
              this.vm.filterIndexes[0] = index;
            })
            .width(60)
            .height(28)
            .borderRadius($r('app.string.border_radius_14'))
            .backgroundColor(this.vm.filterIndexes[0] === index ?
              $r('app.color.brand_red') : '#E9E9E9')
          }, (num: number, index) => num + '' + index)
        }.listStyle()

        List({ space: 12 }) {
          ForEach(this.vm.dates, (date: Date, index) => {
            ListItem() {
              Column({ space: 2 }) {
                Text(formatDateToMonthDay(date, index))
                  .fontSize($r('sys.float.Body_M'))
                  .fontColor(this.vm.filterIndexes[1] === index ?
                    $r('sys.color.font_on_primary') : $r('sys.color.font_primary'))
                  .height(20)
                  .constraintSize({ minWidth: 58 })
                  .textAlign(TextAlign.Center)
                Text(WEEK_DAYS[date.getDay()])
                  .fontSize($r('sys.float.Body_M'))
                  .fontColor(this.vm.filterIndexes[1] === index ?
                    $r('sys.color.font_on_secondary') : $r('sys.color.font_secondary'))
                  .height(20)
                  .width(56)
                  .textAlign(TextAlign.Center)
              }
              .alignItems(HorizontalAlign.Center)
              .borderRadius($r('app.string.border_radius_14'))
              .backgroundColor(this.vm.filterIndexes[1] === index ?
                $r('app.color.brand_red') : $r('sys.color.comp_background_tertiary'))
              .padding({
                top: 4,
                bottom: 4,
                left: 8,
                right: 8,
              })
              .height(Constants.FULL_SIZE)
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .onClick(() => {
              this.vm.filterIndexes[1] = index;
              if (this.vm.filterIndexes[1] === 0 && isTimeEarlier(CHOOSE_TIME[0][1])) {
                this.vm.filterIndexes[2] = this.vm.filterIndexes[2] || 3;
              }
            })
            .height(50)
          }, (num: number, index) => num + '' + index)
        }.listStyle()

        List({ space: 12, scroller: this.vm.timeListController }) {
          ForEach(CHOOSE_TIME, (time: [string, string], index) => {
            PeriodItemCom({ time: time, index: index })
          }, (num: number, index) => num + '' + index)
        }.listStyle()

        Row({ space: 4 }) {
          Text('预约包间').fontSize(12).fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Medium)
          Toggle({ type: ToggleType.Switch, isOn: $$this.vm.isPrivateRoom }).size({ height: 20, width: 36 })
        }
        .width(Constants.FULL_SIZE)
        .padding({ left: $r('app.string.padding_16') })
      }
    }
    .width(Constants.FULL_SIZE).padding({ bottom: 32 })
  }

  @Builder
  timeBindSheetBuilder() {
    CommonSheet({
      title: '时间选择',
      cancel: () => {
        this.vm.showTime = false;
      },
      confirm: () => {
        this.vm.confirmPickerTime();
      },
    }) {
      Row() {
        TextPicker({ range: this.vm.datesRange, selected: $$this.vm.tempDayIndex })
          .selectedTextStyle({ color: $r('app.color.brand_red') })
        TextPicker({ range: this.vm.timesRange, selected: $$this.vm.tempTimeIndex }).layoutWeight(1)
          .selectedTextStyle({ color: $r('app.color.brand_red') })
      }
      .height(200)
    }
  }

  @Builder
  countBindSheetBuilder() {
    CommonSheet({
      title: '人数选择',
      cancel: () => {
        this.vm.tempCountIndex = this.vm.filterIndexes[0];
        this.vm.showCount = false;
      },
      confirm: () => {
        this.vm.filterIndexes[0] = this.vm.tempCountIndex;
        this.vm.showCount = false;
      },
    }) {
      TextPicker({ range: this.vm.countRange, selected: $$this.vm.tempCountIndex })
        .selectedTextStyle({ color: $r('app.color.brand_red') })
        .divider({
          strokeWidth: 1,
          startMargin: 98,
          endMargin: 98,
          color: '#eac4b9',
        })
        .height(200)
        .width(Constants.FULL_SIZE)
    }
  }
}

@Extend(Text)
function descTextStyle() {
  .fontSize($r('sys.float.Subtitle_M'))
  .fontColor($r('sys.color.font_primary'))
  .fontWeight(FontWeight.Medium)
  .layoutWeight(1)
}

@Extend(Text)
function valueTextStyle() {
  .fontSize(14)
  .fontColor($r('sys.color.font_secondary'))
}

@Extend(List)
function listStyle() {
  .width(Constants.FULL_SIZE)
  .contentStartOffset(16)
  .contentEndOffset(16)
  .listDirection(Axis.Horizontal)
  .scrollBar(BarState.Off)
}

@ComponentV2
export struct PeriodItemCom {
  @Require @Param time: string[];
  @Require @Param index: number;
  vm: BookVM = BookVM.instance;

  @Computed
  get bgColor() {
    if (this.vm.filterIndexes[1] === 0 && isTimeEarlier(this.time[1])) {
      return '#E8EAEB';
    }
    return this.vm.filterIndexes[2] === this.index ? $r('app.color.brand_red') : '#E9E9E9';
  }

  @Computed
  get textColor() {
    if (this.vm.filterIndexes[1] === 0 && isTimeEarlier(this.time[1])) {
      return $r('sys.color.font_tertiary');
    }
    return this.vm.filterIndexes[2] === this.index ?
      $r('app.color.system_color_background_white') : $r('sys.color.font_primary');
  }

  build() {
    ListItem() {
      Text(this.time[0] + '-' + this.time[1])
        .fontSize(12)
        .fontColor(this.textColor)
    }
    .onClick(() => {
      if (this.vm.filterIndexes[1] !== 0 || !isTimeEarlier(this.time[1])) {
        this.vm.filterIndexes[2] = this.index;
      }
    })
    .padding({
      top: 4,
      bottom: 4,
      left: 8,
      right: 8,
    })
    .borderRadius($r('app.string.border_radius_14'))
    .backgroundColor(this.bgColor)
  }
}

function isTimeEarlier(timeStr: string): boolean {
  const currentTime = new Date();
  const timeArr = timeStr.split(':');
  const hours = Number(timeArr[0]);
  const minutes = Number(timeArr[1]);
  const targetTime =
    new Date(currentTime.getFullYear(), currentTime.getMonth(), currentTime.getDate(), hours, minutes);
  return targetTime < currentTime;
}