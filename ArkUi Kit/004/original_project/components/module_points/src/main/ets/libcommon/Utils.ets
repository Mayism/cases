import hilog from '@ohos.hilog';

export function getDate(date: Date): string {
  let year = date.getFullYear()
  let month = `0${date.getMonth() + 1}`.slice(-2)
  let day = `0${date.getDate()}`.slice(-2)
  return `${year}-${month}-${day}`
}

export function getSecond(date: Date): string {
  let hours = `0${date.getHours()}`.slice(-2)
  let minutes = `0${date.getMinutes()}`.slice(-2)
  let seconds = `0${date.getSeconds()}`.slice(-2)
  return `${hours}:${minutes}:${seconds}`
}

export function getFullDate(date: Date): string {
  return `${getDate(date)} ${getSecond(date)}`
}

export class Logger {
  private static domain: number = 0xFF00;
  private static prefix: string = '[ModulePoints]';
  private static format: string = '%{public}s, %{public}s';

  static debug(...args: string[]) {
    hilog.debug(Logger.domain, Logger.prefix, Logger.format, args);
  }

  static info(...args: string[]) {
    hilog.info(Logger.domain, Logger.prefix, Logger.format, args);
  }

  static warn(...args: string[]) {
    hilog.warn(Logger.domain, Logger.prefix, Logger.format, args);
  }

  static error(...args: string[]) {
    hilog.error(Logger.domain, Logger.prefix, Logger.format, args);
  }
}
