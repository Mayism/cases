import {
  FilterTagAndList,
  PresentationType,
  SearchApis,
  SearchItem,
  SearchView,
  SearchWordItem,
  StoreInfo,
} from 'search';
import { BreakpointNameEnum } from 'search/src/main/ets/common/GridRowColSetting';
import { MapLocation } from '../models/Index';
import { ConfirmDialog } from '../utils/ConfirmDialog';
import { GridRowColSetting } from '../utils/GridRowColSetting';
import { HwMapComp } from './HwMapComp';
import { StoreCard, storeCardBuilder } from './StoreCard';

@ComponentV2
export struct SelectStore {
  @Param routerStack: NavPathStack = new NavPathStack();
  @Param storeInfoList: Array<StoreInfo> = []
  @Param storeId: string = ''
  @Param packageName: string = ''
  @Local breakpoint: string = '';
  @Local selectStore: MapLocation = new MapLocation()
  @Local selectIndex: number = 0
  @Local showSelectStore: boolean = true
  @Local isMoveMap: boolean = true
  @Local mapMarginBottom: number = 200
  @Local listHeight: number = 400
  @Local offsetY: number = 0;
  @Local positionY: number = 0;
  cardWrapBuilder: WrappedBuilder<[SearchItem]> = wrapBuilder(storeCardBuilder)
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left | PanDirection.Right });

  @Computed
  get locations() {
    return this.storeInfoList.map(item => {
      let location = new MapLocation()
      let locationArr = item.coordinates.split(',')
      if (locationArr?.length === 2) {
        location.id = item.id
        location.title = item.name
        location.latitude = Number(locationArr[0])
        location.longitude = Number(locationArr[1])
      }
      return location
    })
  }

  @Event selectedStore: (storeId: string) => void = () => {
  }

  aboutToAppear(): void {
    this.locationsChange()
  }

  searchFilterList(searchText: string | SearchWordItem | SearchItem): FilterTagAndList[] {
    let keywordValue = searchText as SearchWordItem;
    let searchResult: string = '';
    let result: FilterTagAndList = {
      id: '',
      label: '',
      itemList: [],
    }
    let storeList: StoreInfo[] = []
    if (keywordValue?.content?.length) {
      storeList = this.storeInfoList.filter(item => !keywordValue || item.name.includes(keywordValue.content))
      searchResult = keywordValue.content
    } else {
      storeList = this.storeInfoList.filter(item => !searchText || item.name.includes(searchText as string))
      searchResult = searchText as string
    }
    result.itemList = storeList.map(item => {
      return { store: item, packageName: this.packageName } as SearchItem
    })
    SearchApis.addHistoryList(searchResult);
    return [result];
  }

  @Monitor('locations')
  locationsChange() {
    this.locations.forEach((item, index) => {
      if (item.id === (this.storeId || this.storeInfoList[0].id)) {
        this.selectStore = item
        this.selectIndex = index
      }
    })
  }

  build() {
    GridRow(GridRowColSetting.DEFAULT_GRID_ROW_OPTIONS) {
      GridCol({ span: GridRowColSetting.GRID_COL_OPTIONS_COLUMNS_LEFT }) {
        HwMapComp({
          locations: this.locations,
          showMyLocation: false,
          selectStore: this.selectStore,
          mapMarginBottom: this.breakpoint === BreakpointNameEnum.SM ? this.mapMarginBottom : 0,
          changeStore: (storeName: string) => {
            this.showSelectStore = true
            this.isMoveMap = true
            this.locations.forEach((item, index) => {
              if (item.title === storeName) {
                this.selectStore = item
                this.selectIndex = index
              }
            })
          },
        }).bindSheet($$this.showSelectStore, this.selectStoreComp(), {
          detents: [442, 200, SheetSize.LARGE],
          showClose: false,
          preferType: SheetType.CENTER,
          enableOutsideInteractive: true,
          onDetentsDidChange: (height: number) => {
            // onDetentsDidChange方法有延迟，快速更改半模态时需要增加变量控制
            if (this.isMoveMap) {
              this.mapMarginBottom = this.getUIContext().px2vp(height)
            }
          },
          onWillDismiss: (dismissSheetAction: DismissSheetAction) => {
            this.isMoveMap = false
            this.mapMarginBottom = 0
            dismissSheetAction.dismiss(); //注册dismiss行为
          },
        })
      }

      if (this.breakpoint !== BreakpointNameEnum.SM) {
        GridCol({ span: GridRowColSetting.GRID_COL_OPTIONS_COLUMNS_RIGHT }) {
          this.selectStoreComp()
        }.height(this.breakpoint === BreakpointNameEnum.SM ? this.listHeight : '100%')
      }
    }
    .padding(this.breakpoint === BreakpointNameEnum.SM ? 0 : {
      top: 100,
      bottom: 32,
      left: GridRowColSetting.getPageMargin(this.breakpoint),
      right: GridRowColSetting.getPageMargin(this.breakpoint),
    })
    .onBreakpointChange((bp) => {
      this.breakpoint = bp;
      if (this.breakpoint === BreakpointNameEnum.SM) {
        this.showSelectStore = true
      } else {
        this.showSelectStore = false

      }
    })
  }

  @Builder
  selectStoreComp() {
    Column({ space: 12 }) {
      SearchView({
        routerStack: this.routerStack,
        presentationType: PresentationType.SEARCH_BOX,
        entranceText: ['搜索门店'],
        placeholder: ['搜索门店'],
        showFilterTag: false,
        showGuessLike: false,
        showHotSearch: false,
        isShallowWindow: true,
        resultItemBuilderParam: this.cardWrapBuilder,
        searchSuggestion: () => Promise.resolve([[], []]),
        // todo 搜索采用本地过滤方法，如需调用接口可替换接口方法
        handleSearch: (keyWord: string | SearchWordItem | SearchItem) =>
        Promise.resolve(this.searchFilterList(keyWord)),
        onClickResultItem: (item: SearchItem) => {
          if (item?.store) {
            ConfirmDialog.show({
              primaryTitle: '温馨提示', content: '您是否需要切换至该店铺', confirm: () => {
                this.selectedStore(item.store!.id)
              },
            })
          }
        },
        onWillJump: () => {
          this.showSelectStore = false
          this.mapMarginBottom = 0
        },
      })
      List({ space: 12 }) {
        ForEach(this.storeInfoList, (item: StoreInfo, index: number) => {
          ListItem() {
            StoreCard({ storeInfo: item, packageName: this.packageName, isSelect: this.selectIndex === index })
              .onClick(() => {
                if (this.selectIndex === index) {
                  ConfirmDialog.show({
                    primaryTitle: '温馨提示', content: '您是否需要切换至该店铺', confirm: () => {
                      this.selectedStore(item.id)
                      this.showSelectStore = false
                    },
                  })
                } else {
                  this.selectIndex = index
                  this.selectStore = this.locations.find(location => location.id === item.id)!
                }
              })
          }
        }, (item: StoreInfo) => item.id)
      }.layoutWeight(1).scrollBar(BarState.Off)
    }
    .width('100%')
    .padding({ left: 8, right: 8 })
    .layoutWeight(1)
    .margin(this.breakpoint === BreakpointNameEnum.SM ? { top: 12 } : 0)
  }
}