@Component
export struct StoreTitleComp {
  @Prop storeName: ResourceStr

  build() {
    Row() {
      Image($r('app.media.card_store_logo')).width(20).height(20).borderRadius(4);
      Text(this.storeName ? this.storeName : $r('app.string.storeName'))
        .fontSize($r('sys.float.Body_M'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))
        .lineHeight(20)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ left: 8 });
    }.width('100%');
  }
}