import { AppStorageV2 } from '@kit.ArkUI';
import {
  AppInfoModel,
  getDistanceWithLocation,
  getFmtDistWithLocation,
  GridRowColSetting,
  PermissionUtil,
  RouterMap,
  RouterModule,
  StoreInfo,
  StoreInfoModel,
  WindowModel,
} from 'common';
import { SelectStore } from 'select_store';

@Builder
export function SelectStorePageBuilder() {
  SelectStorePage()
}

@ComponentV2
struct SelectStorePage {
  @Local appInfoModel: AppInfoModel = AppStorageV2.connect(AppInfoModel, () => new AppInfoModel())!;
  @Local storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!;
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!
  @Local windowTopHeight: number = AppStorageV2.connect(WindowModel)?.getWindowTopHeight() || 38.77
  @Local breakpoint: string = '';
  @Local storeInfoList: Array<StoreInfo> = []

  build() {
    NavDestination() {
      GridRow(GridRowColSetting.DEFAULT_GRID_ROW_OPTIONS) {
        GridCol({ span: GridRowColSetting.GRID_ROW_OPTIONS_COLUMNS }) {
          Stack() {
            SelectStore({
              routerStack: RouterModule.getStack(),
              storeInfoList: this.storeInfoList,
              storeId: this.storeModel.storeId,
              packageName: this.appInfoModel.packageName,
              selectedStore: (storeId: string) => {
                this.storeModel.storeId = storeId
                RouterModule.popToName(RouterMap.MAIN_INDEX)
              },
            })
            Row({ space: 8 }) {
              Image($r('app.media.ic_back')).width(40).height(40).onClick(() => {
                RouterModule.pop()
              })
              Text('门店列表')
                .fontSize($r('sys.float.Title_S'))
                .fontWeight(FontWeight.Bold)
                .fontColor($r('sys.color.font_primary'))
            }
            .margin({ left: GridRowColSetting.getPageMargin(this.breakpoint), top: this.windowTopHeight })
            .padding({ top: 8, bottom: 8 })
          }.alignContent(Alignment.TopStart)
        }
      }.onBreakpointChange((bp) => {
        this.breakpoint = bp;
      })
    }.hideTitleBar(true)
    .onShown(() => {
      PermissionUtil.getLocation().then(res => {
        let myLocation = res
        this.storeModel.storeList.forEach(item => {
          item.distance = getDistanceWithLocation(myLocation, item.coordinates || '');
          item.distanceStr = getFmtDistWithLocation(myLocation, item.coordinates || '');
        })
        this.storeModel.storeList.sort((a, b) => (a.distance || 0) - (b.distance || 0))
        this.storeInfoList = this.storeModel.storeList
      })
    })
  }
}