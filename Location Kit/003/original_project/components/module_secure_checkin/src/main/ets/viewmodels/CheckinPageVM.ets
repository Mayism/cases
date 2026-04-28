import { geoLocationManager } from '@kit.LocationKit';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import { PromptAction } from '@ohos.arkui.UIContext';

import { Api } from '../http/Api';
import { VerifyEventType } from '../components/UIVerifyCodeInput';
import { ErrorCode, ViewModelState } from '../common/CustomTypes';
import { CheckinResponse, GetCheckinInfoResponse } from '../models/ApiModels';
import { Logger } from '../utils/Logger';
import { NormalizedError } from '../utils/NormalizedError';
import { PermissionUtils } from '../utils/PermissionUtils';

@ObservedV2
export class CheckinPageVM {

  @Trace
  public state: ViewModelState = ViewModelState.UNINITIALIZED;

  @Trace
  public isLoading: boolean = false;

  @Trace
  public isCheckedIn: boolean = false;

  @Trace
  public checkinCode: string = '';

  @Trace
  public showErrorTips: boolean = false;

  @Trace
  public courseName: string = '';

  private courseId: string = '';

  private context: common.UIAbilityContext;

  private promptAction: PromptAction;

  public async initialize(): Promise<void> {
    if (this.isLoading || this.state === ViewModelState.READY) {
      return;
    }
    try {
      this.isLoading = true;
      const resp: GetCheckinInfoResponse = await Api.getCheckinInfo();
      if (resp.code !== ErrorCode.NO_ERROR) {
        throw new Error(resp.message);
      }
      this.courseId = resp.courseId ?? '';
      this.courseName = resp.courseName ?? '';
      this.isCheckedIn = Boolean(resp.isCheckedIn);
      this.checkinCode = (this.isCheckedIn && resp.checkinCode) ? resp.checkinCode : '';
      this.state = ViewModelState.READY;
    } catch (e) {
      this.state = ViewModelState.INIT_FAILED;
      Logger.error(NormalizedError.from(e).toLogLine());
    } finally {
      this.isLoading = false;
    }
  }

  public async doCheckin(): Promise<void> {
    if (this.isLoading || this.state !== ViewModelState.READY) {
      return;
    }
    this.isLoading = true;
    try {
      if (!await PermissionUtils.requestLocationPermissions(this.context)) {
        this.showToast('位置权限获取失败');
        return;
      }
      const location: geoLocationManager.Location | undefined = await this.getCurrentLocation();
      if (!location) {
        this.showToast('位置信息获取失败');
        return;
      }
      const resp: CheckinResponse = await Api.checkin({
        courseId: this.courseId,
        checkinCode: this.checkinCode,
        location: {
          latitude: location.latitude,
          longitude: location.longitude
        }
      });
      if (resp.code !== ErrorCode.NO_ERROR) {
        this.showErrorTips = true;
        this.checkinCode = '';
        this.context.eventHub.emit(VerifyEventType.CODE_ERROR);
      } else {
        this.isCheckedIn = true;
      }
    } catch (e) {
      Logger.error(NormalizedError.from(e).toLogLine());
    } finally {
      this.isLoading = false;
    }
  }

  public async getCurrentLocation(): Promise<geoLocationManager.Location | undefined> {
    try {
      if (!geoLocationManager.isLocationEnabled()) {
        await abilityAccessCtrl.createAtManager().requestGlobalSwitch(
          this.context,
          abilityAccessCtrl.SwitchType.LOCATION
        );
      }
      const location: geoLocationManager.Location = await geoLocationManager.getCurrentLocation({
        priority: geoLocationManager.LocationRequestPriority.FIRST_FIX,
        timeoutMs: 10000
      });
      return location;
    } catch (e) {
      Logger.error(NormalizedError.from(e).toLogLine());
      return undefined;
    }
  }

  public showToast(msg: string): void {
    try {
      this.promptAction.showToast({ message: msg });
    } catch (e) {
      Logger.error(NormalizedError.from(e).toLogLine());
    }
  }

  constructor(uiContext: UIContext) {
    this.promptAction = uiContext.getPromptAction();
    this.context = uiContext.getHostContext() as common.UIAbilityContext;
    PermissionUtils.requestLocationPermissions(this.context);
    this.initialize();
  }
}
