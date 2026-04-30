import hilog from '@ohos.hilog';

/**
 * 日志打印类
 */
export class Logger {
  private static domain: number = 0xFF00;
  private static prefix: string = '[ShoppingMall]';
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
