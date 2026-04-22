@ComponentV2
export struct CommonListItem {
  @Param pic: ResourceStr = '';
  @Param desc: string = '';
  @Param value: string = '';

  build() {
      Row() {
        if (this.pic){
          Image(this.pic).width(24).margin({ right: $r('app.string.margin_8') })
        }
        Text(this.desc)
          .layoutWeight(1)
          .fontSize($r('sys.float.Subtitle_M'))
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Medium)
          .margin({ right: $r('app.string.margin_8') })
        Text(this.value)
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.font_secondary'))
          .maxLines(1)
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }.height(48)
  }
}