import { Logger } from './Logger';

export class RouterUtil {
  public static navPathStack: NavPathStack = new NavPathStack();

  private constructor() {
  }

  static pushPathByName(name: string, param: object | null = null, onPop?: Callback<PopInfo>, animated?: boolean) {
    Logger.info(`RouterUtil route: ${name}`)
    RouterUtil.navPathStack.pushPathByName(name, param, onPop, animated)
  }

  static pop(result?: Object) {
    RouterUtil.navPathStack.pop(result)
  }

  static popToName(name: string) {
    RouterUtil.navPathStack.popToName(name)
  }

  static getLatestParam(): object {
    return RouterUtil.navPathStack.getParamByIndex(RouterUtil.navPathStack.getAllPathName().length - 1) as object
  }

  static getParamByName(name: string): Array<object> {
    return RouterUtil.navPathStack.getParamByName(name) as Array<object>
  }
}