/**
 * 课程助手 - 数据持久化存储
 */

import { Timetable } from '../models/Models';
import { STORE_KEY_TIMETABLE, STORE_KEY_PRIVACY_AGREED, STORE_KEY_ANCHOR_DATE } from '../constants/Constants';
import { createDefaultTimetable } from '../utils/Utils';
import { preferences } from '@kit.ArkData';

const STORE_NAME: string = 'schoollife_store';

export class AppStore {
  private static instance: AppStore | null = null;
  private prefs: preferences.Preferences | null = null;

  private constructor() {}

  static getInstance(): AppStore {
    if (AppStore.instance === null) {
      AppStore.instance = new AppStore();
    }
    return AppStore.instance;
  }

  async init(context: Context): Promise<void> {
    this.prefs = await preferences.getPreferences(context, STORE_NAME);
  }

  async getTimetable(): Promise<Timetable> {
    if (this.prefs === null) {
      return createDefaultTimetable();
    }
    const json: string = await this.prefs.get(STORE_KEY_TIMETABLE, '') as string;
    if (json.length === 0) {
      return createDefaultTimetable();
    }
    try {
      const timetable: Timetable = JSON.parse(json) as Timetable;
      return timetable;
    } catch (e) {
      return createDefaultTimetable();
    }
  }

  async saveTimetable(timetable: Timetable): Promise<void> {
    if (this.prefs === null) {
      return;
    }
    const json: string = JSON.stringify(timetable);
    await this.prefs.put(STORE_KEY_TIMETABLE, json);
    await this.prefs.flush();
  }

  async isPrivacyAgreed(): Promise<boolean> {
    if (this.prefs === null) {
      return false;
    }
    return await this.prefs.get(STORE_KEY_PRIVACY_AGREED, false) as boolean;
  }

  async setPrivacyAgreed(agreed: boolean): Promise<void> {
    if (this.prefs === null) {
      return;
    }
    await this.prefs.put(STORE_KEY_PRIVACY_AGREED, agreed);
    await this.prefs.flush();
  }

  async getAnchorDate(): Promise<number> {
    if (this.prefs === null) {
      return new Date().getTime();
    }
    return await this.prefs.get(STORE_KEY_ANCHOR_DATE, new Date().getTime()) as number;
  }

  async saveAnchorDate(anchorTimeMs: number): Promise<void> {
    if (this.prefs === null) {
      return;
    }
    await this.prefs.put(STORE_KEY_ANCHOR_DATE, anchorTimeMs);
    await this.prefs.flush();
  }
}