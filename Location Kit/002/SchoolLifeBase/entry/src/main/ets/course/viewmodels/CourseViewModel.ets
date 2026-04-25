/**
 * 课程助手 - 课程中心 ViewModel
 */

import { Timetable, Course, CourseArrangement, ScheduleCellData, DayPart } from '../../common/models/Models';
import { AppStore } from '../../common/store/Store';
import { getCurrentWeek, getWeekDateRange, getScheduleDataForWeek, createDefaultTimetable, generateId, getNextCourseColor } from '../../common/utils/Utils';
import { DEFAULT_TOTAL_WEEKS, DEFAULT_PERIODS, DAY_PART_PERIODS, WEEKDAY_NAMES } from '../../common/constants/Constants';

@ObservedV2
export class CourseViewModel {
  @Trace timetable: Timetable = createDefaultTimetable();
  @Trace currentWeek: number = 1;
  @Trace scheduleData: ScheduleCellData[] = [];
  @Trace isLoading: boolean = true;

  private store: AppStore = AppStore.getInstance();

  async loadData(): Promise<void> {
    this.isLoading = true;
    this.timetable = await this.store.getTimetable();
    this.currentWeek = getCurrentWeek(this.timetable.semester.anchorTimeMs, this.timetable.semester.weekCount);
    this.refreshSchedule();
    this.isLoading = false;
  }

  refreshSchedule(): void {
    this.scheduleData = getScheduleDataForWeek(this.timetable, this.currentWeek);
  }

  getWeekRange(): string {
    return getWeekDateRange(this.timetable.semester.anchorTimeMs, this.currentWeek);
  }

  getWeekLabel(): string {
    return `第${this.currentWeek}周`;
  }

  setWeek(week: number): void {
    this.currentWeek = week;
    this.refreshSchedule();
  }

  async setAnchorDate(anchorTimeMs: number): Promise<void> {
    this.timetable.semester.anchorTimeMs = anchorTimeMs;
    this.timetable.semester.label = this.generateSemesterLabel(anchorTimeMs);
    this.currentWeek = getCurrentWeek(anchorTimeMs, this.timetable.semester.weekCount);
    await this.store.saveTimetable(this.timetable);
    this.refreshSchedule();
  }

  async addCourse(name: string, arrangements: CourseArrangement[]): Promise<string> {
    const course: Course = {
      id: generateId(),
      name: name,
      color: getNextCourseColor(this.timetable.courses),
      arrangements: arrangements
    };
    this.timetable.courses.push(course);
    await this.store.saveTimetable(this.timetable);
    this.refreshSchedule();
    return course.id;
  }

  async updateCourse(courseId: string, name: string, arrangements: CourseArrangement[]): Promise<void> {
    for (let i = 0; i < this.timetable.courses.length; i++) {
      if (this.timetable.courses[i].id === courseId) {
        this.timetable.courses[i].name = name;
        this.timetable.courses[i].arrangements = arrangements;
        break;
      }
    }
    await this.store.saveTimetable(this.timetable);
    this.refreshSchedule();
  }

  async deleteCourse(courseId: string): Promise<void> {
    const newCourses: Course[] = [];
    for (let i = 0; i < this.timetable.courses.length; i++) {
      if (this.timetable.courses[i].id !== courseId) {
        newCourses.push(this.timetable.courses[i]);
      }
    }
    this.timetable.courses = newCourses;
    await this.store.saveTimetable(this.timetable);
    this.refreshSchedule();
  }

  getCourseById(courseId: string): Course | null {
    for (let i = 0; i < this.timetable.courses.length; i++) {
      if (this.timetable.courses[i].id === courseId) {
        return this.timetable.courses[i];
      }
    }
    return null;
  }

  getMonthLabel(): string {
    const date: Date = new Date(this.timetable.semester.anchorTimeMs);
    return `${date.getMonth() + 1}`;
  }

  private generateSemesterLabel(anchorTimeMs: number): string {
    const date: Date = new Date(anchorTimeMs);
    const year: number = date.getFullYear();
    const month: number = date.getMonth() + 1;
    const startYear: number = month >= 9 ? year : year - 1;
    const endYear: number = startYear + 1;
    const semesterNum: number = (month >= 9 || month < 3) ? 1 : 2;
    return `${startYear}-${endYear}学年 第${semesterNum}学期`;
  }
}