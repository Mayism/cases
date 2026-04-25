import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import {
  DiamondZone,
  RouterMap,
  MallModel,
  UserIconModel,
  UserInfoModel,
  WindowModel,
  GlobalUtils
} from 'lib_common';
import { GlobalCouponUtils } from 'module_coupon';
import { GlobalPointUtils } from 'module_points';

@ObservedV2
export class MinePageViewModel {
  @Trace userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Trace windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
  @Trace mallModel: MallModel = AppStorageV2.connect(MallModel, () => new MallModel()) as MallModel;
  @Trace callTelSheet: boolean = false
  @Trace userIconInfo: UserIconModel = AppStorageV2.connect(UserIconModel, () => new UserIconModel())!;
  @Trace authCode: string = ''
  @Trace diamondZoneList: Array<DiamondZone> = [
    new DiamondZone($r('app.media.ic_vip_header'), '会员手册', RouterMap.MEMBER_SHIP_MANUAL),
    new DiamondZone($r('app.media.ic_mine_considerate_service'), '贴心服务', RouterMap.CONSIDERATE_SERVICE_PAGE),
    new DiamondZone($r('app.media.ic_mine_self_point'), '自助积分', RouterMap.SELF_SERVICE_POINT_PAGE),
  ]
  @Trace globalInfo: GlobalUtils = AppStorageV2.connect(GlobalUtils, () => new GlobalUtils())!;
  @Trace globalPointInfo: GlobalPointUtils = AppStorageV2.connect(GlobalPointUtils, () => new GlobalPointUtils())!;
  @Trace globalCouponInfo: GlobalCouponUtils = AppStorageV2.connect(GlobalCouponUtils, () => new GlobalCouponUtils())!;

  closeTelSheet() {
    this.callTelSheet = false
  }
}