import { AppStorageV2 } from '@kit.ArkUI';
import { WindowModel } from '../models/StorageModel';

/**
 * 所有ViewModel的基类，定义一些通用操作
 */
@ObservedV2
export abstract class BaseViewModel {
  @Trace windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
}