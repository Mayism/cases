import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { UtilLog } from '@hw-agconnect/util-log';
import { AppStorageV2 } from '@kit.ArkUI';
import {
  Constants,
  CustomShareParams,
  GridRowColSetting,
  MustGoodsController,
  NavHeaderBar,
  PackageSpec,
  RouterMap,
  RouterModule,
  WindowModel,
} from 'common';
import { GoodsDetail } from 'goods_detail';
import { GoodsResp, GoodsSpecResp, PackageSpecResp, SpecCatalogResp, SpecItemResp } from 'network';
import * as API from '../api/Index';
import { goodsInfoMapper } from '../mapper/Index';
import { Goods } from '../models/Index';

const TAG = '[GoodsDetailPage]'

@Builder
export function GoodsDetailPageBuilder() {
  GoodsDetailPage()
}

@ComponentV2
struct GoodsDetailPage {
  @Local breakpoint: string = '';
  @Local mustGoodsCtrl: MustGoodsController =
    AppStorageV2.connect(MustGoodsController, () => new MustGoodsController())!
  @Local goodsInfo: Goods = new Goods();
  @Local goodSpecList: Array<SpecCatalogResp> = [];
  @Local selectSpecArr: Array<PackageSpecResp> = [];
  @Local selectSpecInfo?: GoodsSpecResp = undefined;
  @Local goodSinglePrice: number = 0;
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
  @Local shareParams: CustomShareParams = AppStorageV2.connect(CustomShareParams, () => new CustomShareParams())!;
  private goodsId: string = '';

  aboutToAppear(): void {
    this.getParams();
    API.getGoodInfo(this.goodsId).then((resp: GoodsResp) => {
      this.goodsInfo = goodsInfoMapper(resp);
      // 分享参数存储
      this.shareParams.pageName = RouterMap.GOODS_DETAIL_PAGE;
      this.shareParams.goodsId = this.goodsInfo.id;
      this.shareParams.goodsName = this.goodsInfo.name;
      if (resp.spec?.length && resp.spec?.length > 0) {
        this.goodSpecList = resp.spec ?? [];
        this.selectSpecArr = this.goodSpecList.map((item: SpecCatalogResp) => {
          let goodSpec = item.specVal.find((spec: SpecItemResp) => item.specValId === spec.specValId);
          let result: PackageSpec =
            { specName: goodSpec?.specValName || '', specNum: Number(goodSpec?.specValNum ?? 1) };
          return result;
        });

        API.getGoodSpec(this.goodsInfo?.id, this.selectSpecArr).then((res) => {
          this.selectSpecInfo = res;
          this.goodSinglePrice = Number(res.money);
        });

      } else {
        this.goodSinglePrice = Number(resp.money);
      }
    });
  }

  getParams() {
    let params = RouterModule.getNavParam<Record<string, string>>(RouterMap.GOODS_DETAIL_PAGE);
    if (params) {
      this.goodsId = params.goodsId;
    }
  }

  build() {
    NavDestination() {
      GridRow(GridRowColSetting.DEFAULT_GRID_ROW_OPTIONS) {
        GridCol({ span: GridRowColSetting.GRID_ROW_OPTIONS_COLUMNS }) {
          Column() {
            NavHeaderBar({ title: $r('app.string.good_details') })
            GoodsDetail({
              breakpoint: this.breakpoint,
              goodsInfo: this.goodsInfo,
              goodSpecList: this.goodSpecList,
              goodSinglePrice: this.goodSinglePrice,
              selectSpecArr: this.selectSpecArr,
              clickAddCarCb: (goodNum: number) => {
                this.clickAddCar(goodNum)
              },
              getSelectSpec: (item: SpecItemResp, index: number) => {
                this.getSelectSpec(item, index)
              },
            }).layoutWeight(1)
          }.margin({ bottom: this.windowModel.getWindowBottomHeight() });
        }
      }.onBreakpointChange((bp) => {
        this.breakpoint = bp;
      })
    }.hideTitleBar(true).onWillDisappear(() => {
      this.shareParams.goodsId = '';
      this.shareParams.goodsName = '';
      this.shareParams.pageName = '';
    });
  }

  getSelectSpec(item: SpecItemResp, index: number) {
    let pkgSpec: PackageSpecResp = {
      specName: item.specValName,
      specNum: Number(item.specValNum),
    };
    this.selectSpecArr[index] = pkgSpec;
    API.getGoodSpec(this.goodsInfo?.id, this.selectSpecArr).then((resp) => {
      this.selectSpecInfo = resp;
      this.goodSinglePrice = Number(resp.money);
    });
  }

  clickAddCar(goodNum: number) {
    if (this.goodSpecList.length) {
      if (!this.selectSpecInfo) {
        UtilLog.error(TAG, `add car selectSpecInfo empty.`);
        return;
      }
      API.addCarSpec(this.selectSpecInfo, this.goodsInfo?.id ?? '', Number(goodNum)).then(() => {
        promptAction.showToast({ message: '添加成功！' });
        if (this.goodsInfo?.isMust === Constants.GOODS_MUST) {
          this.mustGoodsCtrl.addIsMust(Number(goodNum));
        }
        RouterModule.pop();
      }).catch(() => {
        promptAction.showToast({ message: '添加失败！' });
      });
    } else {
      if (this.goodsInfo) {
        API.addCar(this.goodsInfo, Number(goodNum)).then(() => {
          promptAction.showToast({ message: '添加成功！' });
          if (this.goodsInfo?.isMust === Constants.GOODS_MUST) {
            this.mustGoodsCtrl.addIsMust(Number(goodNum));
          }
          RouterModule.pop();
        }).catch(() => {
          promptAction.showToast({ message: '添加失败！' });
        });
      } else {
        UtilLog.error(TAG, `add car goodInfo empty.`);
      }

    }
  }
}
