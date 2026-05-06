import { AppStorageV2 } from '@kit.ArkUI';
import {
  Constants,
  EmptyComp,
  HttpRequest,
  NavHeaderBar,
  PLATE_COLOR_TYPE,
  PLATE_TYPE,
  PlateNumber,
  WindowModel,
} from 'lib_common';
import { AddPlateComp } from '../components/AddPlateComp';

@Builder
export function PlateNumberMgtPageBuilder() {
  PlateNumberMgtPage()
}

@ComponentV2
struct PlateNumberMgtPage {
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
  @Local myPlates: Array<PlateNumber> = [];
  @Local addPlateFlag: boolean = false;
  private scroller: Scroller = new Scroller();
  plateController: TextInputController = new TextInputController();

  build() {
    NavDestination() {
      NavHeaderBar({ title: $r('app.string.my_car'), hasBgColor: false })
      Scroll() {
        Column() {
          Image($r('app.media.parking_banner'))
            .width(Constants.FULL_SIZE)
            .borderRadius(12)
            .constraintSize({
              maxHeight: '35%',
            })
          Column() {
            List({ space: 16, scroller: this.scroller }) {
              ForEach(this.myPlates, (item: PlateNumber) => {
                ListItem() {
                  Row() {
                    Row() {
                      Stack() {
                        Circle().width(32).height(32).fill(Color.White)
                        Image(this.getIcon(item))
                          .width(20)
                          .fillColor(this.getIconFg(item))
                      }
                      .alignContent(Alignment.Center)

                      Text(`${item.plate.slice(0, 2)}-${item.plate.slice(2)}`)
                        .fontSize(18)
                        .fontColor(Color.White)
                        .fontWeight(FontWeight.Bold)
                        .margin({ left: 12 })
                        .fontColor($r('sys.color.font_primary'))
                    }

                    Image($r('app.media.ic_delete')).width(24).onClick(() => {
                      HttpRequest.deletePlateNumber(item.id).then(() => {
                        this.getPlateNumber()
                      })
                    })
                  }
                  .width(Constants.FULL_SIZE)
                  .justifyContent(FlexAlign.SpaceBetween)
                  .borderRadius(16)
                  .padding({
                    left: 16,
                    right: 16,
                    top: 24,
                    bottom: 24,
                  })
                  .backgroundImage(this.getPlateBg(item.type))
                  .backgroundImageSize(ImageSize.Cover)
                }
              }, (item: PlateNumber) => item.id)
            }
            .layoutWeight(1)
            .visibility(this.myPlates.length ? Visibility.Visible : Visibility.None)
            .margin({ top: 12, bottom: 12 })
            .scrollBar(BarState.Off)
            .nestedScroll({
              scrollForward: NestedScrollMode.PARENT_FIRST,
              scrollBackward: NestedScrollMode.SELF_FIRST,
            })

            Column() {
              Button({ type: ButtonType.Normal }) {
                Row() {
                  SymbolGlyph($r('sys.symbol.plus'))
                    .fontColor([$r('sys.color.font_on_primary')])
                    .fontWeight(FontWeight.Normal)
                    .fontSize(24)
                  Text('新增车牌')
                    .fontSize(18)
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('sys.color.font_on_primary'))
                    .margin({ left: 12 })
                }
              }
              .width(Constants.FULL_SIZE)
              .backgroundColor($r('app.color.app_theme'))
              .borderRadius($r('sys.float.corner_radius_level7'))
              .padding({
                top: 16,
                bottom: 16,
              })
              .onClick(() => {
                this.addPlateFlag = true
              })
            }
            .padding({ top: 16 })
          }
          .layoutWeight(this.myPlates.length ? 1 : 0).justifyContent(FlexAlign.SpaceBetween)

          if (!this.myPlates.length) {
            EmptyComp({ text: '暂无车辆' }).margin({ top: 56 })
          }
        }
        .width(Constants.FULL_SIZE)
        .alignItems(HorizontalAlign.Start)
        .padding({
          top: 12,
          left: Constants.BORDER_WIDTH,
          right: Constants.BORDER_WIDTH,
          bottom: this.windowModel.getWindowBottomHeight(),
        })
        .bindSheet($$this.addPlateFlag, this.addPlateSheet(), {
          detents: [740, SheetSize.LARGE],
          backgroundColor: $r('sys.color.background_primary'),
          showClose: false,
          preferType: SheetType.CENTER,
          onWillDisappear: () => {
            this.plateController.stopEditing();
          },
        })
      }
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .onShown(() => {
      this.getPlateNumber()
    }).hideTitleBar(true)
  }

  @Builder
  addPlateSheet() {
    AddPlateComp({
      plateController: this.plateController,
      onSuccess: () => {
        this.getPlateNumber();
        this.addPlateFlag = false;
        this.scroller.scrollEdge(Edge.Bottom);
      },
      onClose: () => {
        this.addPlateFlag = false
      },
    })
  }

  getPlateNumber() {
    HttpRequest.queryPlateNumber().then(res => {
      this.myPlates = res
    })
  }

  getIcon(item: PlateNumber) {
    if (item.kind === PLATE_TYPE.NORMAL) {
      return $r('app.media.ic_plate_normal');
    }
    return $r('app.media.ic_plate_special');
  }

  getIconFg(item: PlateNumber) {
    if (item.type === PLATE_COLOR_TYPE.GREEN) {
      return '#7BB201';
    }
    if (item.type === PLATE_COLOR_TYPE.YELLOW) {
      return '#FCC346';
    }
    return '#4FD7FA';
  }

  getPlateBg(type: string): Resource {
    if (type === PLATE_COLOR_TYPE.GREEN) {
      return $r('app.media.bg_plate_2')
    } else if (type === PLATE_COLOR_TYPE.YELLOW) {
      return $r('app.media.bg_plate_3')
    } else {
      return $r('app.media.bg_plate_1')
    }
  }
}
