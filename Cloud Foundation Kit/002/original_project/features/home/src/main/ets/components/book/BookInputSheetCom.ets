@ComponentV2
export struct BookInputSheetCom {
  @Param close: (remark: string) => void = () => {
  };
  @Param confirmRemarks: (remark: string) => void = () => {
  }
  @Once @Param remark: string = '';
  inputId: string = 'ReservationRemark';

  aboutToAppear(): void {
    try {
      setTimeout(() => {
        this.getUIContext().getFocusController().requestFocus(this.inputId);
      }, 100);
    } catch (e) {
    }
  }

  build() {
    Column() {
      // 标题
      this.titleBuilder()
      // 添加笔记输入框
      this.inputBoxBuilder()
    }
    .padding({ left: 12, right: 12 })
  }

  // 标题
  @Builder
  titleBuilder() {
    Row() {
      Row() {
        Image($r('app.media.ic_book_close_btn'))
          .width(40)
          .height(40)
          .onClick(()=>{
            this.close(this.remark)
          })
          .id('close_button')
        Text('添加备注')
          .fontSize($r('sys.float.Title_S'))
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .margin({ left: 12 })
      }

      Image($r('app.media.confirm_btn'))
        .width(40)
        .height(40)
        .onClick(() => {
          this.confirmRemarks(this.remark)
        })
        .id('confirm_button')
    }
    .width('100%')
    .height(56)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  // 添加笔记输入框
  @Builder
  inputBoxBuilder() {
    TextArea({ placeholder: '请填写备注信息', text: this.remark })
      .id(this.inputId)
      .height(100)
      .maxLength(50)
      .showCounter(true)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .onChange((value: string) => {
        this.remark = value;
      })
  }
}