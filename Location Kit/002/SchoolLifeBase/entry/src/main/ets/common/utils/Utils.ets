/**
 * 课程助手 - 工具函数
 */

import { DayPart, Period, Semester, Course, CourseArrangement, CourseCardData, ScheduleCellData, Timetable } from '../models/Models';
import { DEFAULT_PERIODS, DAY_PART_PERIODS, DEFAULT_TOTAL_WEEKS, COLOR_PALETTE, WEEKDAY_NAMES, DAY_PART_NAMES, MAX_TOTAL_WEEKS } from '../constants/Constants';

/**
 * 生成唯一ID
 */
export function generateId(): string {
  return Date.now().toString(36) + Math.random().toString(36).substring(2, 8);
}

/**
 * 分钟数转时间字符串 (如 480 -> "08:00")
 */
export function minutesToTimeStr(minutes: number): string {
  const hours: number = Math.floor(minutes / 60);
  const mins: number = minutes % 60;
  const hoursStr: string = hours < 10 ? `0${hours}` : `${hours}`;
  const minsStr: string = mins < 10 ? `0${mins}` : `${mins}`;
  return `${hoursStr}:${minsStr}`;
}

/**
 * 创建默认节次时间表
 */
export function createDefaultPeriods(): Period[] {
  const periods: Period[] = [];
  for (let i = 0; i < DEFAULT_PERIODS.length; i++) {
    const periodData: number[] = DEFAULT_PERIODS[i];
    let dayPart: DayPart = DayPart.MORNING;
    if (i >= 4 && i <= 7) {
      dayPart = DayPart.AFTERNOON;
    } else if (i >= 8) {
      dayPart = DayPart.EVENING;
    }
    const period: Period = {
      dayPart: dayPart,
      startMin: periodData[0],
      endMin: periodData[1]
    };
    periods.push(period);
  }
  return periods;
}

/**
 * 创建默认课表
 */
export function createDefaultTimetable(): Timetable {
  const now: Date = new Date();
  const anchorDate: Date = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  const semester: Semester = {
    label: generateSemesterLabel(anchorDate.getTime()),
    anchorTimeMs: anchorDate.getTime(),
    weekCount: DEFAULT_TOTAL_WEEKS
  };
  return {
    id: generateId(),
    semester: semester,
    periods: createDefaultPeriods(),
    courses: []
  };
}

/**
 * 生成学期标签 (如 "2025-2026学年 第2学期")
 */
export function generateSemesterLabel(anchorTimeMs: number): string {
  const date: Date = new Date(anchorTimeMs);
  const year: number = date.getFullYear();
  const month: number = date.getMonth() + 1;
  const startYear: number = month >= 9 ? year : year - 1;
  const endYear: number = startYear + 1;
  const semesterNum: number = (month >= 9 || month < 3) ? 1 : 2;
  return `${startYear}-${endYear}学年 第${semesterNum}学期`;
}

/**
 * 计算当前周数
 */
export function getCurrentWeek(anchorTimeMs: number, weekCount: number): number {
  const now: Date = new Date();
  const anchor: Date = new Date(anchorTimeMs);
  const diffMs: number = now.getTime() - anchor.getTime();
  const diffDays: number = Math.floor(diffMs / (24 * 60 * 60 * 1000));
  let week: number = Math.floor(diffDays / 7) + 1;
  if (week < 1) {
    week = 1;
  }
  if (week > weekCount) {
    week = weekCount;
  }
  return week;
}

/**
 * 获取指定周的日期范围
 */
export function getWeekDateRange(anchorTimeMs: number, weekNum: number): string {
  const anchor: Date = new Date(anchorTimeMs);
  const anchorDay: number = anchor.getDay();
  const mondayOffset: number = anchorDay === 0 ? -6 : 1 - anchorDay;
  const weekStart: Date = new Date(anchor.getTime());
  weekStart.setDate(anchor.getDate() + mondayOffset + (weekNum - 1) * 7);
  const weekEnd: Date = new Date(weekStart.getTime());
  weekEnd.setDate(weekStart.getDate() + 6);
  const startMonth: number = weekStart.getMonth() + 1;
  const startDay: number = weekStart.getDate();
  const endMonth: number = weekEnd.getMonth() + 1;
  const endDay: number = weekEnd.getDate();
  return `${startMonth}/${startDay} - ${endMonth}/${endDay}`;
}

