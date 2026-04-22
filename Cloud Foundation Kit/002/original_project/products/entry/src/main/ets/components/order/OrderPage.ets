import { AppStorageV2 } from '@kit.ArkUI';
import { BusinessTimeDialog, CustomSelectSheetBuilder } from 'base_ui';
import {
  AppInfoModel,
  BreakpointNameEnum,
  BreakpointType,
  Constants,
  getDistanceWithLocation,
  getFmtDistWithLocation,
  GridRowColSetting,
  MustGoodsController,
  MyCarModel,
  OrderTypeEnum,
  PermissionUtil,
  StoreInfoModel,
  TabBarType,
  TableInfo,
} from 'common/Index';
import { DishesTypeResp, HttpRequest } from 'network';
import * as API from '../../api/Index';
import { MyCarComp } from './MyCarComp';
import { MyCarListComp } from './MyCarListComp';
import { OrderListComp } from './OrderListComp';
import { TitleComp } from './TitleComp';

@ComponentV2
export struct OrderPage {
  // 原始商品列表
  @Provider('dishesListOri') dishesListOri: Array<DishesTypeResp> = []
  // 展示的商品列表
  @Provider('dishesList') dishesList: Array<DishesTypeResp> = []
  @Consumer('currentIndex') currentIndex: number = 0
  @Local breakpoint: string = '';
  @Local mustGoodsCtrl: MustGoodsController =
    AppStorageV2.connect(MustGoodsController, () => new MustGoodsController())!
  @Local appInfoModel: AppInfoModel = AppStorageV2.connect(AppInfoModel, () => new AppInfoModel())!;
  @Local myCarModel: MyCarModel = AppStorageV2.connect(MyCarModel) as MyCarModel
  @Local storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!;
  @Local showCarList: boolean = false
  @Local tableSheetShow: boolean = false;
  @Local dinerSheetShow: boolean = false;
  businessHoursAM: string = ''
  businessHoursPM: string = ''
  businessController: CustomDialogController = new CustomDialogController({
    builder: BusinessTimeDialog({
      businessHoursAM: this.businessHoursAM,
      businessHoursPM: this.businessHoursPM,
    }),
    width: new BreakpointType<number>({
      [BreakpointNameEnum.SM]: 296,
      [BreakpointNameEnum.MD]: GridRowColSetting.DIALOG_MAX_WIDTH,
      [BreakpointNameEnum.LG]: GridRowColSetting.DIALOG_MAX_WIDTH,
      [BreakpointNameEnum.XL]: GridRowColSetting.DIALOG_MAX_WIDTH,
    }).getValue(this.breakpoint),
    height: 348,
  });

  @Monitor('currentIndex')
  currentIndexChange() {
    if (this.currentIndex === TabBarType.ORDER) {
      this.chooseRefresh()
    }
  }

  @Monitor('storeModel.storeId')
  getStoreInfo() {
    API.getStoreInfo(this.storeModel.storeId).then(res => {
      this.storeModel.storeInfo = res;
      PermissionUtil.getLocation().then(location => {
        this.storeModel.storeInfo.distance = getDistanceWithLocation(location, res.coordinates);
        this.storeModel.storeInfo.distanceStr = getFmtDistWithLocation(location, res.coordinates);
      })
      this.isShowRest()
      this.chooseRefresh()
    });
  }

  aboutToAppear() {
    this.getDishesList()
    this.getStoreInfo()
    HttpRequest.getMyCar()
  }

