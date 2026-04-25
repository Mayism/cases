import { i18n } from '@kit.LocalizationKit'

export class CommonUtil {
  private static isRTL: boolean = i18n.isRTL(new Intl.Locale('zh-CN').language)

  public static setIsRTL(isRTL: boolean): void {
    CommonUtil.isRTL = isRTL
  }

  public static getIsRTL(): boolean {
    return CommonUtil.isRTL
  }
}