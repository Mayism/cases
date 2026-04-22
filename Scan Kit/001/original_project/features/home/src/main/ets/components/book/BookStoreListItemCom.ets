import { UISkeleton } from '@hw-agconnect/ui-skeleton';
import { formatDistance, StoreInfo } from 'common';
import { BookVM } from '../../viewmodels/BookVM';

@ComponentV2
export struct BookStoreListItemCom {
  @Require @Param store: StoreInfo
  vm: BookVM = BookVM.instance;

  @Computed
  get labelText() {
    if (this.vm.isPrivateRoom) {
      return this.store.privateRoom[this.vm.period] === 0 ? '包间已满' : '包间空闲';
    }
    return this.store.diningHall[this.vm.period] === 0 ? '大厅已满' : '大厅空闲';
  }

  @Computed
  get canBook() {
    const lefts: number[] = this.vm.isPrivateRoom ? this.store.privateRoom : this.store.diningHall;
    return lefts[this.vm.period] !== 0;
  }

  build() {
    Row({ space: 8 }) {
      Image($r('app.media.ic_book_show')).width(32).borderRadius($r('app.string.border_radius_8')).clip(true)
      Row({ space: 30 }) {
        Column({ space: 4 }) {
          Row({ space: 8 }) {
            Text(this.store.name).fontSize(14).fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Medium)
            if (this.store.distance){
              Text('距您' + formatDistance(this.store.distance)).fontSize(10).fontColor($r('sys.color.font_primary'))
            }
          }

          Text(this.store.address).fontSize(10).fontColor($r('sys.color.font_secondary')).margin({ top: 4, bottom: 8 })
          Row({ space: 12 }) {
            Text('支持预订').labelTextStyle()
            Text(this.labelText).labelTextStyle()
          }
        }.alignItems(HorizontalAlign.Start).layoutWeight(1)

        Text('预订')
          .borderRadius('50%')
          .fontColor($r('app.color.system_color_background_white'))
          .fontSize(12)
          .backgroundColor(this.canBook ? $r('app.color.brand_red') : $r('sys.color.font_tertiary'))
          .height(28)
          .width(48)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.vm.jumpToBookOrder(this.store);
          })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
    }
    .alignItems(VerticalAlign.Top)
  }
}

@Extend(Text)
function labelTextStyle() {
  .fontSize(10)
  .backgroundColor('#E8E8E8')
  .fontColor($r('sys.color.font_secondary'))
  .borderRadius($r('app.string.border_radius_10'))
  .padding({
    left: 8,
    right: 8,
    top: 3,
    bottom: 3,
  })
}

@ComponentV2
export struct SkeletonListItemCom {
  build() {
    Row({ space: 8 }) {
      Row() {
        UISkeleton({
          loading: true,
          duration: 600,
          alignCol: FlexAlign.Start,
          options: [{ size: 34, radius: 8 }],
        })
      }.width(34)

      Row() {
        UISkeleton({
          loading: true,
          duration: 600,
          spaceCol: 6,
          options: [
            { width: '70%', height: 16 },
            { width: '90%', height: 12, margin: { bottom: 4 } },
            { width: '40%', height: 14 },
          ],
        })
      }.layoutWeight(1)

      Row() {
        UISkeleton({
          loading: true,
          duration: 600,
          options: [{ width: 48, height: 28, radius: '50%' }],
          alignCol: FlexAlign.Center,
        })
      }
      .width(48)
    }
    .height(65)
  }
}