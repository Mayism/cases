import { intl } from '@kit.LocalizationKit';

export class FormatUtils {
  static scientificFormat: intl.NumberFormat = new intl.NumberFormat('zh-CN', { minimumFractionDigits: 2, });

  /**
   * 格式化货币
   * @param money
   * @returns
   */
  static formatCurrency(money: number): string {
    return FormatUtils.scientificFormat.format(money);
  }
}