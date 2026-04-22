import Decimal from '@arkts.math.Decimal';
import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { UtilLog } from '@hw-agconnect/util-log';
import { BusinessError, pasteboard } from '@kit.BasicServicesKit';
import { geoLocationManager } from '@kit.LocationKit';
import { map, mapCommon } from '@kit.MapKit';

export function copyString(param: string = '') {
  try {
    let pasteData: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, param)
    let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
    systemPasteboard.setData(pasteData).then(() => {
      UtilLog.info('succeeded in setting PasteData. ')
      promptAction.showToast({
        message: '复制成功', duration: 2000,
      });
    }).catch((err: BusinessError) => {
      UtilLog.error(`faild to set PasteData, ${JSON.stringify(err)}`)
    })
  } catch (err) {
    UtilLog.error(`faild to createData, ${JSON.stringify(err)}`)
  }
}

export function getAnonymousTel(userTel: string = '') {
  if (userTel.length >= 8) {
    return `${userTel.substring(0, userTel.length - 8)}****${userTel.substring(userTel.length - 4)}`
  } else {
    return '****';
  }
}

export function getFmtDistWithLocation(myLocation: geoLocationManager.Location, toLocation: string): string {
  return getDistance(getDistanceWithLocation(myLocation, toLocation));
}

export function getDistanceWithLocation(myLocation: geoLocationManager.Location, toLocation: string): number {
  let locationArr = toLocation.split(',')
  if (locationArr?.length === 2) {
    let fromLatLng: mapCommon.LatLng = {
      latitude: myLocation.latitude,
      longitude: myLocation.longitude,
    };

    let toLatLng: mapCommon.LatLng = {
      latitude: Number(locationArr[0]),
      longitude: Number(locationArr[1]),
    };
    return map.calculateDistance(fromLatLng, toLatLng);
  } else {
    return 0
  }
}

export function getDistanceByLocation(fromLatLng: mapCommon.LatLng, toLatLng: mapCommon.LatLng): string {
  return getDistance(map.calculateDistance(fromLatLng, toLatLng));
}

export function getDistance(distance: number = 0) {
  if (distance > 1000) {
    return `${new Decimal(distance).div(1000).toFixed(2)}Km`
  } else {
    return `${new Decimal(distance).toFixed(2)}m`;
  }
}

export function getTime(date: Date): string {
  let hours = `0${date.getHours()}`.slice(-2)
  let minutes = `0${date.getMinutes()}`.slice(-2)
  return `${hours}:${minutes}`
}

export function getSecond(date: Date): string {
  let hours = `0${date.getHours()}`.slice(-2)
  let minutes = `0${date.getMinutes()}`.slice(-2)
  let seconds = `0${date.getSeconds()}`.slice(-2)
  return `${hours}:${minutes}:${seconds}`
}

export function getDate(date: Date): string {
  let year = date.getFullYear()
  let month = `0${date.getMonth() + 1}`.slice(-2)
  let day = `0${date.getDate()}`.slice(-2)
  return `${year}-${month}-${day}`
}

export function getFullDate(date: Date): string {
  return `${getDate(date)} ${getSecond(date)}`
}

export function formatDateToMonthDay(date: Date, index?: number): string {
  if (index === 0) {
    return '今天';
  }
  if (index === 1) {
    return '明天';
  }
  const month = date.getMonth() + 1;
  const day = date.getDate();
  return `${month}月${day}日`;
}

export function formatDistance(distanceInMeters: number): string {
  if (distanceInMeters < 1000) {
    return `${Math.floor(distanceInMeters)}m`;
  }
  const distanceInKilometers = (distanceInMeters / 1000).toFixed(2);
  return `${distanceInKilometers}km`;
}

export function formatTimeStrToDate(dateTimeStr: string): Date {
  const parts = dateTimeStr.split(' ');
  const datePart = parts[0];
  const period = parts[1];
  const monthDayParts = datePart.split(/[月日]/);
  const monthStr = monthDayParts[0];
  const dayStr = monthDayParts[1];
  const timeParts = period.split(':');
  const hourStr = timeParts[0];
  const minuteStr = timeParts[1];
  let month = parseInt(monthStr, 10) - 1;
  const day = parseInt(dayStr, 10);
  let hour = parseInt(hourStr, 10);
  const minute = parseInt(minuteStr, 10);
  const now = new Date();
  let year = now.getFullYear();
  // 跨年场景
  if (month < now.getMonth()) {
    year++
  }
  const date = new Date();
  date.setFullYear(year, month, day);
  date.setHours(hour, minute, 0, 0);
  return date;
}

export function formatTimePikerToStr(time: TimePickerResult): string {
  const hourStr = time.hour.toString().padStart(2, '0');
  const minuteStr = time.minute.toString().padStart(2, '0');
  return `${hourStr}:${minuteStr}`;
}

export function formatDateToTimeStr(date: Date): string {
  const month = date.getMonth() + 1;
  const day = date.getDate();
  let hour = date.getHours();
  const minute = date.getMinutes();
  const period = hour >= 12 ? '下午' : '上午';
  hour = hour % 12;
  hour = hour === 0 ? 12 : hour;
  return `${month}月${day}日 ${period} ${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
}

export function formatDateForForm(date: Date): string {
  const daysOfWeek = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
  const dayOfWeek = daysOfWeek[date.getDay()]
  const hours = date.getHours().toString().padStart(2, '0')
  const minutes = date.getMinutes().toString().padStart(2, '0')
  return `今天（${dayOfWeek}）${hours}:${minutes}`
}
