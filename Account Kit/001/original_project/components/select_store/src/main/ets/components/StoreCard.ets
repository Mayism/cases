import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { common, Want } from '@kit.AbilityKit';
import { callTelSheetBuilder } from 'base_ui';
import { SearchItem, StoreInfo } from 'search';

@Builder
export function storeCardBuilder(searchItem:SearchItem){
  StoreCard({storeInfo:searchItem.store,packageName:searchItem.packageName})
}

@ComponentV2
export struct StoreCard {
  @Param @Require storeInfo: StoreInfo
  @Param @Require packageName: string
  @Param isSelect: boolean = false
  @Local callTelSheet: boolean = false

  build() {
    Column() {
      Row() {
        Text(this.storeInfo.name)
          .fontSize(12)
          .fontColor($r('sys.color.font_primary'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .constraintSize({ maxWidth: 180 })
          .layoutWeight(1)

        Row() {
          Image($r('app.media.ic_public_position')).width(12)
          Text(this.storeInfo.distanceStr).fontSize(10).fontColor($r('sys.color.font_secondary')).margin({ left: 8 })
        }.margin({ left: 8 })
      }.width('100%').justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text(this.storeInfo.address).fontSize(10).fontColor($r('sys.color.font_secondary')).maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }.margin({ top: 12 }).constraintSize({ maxWidth: 200 })

      Row() {
        Row() {
          Image($r('app.media.ic_clock_grey')).width(12)
          Text($r('app.string.store_open_time'))
            .fontSize(10)
            .fontColor($r('sys.color.font_secondary'))
            .margin({ left: 8 })
          Text(`${this.storeInfo.time1} - ${this.storeInfo.time2}`)
            .fontSize(10)
            .fontColor($r('sys.color.font_secondary'))
        }

        Row() {
          Image($r('app.media.ic_public_location')).width(24).onClick(() => {
            let coordinates = this.storeInfo.coordinates?.split(',')
            if (coordinates?.length === 2) {
              let latitude: number = Number(coordinates[0])
              let longitude: number = Number(coordinates[1])
              let petalMapWant: Want = {
                bundleName: 'com.huawei.hmos.maps.app',
                uri: 'maps://routes',
                parameters: {
                  linkSource: this.packageName,
                  destinationLatitude: latitude,
                  destinationLongitude: longitude,
                  destinationPoiId: '',
                  destinationName: this.storeInfo.address ?? '',
                },
              }
              let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
              context.startAbility(petalMapWant);
            } else {
              promptAction.showToast({ message: '商户地址错误！' })
            }
          })
          Image($r('app.media.ic_public_telephone')).width(24).margin({ left: 24 }).onClick(() => {
            this.callTelSheet = true
          })
            .bindSheet($$this.callTelSheet, callTelSheetBuilder(this.storeInfo.tel, () => {
              this.callTelSheet = false
            }), {
              detents: [309, 310],
              backgroundColor: $r('sys.color.background_fourth'),
              blurStyle: BlurStyle.Thick,
              preferType: SheetType.CENTER,
              title: { title: $r('app.string.contact_us') },
            });
        }

      }.width('100%').justifyContent(FlexAlign.SpaceBetween).margin({ top: 4 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .border(this.isSelect ? { width: 1, color: $r('sys.color.multi_color_09'), radius: 16 } :
      { width: 1, color: '#26000000', radius: 16 })
    .padding({
      left: 16,
      right: 16,
      top: 8,
      bottom: 8,
    })
  }
}