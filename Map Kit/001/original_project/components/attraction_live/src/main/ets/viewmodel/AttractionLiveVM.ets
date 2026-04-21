import { BusinessError } from '@kit.BasicServicesKit';
import { ParkingSlotInfo, RealTimeInfo } from '../model/Index';
import { mapperParkingSlot } from '../mapper/Index';
import { SystemUtil } from 'module_base';
import { UtilLog } from '@hw-agconnect/util-log';

@ObservedV2
export class AttractionLiveVM {
  public static _instance: AttractionLiveVM;
  @Trace parkingSlotList: ParkingSlotInfo[] = [];
  @Trace realTimeInfos: RealTimeInfo[] = [];
  @Trace longitude: number = 0;
  @Trace latitude: number = 0;

  public static get instance() {
    if (!AttractionLiveVM._instance) {
      AttractionLiveVM._instance = new AttractionLiveVM();
    }
    return AttractionLiveVM._instance;
  }
}
