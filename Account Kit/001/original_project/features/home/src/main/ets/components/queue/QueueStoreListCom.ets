import { UISkeleton } from '@hw-agconnect/ui-skeleton';
import { Constants, CONTAINER_STYLE, Dialog, formatDistance, StoreInfo } from 'common';
import { QueueVM } from '../../viewmodels/QueueVM';

@ComponentV2
export struct QueueStoreListCom {
  vm: QueueVM = QueueVM.instance;

  aboutToAppear(): void {
    Dialog.init(this.getUIContext());
  }

  build() {
    Column() {
      Row({ space: 16 }) {
        SymbolGlyph($r('sys.symbol.store_fill')).fontSize(24).fontColor([$r('sys.color.icon_secondary'), '#000000'])
        Text('所有门店')
          .fontSize($r('sys.float.Subtitle_M'))
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Medium)
      }.width(Constants.FULL_SIZE).height(56)

      if (!this.vm.searching && this.vm.searchStoreList.length) {
        List({ space: 12 }) {
          ForEach(this.vm.searchStoreList, (store: StoreInfo) => {
            ListItem() {
              this.storeItemBuilder(store)
            }
          }, (store: StoreInfo, index) => JSON.stringify(store) + '_' + index)
        }
        .listStyle()
        .divider({ strokeWidth: 1 })
        .contentStartOffset(8)
        .contentEndOffset(4)
      }

      if (!this.vm.searching && !this.vm.searchStoreList.length) {
        this.nullBuilder()
      }

      if (this.vm.searching) {
        this.skeletonListBuilder()
      }
    }
    .clip(true)
    .attributeModifier(CONTAINER_STYLE)
  }

  @Builder
  storeItemBuilder(store: StoreInfo) {
    Column() {
      Row({ space: 8 }) {
        Row() {
          Image(`${this.vm.appInfoModel.imgBaseUrl}${store.logo}`).width(32).margin({right:8})
          Column({ space: 4 }) {
            Row({ space: 8 }) {
              Text(store.name)
                .fontSize($r('sys.float.Body_M'))
                .fontColor($r('sys.color.font_primary'))
                .fontWeight(FontWeight.Medium)
                .maxLines(1)
                .constraintSize({ maxWidth: '85%' })
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Text('距您' + formatDistance(store.distance))
                .fontSize($r('sys.float.Caption_M'))
                .fontColor($r('sys.color.font_primary'))
            }

            Text(store.address).fontSize($r('sys.float.Caption_M')).fontColor($r('sys.color.font_secondary'))
          }.alignItems(HorizontalAlign.Start).layoutWeight(1).justifyContent(FlexAlign.Center)
        }.layoutWeight(1)

        SymbolGlyph($r('sys.symbol.location_north_up_right'))
          .fontSize(24)
          .fontColor([$r('sys.color.icon_secondary'), '#000000'])
          .margin({ right: 8 })
          .onClick(() => {
            this.vm.goPetalMap(store)
          })

      }.width(Constants.FULL_SIZE).justifyContent(FlexAlign.SpaceBetween)

      Row(){
        Button(store.needQueue ? '去排号' : '无需排号', { controlSize: ControlSize.SMALL })
          .fontColor($r('sys.color.font_on_primary'))
          .backgroundColor(store.needQueue ? $r('app.color.brand_red') : $r('sys.color.font_secondary'))
          .constraintSize({minWidth:28})
          .onClick(() => {
            this.vm.jumpToQueueOrder(store);
          })
      }.width(Constants.FULL_SIZE).justifyContent(FlexAlign.End).margin({ top: 12 })

    }.attributeModifier(CONTAINER_STYLE)

  }

  @Builder
  nullBuilder() {
    Column() {
      Image($r('app.media.ic_store_null')).width(120).height(120)
      Text('暂无门店信息')
        .fontColor($r('sys.color.font_secondary'))
        .fontSize($r('sys.float.Subtitle_S'))
        .lineHeight(19)
        .padding({ bottom: 17 })
    }
    .alignItems(HorizontalAlign.Center)
    .attributeModifier(CONTAINER_STYLE)
  }

  @Builder
  skeletonListBuilder() {
    List({ space: 12 }) {
      ForEach(Array.from({ length: 8 }), () => {
        ListItem() {
          Row() {
            Row() {
              UISkeleton({
                loading: true,
                duration: 600,
                spaceCol: 4,
                alignCol: FlexAlign.Center,
                options: [
                  { width: '60%', height: 16 },
                  { width: '80%', height: 12 },
                ],
              })
            }.layoutWeight(1)

            Row() {
              UISkeleton({
                loading: true,
                duration: 600,
                alignCol: FlexAlign.Center,
                options: [{ width: 56, height: 28, radius: 8 }],
              })
            }.width(56)
          }
        }.height(56).attributeModifier(CONTAINER_STYLE)
      }, (item: null, index) => index.toString())
    }
    .listStyle()
  }
}

@Extend(List)
function listStyle() {
  .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
  .scrollBar(BarState.Off)
  .width(Constants.FULL_SIZE)
}