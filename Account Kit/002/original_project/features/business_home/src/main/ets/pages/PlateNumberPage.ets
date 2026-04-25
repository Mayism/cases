import {
  Constants,
  HttpRequest,
  NavHeaderBar,
  PaymentRouter,
  PLATE_COLOR_TYPE,
  PLATE_TYPE,
  PlateNumber,
  RouterMap,
  RouterUtil,
  ContextUtils,
} from 'lib_common';
import { UILicensePlate } from 'module_keyboard';
import { AddPlateComp } from '../components/AddPlateComp';

@Builder
export function PlateNumberPageBuilder() {
  PlateNumberPage()
}

@ComponentV2
struct PlateNumberPage {
  @Local myPlates: Array<PlateNumber> = [];
  @Local plate: string = '';
  @Local selectPlate: string = '';
  @Local plateType: number = 1;
  @Local plateColorType: string = '';
  @Local addPlateFlag: boolean = false;
  plateController: TextInputController = new TextInputController();

  build() {
    NavDestination() {
      NavHeaderBar({ title: $r('app.string.parking_payment'), hasBgColor: false })
      Column({ space: 16 }) {
        Row() {
          Text('普通车牌')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.plateType === PLATE_TYPE.NORMAL ? $r('sys.color.font_on_primary') :
              $r('sys.color.font_secondary'))
            .borderRadius(18)
            .backgroundColor(this.plateType === PLATE_TYPE.NORMAL ? $r('app.color.app_theme') :
              '#00000000')
            .padding({
              top: 8,
              left: 60,
              right: 60,
              bottom: 8,
            })
            .layoutWeight(1)
            .onClick(() => {
              this.plateType = PLATE_TYPE.NORMAL
            })
          Text('特殊车牌')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.plateType === PLATE_TYPE.SPECIAL ? $r('sys.color.font_on_primary') :
              $r('sys.color.font_secondary'))
            .borderRadius(18)
            .backgroundColor(this.plateType === PLATE_TYPE.SPECIAL ? $r('app.color.app_theme') :
              '#00000000')
            .padding({
              top: 8,
              left: 60,
              right: 60,
              bottom: 8,
            })
            .layoutWeight(1)
            .onClick(() => {
              this.plateType = PLATE_TYPE.SPECIAL
            })
        }
        .width('100%')
        .padding(2)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .borderRadius(20)

        if (this.plateType === PLATE_TYPE.NORMAL) {
          UILicensePlate({
            //是否默认激活键盘，选中输入框
            plateNumber: this.selectPlate,
            //是否默认激活键盘，选中输入框
            intFocus: false,
            //输入完整车牌后触发回调，获取车牌号
            onChange: (res: string[]) => {
              this.plate = res.join('')
            },
          })
        } else {
          TextInput({ text: $$this.plate, placeholder: '请输入车牌' })
            .placeholderFont({ size: $r('sys.float.Body_L') })
            .placeholderColor($r('sys.color.font_secondary'))
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_primary'))
            .borderRadius(4)
            .textAlign(TextAlign.Center)
            .padding({
              top: 14,
              bottom: 14,
            })
            .margin({ top: 8 })
        }

        Flex({ wrap: FlexWrap.Wrap }) {
          Row({ space: 4 }) {
            Image($r('app.media.ic_plus'))
              .width(10)
              .padding(2)
              .backgroundColor($r('app.color.app_theme'))
              .borderRadius(10)
            Text('新增车牌').fontColor(Color.White).fontSize(14).fontColor($r('app.color.app_theme'))
          }
          .padding({
            left: 12,
            right: 12,
            top: 4,
            bottom: 4,
          })
          .borderRadius(8)
          .backgroundColor($r('sys.color.background_secondary'))
          .onClick(() => {
            this.addPlateFlag = true;
          })
          .bindSheet($$this.addPlateFlag, this.addPlateSheet(), {
            detents: [740, SheetSize.LARGE],
            preferType: SheetType.CENTER,
            backgroundColor: $r('sys.color.background_primary'),
            showClose: false,
            onWillDisappear: () => {
              this.plateController.stopEditing();
            },
          });

          ForEach(this.myPlates, (item: PlateNumber) => {
            Text(`${item.plate.slice(0, 2)}-${item.plate.slice(2)}`)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
              .borderRadius(16)
              .margin({ left: 8, bottom: 10 })
              .padding({
                left: 8,
                right: 8,
                top: 4,
                bottom: 4,
              })
              .linearGradient({
                direction: GradientDirection.Right, // 渐变方向
                repeating: false, // 渐变颜色是否重复
                colors: this.getPlateColor(item.type), // 数组末尾元素占比小于1时满足重复着色效果
              })
              .onClick(() => {
                this.selectPlate = item.plate
              })
          }, (v: PlateNumber) => JSON.stringify(v))
        }
        .width('100%')
        .margin({ top: 20 })

        Button('查询费用')
          .fontColor($r('sys.color.font_on_primary'))
          .width('100%')
          .height(40)
          .backgroundColor($r('app.color.app_theme'))
          .margin({ top: 32, bottom: 16 })
          .onClick(() => {
            if (!this.plate || this.plate.length < 7) {
              ContextUtils.showToast({ message: '请输入完整的车牌' });
              return
            }
            RouterUtil.pushPathByName(RouterMap.PAY_DETAIL_PAGE, { plate: this.plate } as PaymentRouter)
          })
      }
      .width(Constants.FULL_SIZE)
      .layoutWeight(1)
      .padding({ top: 12, left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH })
    }
    .onShown(() => {
      this.getPlateNumber()
    })
    .hideTitleBar(true)
  }

  @Builder
  addPlateSheet() {
    AddPlateComp({
      plateController: this.plateController,
      onSuccess: () => {
        this.getPlateNumber();
        this.addPlateFlag = false;
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

  getPlateColor(type: string): [ResourceColor, number][] {
    if (type === PLATE_COLOR_TYPE.GREEN) {
      return [['#17CFFF', 0.0], ['#B6F0FF', 1]]
    } else if (type === PLATE_COLOR_TYPE.YELLOW) {
      return [['#FFBF17', 0.0], ['#FFE2A3', 1]]
    } else {
      return [['#7FDE3C', 0.0], ['#DDFFB8', 1]]
    }
  }
}