/**
 * 获取指定周的某一天的日期
 */
export function getWeekDayDate(anchorTimeMs: number, weekNum: number, dayOfWeek: number): Date {
  const anchor: Date = new Date(anchorTimeMs);
  const anchorDay: number = anchor.getDay();
  const mondayOffset: number = anchorDay === 0 ? -6 : 1 - anchorDay;
  const targetDate: Date = new Date(anchor.getTime());
  const dayOffset: number = dayOfWeek === 0 ? 6 : dayOfWeek - 1;
  targetDate.setDate(anchor.getDate() + mondayOffset + (weekNum - 1) * 7 + dayOffset);
  return targetDate;
}

/**
 * 获取课程颜色 (自动分配)
 */
export function getCourseColor(courses: Course[], index: number): string {
  if (index < COLOR_PALETTE.length) {
    return COLOR_PALETTE[index];
  }
  return COLOR_PALETTE[index % COLOR_PALETTE.length];
}

/**
 * 获取下一个课程颜色
 */
export function getNextCourseColor(courses: Course[]): string {
  const index: number = courses.length;
  return getCourseColor(courses, index);
}

/**
 * 获取指定日期的课程卡片数据
 */
export function getCourseCardsForDay(timetable: Timetable, date: Date): CourseCardData[] {
  const dayOfWeek: number = date.getDay();
  const currentMinutes: number = date.getHours() * 60 + date.getMinutes();
  const weekNum: number = getCurrentWeek(timetable.semester.anchorTimeMs, timetable.semester.weekCount);
  const weekMask: number = 1 << (weekNum - 1);
  const cards: CourseCardData[] = [];

  for (let i = 0; i < timetable.courses.length; i++) {
    const course: Course = timetable.courses[i];
    for (let j = 0; j < course.arrangements.length; j++) {
      const arr: CourseArrangement = course.arrangements[j];
      if (arr.dayOfWeek === dayOfWeek && (arr.weekMask & weekMask) !== 0) {
        const startPeriod: Period = timetable.periods[arr.periodStart];
        const endPeriod: Period = timetable.periods[arr.periodEnd];
        const periodLabel: string = DAY_PART_NAMES[startPeriod.dayPart] || '';
        const timeRange: string = `${minutesToTimeStr(startPeriod.startMin)}-${minutesToTimeStr(endPeriod.endMin)}`;
        const isFinished: boolean = currentMinutes > endPeriod.endMin;
        const cardData: CourseCardData = {
          courseId: course.id,
          courseName: course.name,
          color: course.color,
          periodLabel: periodLabel,
          timeRange: timeRange,
          location: arr.location,
          teacher: arr.teacher,
          isFinished: isFinished
        };
        cards.push(cardData);
      }
    }
  }

  // 按时间排序
  cards.sort((a: CourseCardData, b: CourseCardData) => {
    const periodA: Period = timetable.periods[0];
    const periodB: Period = timetable.periods[0];
    return 0;
  });

  return cards;
}

/**
 * 获取指定周的课表网格数据
 */
export function getScheduleDataForWeek(timetable: Timetable, weekNum: number): ScheduleCellData[] {
  const weekMask: number = 1 << (weekNum - 1);
  const cells: ScheduleCellData[] = [];

  for (let i = 0; i < timetable.courses.length; i++) {
    const course: Course = timetable.courses[i];
    for (let j = 0; j < course.arrangements.length; j++) {
      const arr: CourseArrangement = course.arrangements[j];
      if ((arr.weekMask & weekMask) !== 0) {
        const cellData: ScheduleCellData = {
          courseId: course.id,
          courseName: course.name,
          location: arr.location,
          color: course.color,
          periodStart: arr.periodStart,
          periodEnd: arr.periodEnd,
          dayOfWeek: arr.dayOfWeek
        };
        cells.push(cellData);
      }
    }
  }

  return cells;
}

