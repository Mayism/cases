import { UILicensePlate } from '../components/UILicensePlate';

@Entry
@ComponentV2
struct Sample1 {
  @Local plateNumber: string = '';

  build() {
    NavDestination() {
      Column() {
        UILicensePlate({
          //  传入的车牌号
          plateNumber: this.plateNumber,
          //  是否默认激活键盘，选中输入框
          intFocus: false,
          //  输入完整车牌后触发回调，获取车牌号
          onChange: (carNumber: string[], isComplete: boolean) => {
            console.log('当前输入车牌号', carNumber, '是否为完整车牌号', isComplete);
          },
          //  传入车牌号格式错误时触发
          onFormatError: (plateNumber: string) => {
            console.log('格式错误的车牌号', plateNumber);
          },
        })
      }
      .padding(10)
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .title('车牌输入')
  }
}