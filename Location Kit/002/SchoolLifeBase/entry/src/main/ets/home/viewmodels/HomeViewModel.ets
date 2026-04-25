/**
 * 课程助手 - 首页 ViewModel
 */

import { Timetable, CourseCardData, RelativeDay, AuthStatus } from '../../common/models/Models';
import { AppStore } from '../../common/store/Store';
import { getCourseCardsForDay, createDefaultTimetable } from '../../common/utils/Utils';

@ObservedV2
export class HomeViewModel {
  @Trace timetable: Timetable = createDefaultTimetable();
  @Trace currentDay: RelativeDay = RelativeDay.Today;
  @Trace todayCards: CourseCardData[] = [];
  @Trace tomorrowCards: CourseCardData[] = [];
  @Trace authStatus: AuthStatus = AuthStatus.Unknown;
  @Trace isLoading: boolean = true;
  @Trace bannerIndex: number = 0;

  private store: AppStore = AppStore.getInstance();

  async loadData(): Promise<void> {
    this.isLoading = true;
    this.timetable = await this.store.getTimetable();
    this.refreshCards();
    this.isLoading = false;
  }

  refreshCards(): void {
    const today: Date = new Date();
    const tomorrow: Date = new Date(today.getTime() + 24 * 60 * 60 * 1000);
    this.todayCards = getCourseCardsForDay(this.timetable, today);
    this.tomorrowCards = getCourseCardsForDay(this.timetable, tomorrow);
  }

  switchDay(day: RelativeDay): void {
    this.currentDay = day;
  }

  getCurrentCards(): CourseCardData[] {
    if (this.currentDay === RelativeDay.Today) {
      return this.todayCards;
    }
    return this.tomorrowCards;
  }

  getCurrentDayLabel(): string {
    if (this.currentDay === RelativeDay.Today) {
      return '今日课程';
    }
    return '明日课程';
  }

  getCourseCount(): number {
    return this.getCurrentCards().length;
  }

  isSignedIn(): boolean {
    return this.authStatus === AuthStatus.SignedIn;
  }
}