/**
 * 检查时段冲突
 */
export function checkTimeConflict(
  arrangements: CourseArrangement[],
  existingCourses: Course[],
  excludeCourseId: string
): string {
  // 检查自身时段重叠
  for (let i = 0; i < arrangements.length; i++) {
    for (let j = i + 1; j < arrangements.length; j++) {
      const a: CourseArrangement = arrangements[i];
      const b: CourseArrangement = arrangements[j];
      if (a.dayOfWeek === b.dayOfWeek && hasWeekOverlap(a.weekMask, b.weekMask)) {
        if (hasPeriodOverlap(a.periodStart, a.periodEnd, b.periodStart, b.periodEnd)) {
          return '当前课程存在时段重叠';
        }
      }
    }
  }

  // 检查与其他课程冲突
  for (let i = 0; i < arrangements.length; i++) {
    const newArr: CourseArrangement = arrangements[i];
    for (let ci = 0; ci < existingCourses.length; ci++) {
      const existingCourse: Course = existingCourses[ci];
      if (existingCourse.id === excludeCourseId) {
        continue;
      }
      for (let j = 0; j < existingCourse.arrangements.length; j++) {
        const existArr: CourseArrangement = existingCourse.arrangements[j];
        if (newArr.dayOfWeek === existArr.dayOfWeek && hasWeekOverlap(newArr.weekMask, existArr.weekMask)) {
          if (hasPeriodOverlap(newArr.periodStart, newArr.periodEnd, existArr.periodStart, existArr.periodEnd)) {
            return `当前课程与已有课程'${existingCourse.name}'存在时段重叠`;
          }
        }
      }
    }
  }

  return '';
}

/**
 * 检查周掩码是否有重叠
 */
function hasWeekOverlap(mask1: number, mask2: number): boolean {
  return (mask1 & mask2) !== 0;
}

/**
 * 检查节次是否有重叠
 */
function hasPeriodOverlap(start1: number, end1: number, start2: number, end2: number): boolean {
  return start1 <= end2 && start2 <= end1;
}

/**
 * 手机号脱敏
 */
export function maskPhoneNumber(phone: string): string {
  if (phone.length < 7) {
    return phone;
  }
  const prefix: string = phone.substring(0, 3);
  const suffix: string = phone.substring(phone.length - 4);
  return `${prefix}****${suffix}`;
}

/**
 * 获取周掩码描述 (如 "第1-16周")
 */
export function getWeekMaskDescription(weekMask: number, weekCount: number): string {
  const weeks: number[] = [];
  for (let i = 0; i < weekCount; i++) {
    if ((weekMask & (1 << i)) !== 0) {
      weeks.push(i + 1);
    }
  }
  if (weeks.length === 0) {
    return '';
  }
  if (weeks.length === weekCount) {
    return `第1-${weekCount}周`;
  }
  // 简化：连续周显示范围
  const start: number = weeks[0];
  const end: number = weeks[weeks.length - 1];
  if (end - start + 1 === weeks.length) {
    return `第${start}-${end}周`;
  }
  return `第${weeks.join(',')}周`;
}

/**
 * 获取星期几名称
 */
export function getDayOfWeekName(dayOfWeek: number): string {
  if (dayOfWeek >= 0 && dayOfWeek < WEEKDAY_NAMES.length) {
    return WEEKDAY_NAMES[dayOfWeek];
  }
  return '';
}

/**
 * 获取节次描述 (如 "周一 第1-2节")
 */
export function getPeriodDescription(arrangement: CourseArrangement): string {
  const dayName: string = getDayOfWeekName(arrangement.dayOfWeek);
  const startPeriod: number = arrangement.periodStart + 1;
  const endPeriod: number = arrangement.periodEnd + 1;
  if (startPeriod === endPeriod) {
    return `周${dayName} 第${startPeriod}节`;
  }
  return `周${dayName} 第${startPeriod}-${endPeriod}节`;
}