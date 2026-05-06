import { AppStorageV2 } from '@kit.ArkUI';
import { CallTelSheetBuilder, CommonUrl, Constants, MallModel, NavHeaderBar } from 'lib_common';
import { StoreGuideDetailViewModel } from '../viewmodel/StoreGuideDetailViewModel';

@Builder
export function StoreGuideDetailPageBuilder() {
  StoreGuideDetailPage()
}

@ComponentV2
struct StoreGuideDetailPage {
  @Local vm: StoreGuideDetailViewModel = new StoreGuideDetailViewModel();
  @Local mallModel: MallModel = AppStorageV2.connect(MallModel, () => new MallModel()) as MallModel;

  @Computed
  get tagArr() {
    return this.vm.storeGuide.tag.split(',')
  }

  aboutToAppear(): void {
    this.vm.getParams()
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: '店铺详情' })
      Scroll() {
        Column() {
          Image(`${CommonUrl.CLOUD_STORAGE_URL}${this.vm.storeGuide.bigImage}`)
            .width(Constants.FULL_SIZE)
            .constraintSize({
              maxHeight: '40%',
            })
          Column({ space: 12 }) {
            Column({ space: 12 }) {
              Image(`${CommonUrl.CLOUD_STORAGE_URL}${this.vm.storeGuide.logo}`).width(64).height(64).borderRadius(16)
              Text(this.vm.storeGuide.name)
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_primary'))
              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.tagArr, (item: string) => {
                  Row() {
                    Text(item).fontSize(10).fontColor($r('sys.color.font_primary'))
                  }
                  .padding({
                    left: 8,
                    right: 8,
                    top: 4,
                    bottom: 4,
                  })
                  .margin({ right: 8, bottom: 8 })
                  .borderRadius(8)
                  .backgroundColor($r('sys.color.comp_background_tertiary'))
                }, (item: string) => item)
              }.margin({ top: 2 })
            }.alignItems(HorizontalAlign.Start)

            Divider()
            Column({ space: 12 }) {
              Column() {
                Row() {
                  Image($r('app.media.ic_position')).width(24).height(24)
                  Text('店铺位置').fontSize(14).fontColor($r('sys.color.font_primary')).margin({ left: 12 })
                }

                Text(this.vm.storeGuide.location)
                  .fontSize(14)
                  .fontColor($r('sys.color.font_secondary'))
                  .margin({ left: 36, top: 4 })
              }.alignItems(HorizontalAlign.Start)

              Column() {
                Row() {
                  Image($r('app.media.ic_tel')).width(24).height(24)
                  Text('电话').fontSize(14).fontColor($r('sys.color.font_primary')).margin({ left: 12 })
                }

                Text(this.vm.storeGuide.tel)
                  .fontSize(14)
                  .fontColor($r('sys.color.font_secondary'))
                  .margin({ left: 36, top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .onClick(() => {
                this.vm.showCallSheet = true;
              })
              .bindSheet($$this.vm.showCallSheet, CallTelSheetBuilder(this.mallModel.shoppingMall.tel, () => {
                this.vm.showCallSheet = false;
              }), {
                height: SheetSize.FIT_CONTENT,
                showClose: false,
                preferType: SheetType.CENTER,
              })
            }.width(Constants.FULL_SIZE).alignItems(HorizontalAlign.Start)

            Divider()
            Column({ space: 12 }) {
              Text('店铺简介').fontSize(16).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
              Row({ space: 12 }) {
                TextArea({ text: this.vm.storeGuide.introduce })
                  .fontSize(12)
                  .fontColor($r('sys.color.font_primary'))
                  .enabled(false)
                  .backgroundColor($r('sys.color.background_primary'))
                  .borderRadius(16)
                  .padding(12)
                  .shadow({
                    radius: 8,
                    color: '#19000000',
                    offsetX: 0,
                    offsetY: 0,
                  })
              }.width(Constants.FULL_SIZE)
            }
            .width(Constants.FULL_SIZE).alignItems(HorizontalAlign.Start)
          }
          .width(Constants.FULL_SIZE)
          .padding({
            top: 12,
            left: Constants.BORDER_WIDTH,
            right: Constants.BORDER_WIDTH,
            bottom: this.vm.getWindowBottomHeight() + 12,
          })
        }
      }
      .layoutWeight(1)
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }.hideTitleBar(true)
  }
}
