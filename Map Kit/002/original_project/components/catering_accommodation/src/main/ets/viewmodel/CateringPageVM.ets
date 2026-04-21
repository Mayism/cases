import { site } from '@kit.MapKit';
import { PersistenceV2 } from '@kit.ArkUI';
import { LazyDataSource, LocationInfo } from 'module_base';
import { AccommodationInfo, CateringInfo, CateringTabBarType } from '../model/Index';
import { mapAccommodationInfo, mapCateringInfo } from '../mapper/Index';
import { UtilLog } from '@hw-agconnect/util-log';

@ObservedV2
export class CateringPageVM {
  public static _instance: CateringPageVM;
  @Trace cateringList: LazyDataSource<CateringInfo> = new LazyDataSource();
  @Trace accommodationList: LazyDataSource<AccommodationInfo> = new LazyDataSource();
  private locationInfo: LocationInfo =
    PersistenceV2.connect(LocationInfo, 'locationInfo', () => new LocationInfo())!;

  public static get instance() {
    if (!CateringPageVM._instance) {
      CateringPageVM._instance = new CateringPageVM();
    }
    return CateringPageVM._instance;
  }
}