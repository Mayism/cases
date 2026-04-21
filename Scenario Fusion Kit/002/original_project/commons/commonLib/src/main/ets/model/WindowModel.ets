import { ConfigurationConstant } from '@kit.AbilityKit';

/**
 * 窗口持久化
 */
@ObservedV2
export class WindowModel {
  @Trace currentColorMode?: ConfigurationConstant.ColorMode
  @Trace fontSize: number = 0
}