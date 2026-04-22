import { RouterMap } from '../constants/Common';
import { UtilLog as Logger } from '@hw-agconnect/util-log';
import { NavPushPathHelper } from '@kit.ArkUI';

const TAG: string = '[RouterModule]';

export class RouterModule {
  private static _stack: NavPathStack = new NavPathStack();
  private static helper: NavPushPathHelper = new NavPushPathHelper(this._stack)

  public static getStack() {
    return RouterModule._stack;
  }

  // 跳转到指定路由栈的指定路由页面
  public static push<T = object>(url: RouterMap | string, param?: T, onPop?: Callback<PopInfo>, animated?: boolean) {
    try {
      RouterModule._stack.pushPathByName(url, param, onPop, animated);
    } catch (err) {
      Logger.error(TAG, 'navigation stack push failed::' + JSON.stringify(err));
    }
  }

  // 跨模块跳转到指定路由栈的指定路由页面
  public static helperPush(
    moduleName: string,
    name: RouterMap | string,
    param: Record<string, object> = {},
    onPop: Callback<PopInfo> = () => {},
    animated?: boolean,
  ) {
    try {
      RouterModule.helper.pushPathByName(moduleName, name, param, onPop, animated);
    } catch (err) {
      Logger.error(TAG, 'navigation stack push failed::' + JSON.stringify(err));
    }
  }

  // 将指定路由栈的栈顶页面退出，将info指定的NavDestination页面信息入栈
  public static replace<T = object>(url: RouterMap | string, param?: T) {
    try {
      RouterModule._stack.replacePathByName(url, param);
    } catch (err) {
      Logger.error(TAG, 'navigation stack replace failed::' + JSON.stringify(err));
    }
  }

  // 弹出栈顶元素
  public static pop(result?: Object, animated?: boolean) {
    try {
      RouterModule._stack.pop(result, animated);
    } catch (err) {
      Logger.error(TAG, 'navigation stack pop failed::' + JSON.stringify(err));
    }
  }

  // 回退路由栈到由栈底开始第一个名为name的NavDestination页面
  public static popToName<T = object>(name: string, result?: T, animated?: boolean) {
    try {
      RouterModule._stack.popToName(name, result, animated);
    } catch (err) {
      Logger.error(TAG, 'navigation stack pop to name failed::' + JSON.stringify(err));
    }
  }

  // 清除栈中的所有页面
  public static clear(animated?: boolean) {
    try {
      RouterModule._stack.clear(animated);
    } catch (err) {
      Logger.error(TAG, 'navigation stack clear failed::' + JSON.stringify(err));
    }
  }

  // 获取指定栈中指定页面的参数,不支持栈内存在多个同名页面的情况
  public static getNavParam<T>(url: RouterMap | string): T | undefined {
    try {
      const paramsArr = RouterModule._stack.getParamByName(url) as T[] | undefined[];
      if (paramsArr.length && paramsArr[paramsArr.length-1]) {
        return paramsArr[paramsArr.length-1];
      }
    } catch (err) {
      Logger.error(TAG, 'navigation stack get params failed::' + JSON.stringify(err));
    }
    return undefined;
  }

  // 获取栈大小
  public static size() {
    return RouterModule._stack.size();
  }
}
