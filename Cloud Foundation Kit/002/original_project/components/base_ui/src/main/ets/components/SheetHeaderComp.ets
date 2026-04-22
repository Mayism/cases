
@ComponentV2
export struct SheetHeaderComp {
  @Param title: ResourceStr = '';
  @Event close: () => void = () => {
  }

  build() {
    Column() {
      Row().width(48).height(4).backgroundColor($r('sys.color.icon_fourth')).borderRadius(2)
      Row() {
        Text(this.title)
          .fontSize($r('sys.float.Title_S'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
        Image($r('app.media.ic_close')).width(40).onClick(() => {
          this.close()
        })
      }
      .width($r('app.string.full_size'))
      .padding({top:4,bottom:8})
      .justifyContent(FlexAlign.SpaceBetween)
    }
  }
}