  build() {
    NavDestination() {
      GridRow(GridRowColSetting.DEFAULT_GRID_ROW_OPTIONS) {
        GridCol({ span: GridRowColSetting.GRID_ROW_OPTIONS_COLUMNS }) {
          Stack() {
            Column({ space: 12 }) {
              TitleComp()
              OrderListComp({ breakpoint: this.breakpoint }).layoutWeight(1)
            }
            .height(Constants.FULL_SIZE)
            .width(Constants.FULL_SIZE)
            .bindSheet($$this.tableSheetShow,
              CustomSelectSheetBuilder(this.storeModel.tableList.map((item) => {
                return item.tableName ?? '';
              }), (select: ResourceStr) => {
                this.confirmTable(select);
              }), {
                detents: [408, 409],
                backgroundColor: $r('sys.color.background_fourth'),
                blurStyle: BlurStyle.Thick,
                preferType: SheetType.CENTER,
                title: { title: $r('app.string.pick_table') },
              });

            MyCarListComp({
              close: () => {
                this.showCarList = false
              },
            }).visibility(this.showCarList ? Visibility.Visible : Visibility.Hidden)
            // 购物车
            MyCarComp({
              showCarList: this.showCarList, changeCarListShow: (flag: boolean) => {
                this.showCarList = flag
              },
            })
              .visibility(this.myCarModel.myCar.goodsList?.length ? Visibility.Visible : Visibility.Hidden)
          }.alignContent(Alignment.Bottom)
          .bindSheet($$this.dinerSheetShow,
            CustomSelectSheetBuilder($r('app.strarray.diner_num'),
              (select: ResourceStr) => {
                this.confirmDiner(select);
              }), {
              detents: [408, 409],
              backgroundColor: $r('sys.color.background_fourth'),
              blurStyle: BlurStyle.Thick,
              preferType: SheetType.CENTER,
              title: { title: $r('app.string.pick_dinner_num') },
            })
        }
      }.onBreakpointChange((bp) => {
        this.breakpoint = bp;
      })
    }
    .hideTitleBar(true)
  }

  getDishesList() {
    API.getDishesList().then(res => {
      this.dishesList = res
      this.dishesListOri = JSON.parse(JSON.stringify(res))
      this.dishesList.forEach(item => {
        item.goods.forEach(i => {
          if (i.isMust === Constants.GOODS_MUST) {
            this.mustGoodsCtrl.changeShopIsMustGoods()
          }
        })

      })
    })
  }

  chooseRefresh() {
    if (!this.storeModel.isRest) {
      if (this.storeModel.orderType === OrderTypeEnum.DINE_IN && !this.storeModel.tableId) {
        this.storeModel.tableInfo = new TableInfo()
        this.tableSheetShow = true
      } else if (!this.storeModel.dinerNum && !this.dinerSheetShow) {
        this.dinerSheetShow = true
      }
    }
  }

  isShowRest() {
    if (this.storeModel.storeInfo.isRest === Constants.STORE_REST ||
      new Date().getTime() < this.getTimeByHour(this.storeModel.storeInfo.time1) ||
      new Date().getTime() > this.getTimeByHour(this.storeModel.storeInfo.time2)) {
      this.businessHoursAM = `AM ${this.storeModel.storeInfo?.time1}-${Constants.MID_DAY_TIME}`
      this.businessHoursPM = `PM ${Constants.MID_DAY_TIME}-${this.storeModel.storeInfo?.time2}`
      if (!this.storeModel.isRest) {
        this.businessController?.open();
      }
      this.storeModel.isRest = true
    } else {
      this.storeModel.isRest = false
    }
  }

  getTimeByHour(time: string = '') {
    let date = new Date(`${new Date().toLocaleDateString()} ${time}`)
    return date.getTime()
  }

  confirmTable(select: ResourceStr) {
    if (select) {
      let table = this.storeModel.tableList.find(item => item.tableName === select)
      this.storeModel.tableId = table?.id ?? '1';
      this.storeModel.tableInfo = this.storeModel.tableList.find(item => item.id === this.storeModel.tableId)!;
    }
    this.tableSheetShow = false
    if (!this.storeModel.dinerNum) {
      this.dinerSheetShow = true
    }
  }

  confirmDiner(select: ResourceStr) {
    if (select) {
      this.storeModel.dinerNum = select;
    } else {
      this.storeModel.dinerNum = this.storeModel.dinerNum || `1人`;
    }
    this.dinerSheetShow = false
  }
}
