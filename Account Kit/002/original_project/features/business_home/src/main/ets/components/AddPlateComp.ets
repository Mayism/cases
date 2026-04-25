import { Constants, HttpRequest, PLATE_COLOR_TYPE, PLATE_TYPE, SheetHeaderComp, ContextUtils } from 'lib_common'
import { UILicensePlate } from 'module_keyboard';

@ComponentV2
export struct AddPlateComp {
  @Local plate: string = '';
  @Local plateType: number = 1;
  @Local plateColorType: PLATE_COLOR_TYPE = PLATE_COLOR_TYPE.BLUE;
  @Param plateController: TextInputController = new TextInputController();
  @Event onSuccess: () => void = () => {
  };
  @Event onClose: () => void = () => {
  };

  build() {
    Column() {
      SheetHeaderComp({
        title: '新增车辆', close: () => {
          this.plateController.stopEditing();
          this.onClose();
        },
      })
      Column({ space: 16 }) {
        Row() {
          Text('普通车牌')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.plateType === PLATE_TYPE.NORMAL ? $r('sys.color.font_on_primary') :
            $r('sys.color.font_secondary'))
            .backgroundColor(this.plateType === PLATE_TYPE.NORMAL ? $r('app.color.app_theme') :
              '#00000000')
            .borderRadius(18)
            .padding({
              left: 60,
              right: 60,
              top: 8,
              bottom: 8,
            })
            .onClick(() => {
              this.plateType = PLATE_TYPE.NORMAL
              this.plate = '';
            })
          Text('特殊车牌')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.plateType === PLATE_TYPE.SPECIAL ? $r('sys.color.font_on_primary') :
            $r('sys.color.font_secondary'))
            .backgroundColor(this.plateType === PLATE_TYPE.SPECIAL ? $r('app.color.app_theme') :
              '#00000000')
            .borderRadius(18)
            .padding({
              left: 60,
              right: 60,
              top: 8,
              bottom: 8,
            })
            .onClick(() => {
              this.plateType = PLATE_TYPE.SPECIAL
              this.plate = '';
              this.plateColorType = PLATE_COLOR_TYPE.BLUE;
            })
        }
        .padding(2)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .borderRadius(20)

        if (this.plateType === PLATE_TYPE.NORMAL) {
          UILicensePlate({
            controller: this.plateController,
            //是否默认激活键盘，选中输入框
            intFocus: true,
            //输入完整车牌后触发回调，获取车牌号
            onChange: (res: string[]) => {
              this.plate = res.join('')
            },
          })

          Row() {
            Radio({ value: '1', group: 'radioGroup', indicatorType: RadioIndicatorType.TICK })
              .checked(this.plateColorType === PLATE_COLOR_TYPE.BLUE)
              .radioStyle({
                checkedBackgroundColor: $r('app.color.app_theme'),
              })
              .height(20)
              .width(20)
              .onChange((value: boolean) => {
                if (value) {
                  this.plateColorType = PLATE_COLOR_TYPE.BLUE;
                }
              })
            Text('蓝牌').fontSize(16).fontColor($r('sys.color.font_primary')).margin({ left: 10 })

            Radio({ value: '3', group: 'radioGroup', indicatorType: RadioIndicatorType.TICK })
              .checked(this.plateColorType === PLATE_COLOR_TYPE.YELLOW)
              .radioStyle({
                checkedBackgroundColor: $r('app.color.app_theme'),
              })
              .height(20)
              .width(20)
              .onChange((value: boolean) => {
                if (value) {
                  this.plateColorType = PLATE_COLOR_TYPE.YELLOW;
                }
              })
              .margin({ left: 24 })
            Text('黄牌').fontSize(16).fontColor($r('sys.color.font_primary')).margin({ left: 10 })
          }.width(Constants.FULL_SIZE).justifyContent(FlexAlign.End)
        } else {
          TextInput({ text: $$this.plate, placeholder: '请输入车牌' })
            .placeholderFont({ size: $r('sys.float.Body_L') })
            .placeholderColor($r('sys.color.font_secondary'))
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_primary'))
            .borderRadius(4)
            .textAlign(TextAlign.Center)
            .margin({ top: 8 })
        }

        Button('保存')
          .width(Constants.FULL_SIZE)
          .backgroundColor($r('app.color.app_theme'))
          .borderRadius(20)
          .padding({
            top: 8,
            bottom: 8,
          })
          .margin({ top: 160, left: 12, right: 12 })
          .onClick(() => {
            if (!this.plate) {
              ContextUtils.showToast({ message: '请输入正确的车牌' });
              return
            }
            if (this.plate.length === 8 && this.plateColorType === PLATE_COLOR_TYPE.BLUE) {
              this.plateColorType = PLATE_COLOR_TYPE.GREEN;
            }
            HttpRequest.addPlateNumber(this.plate, this.plateColorType, this.plateType).then(async () => {
              this.plateController.stopEditing();
              this.onSuccess();
            }).catch((e: string) => {
              ContextUtils.showToast({ message: e });
            })
          })
      }
      .layoutWeight(1)
      .backgroundColor($r('sys.color.background_primary'))
      .borderRadius({ topLeft: 12, topRight: 12 })
      .padding({ top: 16 })

    }
    .width(Constants.FULL_SIZE)
    .padding({ left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH })
    .backgroundColor($r('sys.color.background_primary'))
    .constraintSize({ maxWidth: Constants.FULL_SIZE })
  }
}