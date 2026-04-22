class ButtonConstant {
  // 背景颜色
  static readonly BG_COLOR: ResourceColor = '#ED6F21';
  // 按钮高度
  static readonly HEIGHT: Length = 40;
}

@ComponentV2
export struct CommonButton {
  // 按钮文字
  @Param title: string = '';
  // 按钮操作
  @Event handleClick: () => void;

  build() {
    Button(this.title)
      .width('calc(100% - 56vp)')
      .fontWeight(FontWeight.Medium)
      .height(ButtonConstant.HEIGHT)
      .fontSize($r('sys.float.Body_L'))
      .fontColor($r('sys.color.font_on_primary'))
      .backgroundColor(ButtonConstant.BG_COLOR)
      .onClick(() => {
        this.handleClick();
      })
  }
}