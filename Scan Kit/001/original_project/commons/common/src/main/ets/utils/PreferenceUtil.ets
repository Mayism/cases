import { UtilLog as Logger } from '@hw-agconnect/util-log';
import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { WindowUtil } from './WindowUtil';

export class PreferenceUtil {
  private static preferenceRecord: Map<string, PreferenceUtil> = new Map()
  private dataPreferences: preferences.Preferences | null = null

  private constructor(context: Context, fileName: string) {
    try {
      preferences.removePreferencesFromCacheSync(context, fileName)
    } catch (e) {
      Logger.error(`PreferenceUtil removePreferencesFromCacheSync failed`, e)
    }
    this.dataPreferences = preferences.getPreferencesSync(context, { name: fileName })
    Logger.info(`PreferenceUtil: ${fileName} init: ${this.dataPreferences != null}`)
  }

  public static getInstance(context?: Context, fileName: string = 'default') {
    if (PreferenceUtil.preferenceRecord.has(fileName)) {
      return PreferenceUtil.preferenceRecord.get(fileName)!!
    }
    let ctx = context || WindowUtil.globalUIAbilityContext as common.UIAbilityContext
    let preferenceUtil: PreferenceUtil = new PreferenceUtil(ctx, fileName);
    PreferenceUtil.preferenceRecord.set(fileName, preferenceUtil)
    return preferenceUtil
  }

  public put(key: string, value: object | string) {
    if (!this.dataPreferences) {
      Logger.info(`PreferenceUtil: dataPreferences is null`)
    }
    try {
      this.dataPreferences?.putSync(key, value)
      this.dataPreferences?.flush()
      Logger.info(`PreferenceUtil: put: ${key} = ${JSON.stringify(value)}`)
    } catch (e) {
      Logger.error(`PreferenceUtil: put error: ${JSON.stringify(e)}`)
    }
  }

  public get(key: string, defaultValue?: object | string) {
    try {
      let data = this.dataPreferences?.getSync(key, defaultValue)
      Logger.info(`PreferenceUtil: get: ${key} = ${JSON.stringify(data)}`)
      return data
    } catch (e) {
      Logger.error(`PreferenceUtil: get error: ${JSON.stringify(e)}`)
      return defaultValue
    }
  }

  public getWithPreference(preference: preferences.Preferences, key: string, defaultValue?: object | string) {
    try {
      let data = preference.getSync(key, defaultValue)
      Logger.info(`PreferenceUtil: get: ${key} = ${JSON.stringify(data)}`)
      return data
    } catch (e) {
      Logger.error(`PreferenceUtil: get error: ${JSON.stringify(e)}`)
      return defaultValue
    }
  }

  public putToArray(key: string, value: string) {
    if (!this.dataPreferences) {
      Logger.error(`PreferenceUtil: dataPreferences is null`)
    }
    let array: Array<string> = this.get(key) as Array<string> || []
    if (array.indexOf(value) !== -1) {
      Logger.error(`PreferenceUtil: value is exist`)
      return
    }
    array.push(value)
    Logger.info(`PreferenceUtil: save success`)
    this.put(key, array)
  }

  public removeFromArray(key: string, value: string) {
    if (!this.dataPreferences) {
      Logger.info(`PreferenceUtil: dataPreferences is null`)
    }
    let array: Array<string> = this.get(key) as Array<string> || []
    array.splice(array.indexOf(value), 1)
    this.put(key, array)
  }
}