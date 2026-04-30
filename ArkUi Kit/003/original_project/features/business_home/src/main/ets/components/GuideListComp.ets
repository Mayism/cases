import { AppStorageV2 } from '@kit.ArkUI';
import {
  CommonUrl,
  Constants,
  EmptyComp,
  GuideRouter,
  GuideTag,
  RouterMap,
  RouterUtil,
  StoreGuide,
  WindowModel,
} from 'lib_common'
import { StoreGuideViewModel } from '../viewmodel/StoreGuideViewModel'


@ComponentV2
export struct GuideListComp {
  @Param @Require vm: StoreGuideViewModel
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;

  @Computed
  get filterGuides() {
    return this.vm.storeGuideList.filter(item => (!this.vm.searchText || item.name.indexOf(this.vm.searchText) >= 0) &&
      (this.vm.searchTag === '全部' || item.tag.indexOf(this.vm.searchTag) >= 0) &&
      (this.vm.searchFloor === '全部楼层' || item.floor === this.vm.searchFloor))
  }

  @Computed
  get tagListShow() {
    return this.vm.tagList.map(item => {
      item.num =
        this.vm.storeGuideList.filter(guide => {
          const isCurrentFloor = this.vm.searchFloor === '全部楼层' || this.vm.searchFloor === guide.floor;
          const isCurrentTag = item.name === '全部' || guide.tag.indexOf(item.name) >= 0;
          return isCurrentFloor && isCurrentTag;
        }).length
      return item
    })
  }

  build() {
    Column({ space: 12 }) {
      Row() {
        Search({ value: $$this.vm.searchText, placeholder: $r('app.string.search_words') })
          .textFont({ size: $r('sys.float.Body_L') })
          .width(Constants.FULL_SIZE)
          .placeholderFont({ size: $r('sys.float.Body_L') })
      }

      // 分类
      List({ space: 8 }) {
        ForEach(this.tagListShow, (item: GuideTag) => {
          ListItem() {
            Column() {
              Text(item.name)
                .fontSize(12)
                .fontColor(this.vm.searchTag === item.name ? $r('sys.color.font_on_primary') :
                  $r('sys.color.font_primary'))
              Text(item.num.toString())
                .fontSize(12)
                .fontColor(this.vm.searchTag === item.name ? $r('sys.color.font_on_primary') :
                  $r('sys.color.font_primary'))
                .margin({ top: 4 })
            }
            .width(40)
            .borderRadius(8)
            .backgroundColor(this.vm.searchTag === item.name ? $r('app.color.app_theme') :
              $r('sys.color.comp_background_tertiary'))
            .padding({ top: 4, bottom: 4 })
            .onClick(() => {
              this.vm.searchTag = item.name
            })
          }
        }, (item: GuideTag) => item.id)
      }
      .listDirection(Axis.Horizontal)
      .width(Constants.FULL_SIZE)
      .scrollBar(BarState.Off)
      .height(44)

      // 列表页
      Row() {
        List({ space: 8 }) {
          ForEach(this.vm.floorList, (item: string) => {
            ListItem() {
              TitleItem({
                typeName: item,
                isSelected: this.vm.searchFloor === item,
                onClickAction: () => {
                  this.vm.searchFloor = item
                },
              })
            }
          }, (item: string) => item)
        }
        .width(76)
        .height('100%')
        .listDirection(Axis.Vertical) // 排列方向
        .backgroundColor($r('sys.color.background_secondary'))
        .scrollBar(BarState.Off)

        if (this.filterGuides.length) {
          Grid() {
            ForEach(this.filterGuides, (item: StoreGuide) => {
              GridItem() {
                Column({ space: 4 }) {
                  Image(`${CommonUrl.CLOUD_STORAGE_URL}${item.logo}`)
                    .width(40)
                    .width(40)
                    .alt($r('app.media.empty_data'))
                  Text(item.name).fontSize(10).fontColor($r('sys.color.font_primary'))
                  Row() {
                    Image($r('app.media.ic_location')).width(12)
                    Text(item.location).fontSize(10).fontColor($r('sys.color.font_secondary'))
                  }
                }
                .onClick(() => {
                  RouterUtil.pushPathByName(RouterMap.STORE_GUIDE_DETAIL_PAGE, { guide: item } as GuideRouter)
                })
              }
            }, (item: StoreGuide) => JSON.stringify(item))
          }
          .layoutWeight(1)
          .rowsGap(8)
          .columnsGap(8)
          .columnsTemplate('1fr 1fr 1fr')
          .scrollBar(BarState.Off)
          .edgeEffect(EdgeEffect.Spring)
          .nestedScroll({
            scrollForward: NestedScrollMode.PARENT_FIRST,
            scrollBackward: NestedScrollMode.SELF_FIRST,
          })
          .padding({
            bottom: this.windowModel.getWindowBottomHeight(),
          })
        } else {
          Column() {
            EmptyComp({ text: '暂无相关店铺信息', image: $r('app.media.ic_no_record') })
          }
          .justifyContent(FlexAlign.Center)
          .layoutWeight(1)
          .backgroundColor($r('sys.color.background_primary'))
          .borderRadius(16)
        }

      }
      .height('50%')
      .alignItems(VerticalAlign.Top)

    }.margin({ left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH })
  }
}

// 标题
@ComponentV2
export struct TitleItem {
  @Param @Require typeName: string;
  @Param @Require isSelected: boolean;
  @Event onClickAction: () => void = () => {
  }

  build() {
    Row() {
      Text(this.typeName)
        .fontSize(12)
        .fontColor(this.isSelected ? $r('sys.color.font_on_primary') : $r('sys.color.font_primary'))
        .textAlign(TextAlign.Center)
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.isSelected ? $r('app.color.app_theme') : '#00000000')
    .width(76)
    .height(40)
    .onClick(this.onClickAction)
  }
}