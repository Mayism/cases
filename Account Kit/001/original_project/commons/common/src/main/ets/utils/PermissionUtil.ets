import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { UtilLog } from '@hw-agconnect/util-log';
import { abilityAccessCtrl } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { geoLocationManager } from '@kit.LocationKit';
import { Constants } from '../constants/Common';
import { WindowUtil } from './WindowUtil';
import { site } from '@kit.MapKit';

class PermissionUtil {
  private static instance?: PermissionUtil

  private constructor() {
  }

  static getInstance(): PermissionUtil {
    if (!PermissionUtil.instance) {
      PermissionUtil.instance = new PermissionUtil()
    }
    return PermissionUtil.instance
  }

  initPermission(): Promise<boolean> {
    return new Promise((resolve, reject) => {
      let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      atManager.requestPermissionsFromUser(WindowUtil.globalUIAbilityContext,
        ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION'])
        .then((data) => {
          let grantStatus: Array<number> = data.authResults;
          let hasMapPermission = grantStatus.every(item => item === Constants.USER_GRANT_SUCCESS)
          resolve(hasMapPermission)
        }).catch((err: BusinessError) => {
        reject(err.message)
        UtilLog.error(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
      });
    })
  }

  async getLocation(): Promise<geoLocationManager.Location> {
    return new Promise(async (resolve, reject) => {
      if (!await this.initPermission()) {
        promptAction.showToast({ message: '权限获取失败' })
        reject()
        return
      }
      geoLocationManager.getCurrentLocation().then((location: geoLocationManager.Location) => {
        resolve(location);
      }).catch((error: Error) => {
        UtilLog.error('getCurrentLocation failed', 'getCurrentLocation error: ' + JSON.stringify(error));
        reject(error)
      });
    })
  }

  async getCurrentCityInfo(): Promise<string> {
    try {
      const requestInfo: geoLocationManager.CurrentLocationRequest = {
        priority: geoLocationManager.LocationRequestPriority.FIRST_FIX,
        timeoutMs: 1000,
      };
      const currentLocation = await geoLocationManager.getCurrentLocation(requestInfo);
      const reverseGeoCodeReq: site.ReverseGeocodeParams = {
        location: currentLocation,
        language: 'zh_CN',
      };
      const reverseGeocodeResult = await site.reverseGeocode(reverseGeoCodeReq);
      return reverseGeocodeResult.addressComponent.city?.cityName ?? '';
    } catch (e) {
      return '';
    }
  }

  async applyAddresses(): Promise<string> {
    try {
      if (!await this.initPermission()) {
        promptAction.showToast({ message: '权限获取失败' })
        return '';
      }
      let city = await this.getCurrentCityInfo()
      return city
    } catch (e) {
      return '';
    }
  }
}

export const permissionUtil = PermissionUtil.getInstance()