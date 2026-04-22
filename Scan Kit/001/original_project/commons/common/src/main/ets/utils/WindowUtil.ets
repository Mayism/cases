import { ToastDialog } from '@hw-agconnect/ui-toast';
import { UtilLog as Logger } from '@hw-agconnect/util-log';
import { common } from '@kit.AbilityKit';
import { UIContext, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = '[WindowUtil]';

class WindowUtil {
  private contextMap: Map<string, UIContext> = new Map();
  private _uiContext: UIContext | undefined;
  private _context: Context | undefined;

  /**
   * 获取全局UIContext
   * @returns
   */
  public get globalUIContext() {
    return this._uiContext as UIContext;
  }

  /**
   * 获取全局Context
   * @returns
   */
  public get globalContext() {
    return this._context as Context;
  }

  /**
   * 获取全局UIAbilityContext
   * @returns
   */
  public get globalUIAbilityContext() {
    return this._context as common.UIAbilityContext;
  }

  /**
   * 设置context
   * @param uiContext
   */
  public setUIContext(abilityName: string, uiContext: UIContext) {
    this.contextMap.set(abilityName, uiContext);
    this.setActiveContext(abilityName);
  }

  /**
   * 设置context
   * @param uiContext
   */
  public setContext(context: Context) {
    this._context = context;
  }

  /**
   * 设置激活状态的context
   * @param abilityName
   */
  public setActiveContext(abilityName: string) {
    this._uiContext = this.contextMap.get(abilityName);
    this._context = this._uiContext?.getHostContext();
  }

  /**
   * 打开toast
   * @param options
   */
  public showToast(message: string) {
    ToastDialog.showToast({ message })
  }

  public toast(message: string) {
    ToastDialog.showToast({ message });
  }

  public async setWindowScreen(isFull: boolean) {
    window.getLastWindow(this._context).then((win) => {
      win.setWindowLayoutFullScreen(isFull).catch((err: BusinessError) => {
        Logger.error(TAG, 'set window layout failed. error: ' + JSON.stringify(err))
      })
    }).catch((err: BusinessError) => {
      Logger.error(TAG, 'get last window failed. error: ' + JSON.stringify(err))
    })
  }
}

const instance = new WindowUtil();

export { instance as WindowUtil };
