/**
 * 课程助手 - 功能行组件 (标签+值/输入)
 */

@ComponentV2
export struct FunctionalRow {
  @Param label: string = '';
  @Param value: string = '';
  @Param placeholder: string = '';
  @Param showArrow: boolean = true;
  @Param isInput: boolean = false;
  @Event onRowClick: () => void = () => {};
  @Event onInputChange: (value: string) => void = () => {};

  build() {
    Row() {
      Text(this.label)
        .fontSize(14)
        .fontColor('#1A1A1A')
        .width(72)
        .flexShrink(0)

      if (this.isInput) {
        TextInput({ placeholder: this.placeholder, text: this.value })
          .fontSize(14)
          .fontColor('#1A1A1A')
          .textAlign(TextAlign.End)
          .layoutWeight(1)
          .backgroundColor(Color.Transparent)
          .border({ width: 0 })
          .padding(0)
          .onChange((value: string) => {
            this.onInputChange(value);
          })
      } else {
        Blank()

        Text(this.value)
          .fontSize(14)
          .fontColor(this.value.length > 0 ? '#666666' : '#999999')
          .layoutWeight(1)
          .textAlign(TextAlign.End)

        if (this.showArrow) {
          Text('\u276F')
            .fontSize(12)
            .fontColor('#999999')
            .margin({ left: 4 })
        }
      }
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 12, bottom: 12 })
    .borderRadius(12)
    .onClick(() => {
      if (!this.isInput) {
        this.onRowClick();
      }
    })
  }
}