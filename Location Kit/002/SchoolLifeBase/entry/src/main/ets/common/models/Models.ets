/**
 * 课程助手 - 数据模型定义
 */

// 时段枚举
export enum DayPart {
  MORNING = 'MORNING',
  AFTERNOON = 'AFTERNOON',
  EVENING = 'EVENING'
}

// 认证状态
export enum AuthStatus {
  Unknown = 0,
  SignedOut = 1,
  SignedIn = 2
}

// 相对日期
export enum RelativeDay {
  Today = 'TODAY',
  Tomorrow = 'TOMORROW'
}

// 表单模式
export enum FormMode {
  Create = 'CREATE',
  Edit = 'EDIT'
}

// 意图任务
export enum IntentTask {
  NONE = 'NONE',
  GO_TO_HOME_PAGE = 'GO_TO_HOME_PAGE',
  GO_TO_CHECKIN_PAGE = 'GO_TO_CHECKIN_PAGE'
}

// 节次时间表
export interface Period {
  dayPart: DayPart;
  startMin: number;
  endMin: number;
}

// 学期信息
export interface Semester {
  label: string;
  anchorTimeMs: number;
  weekCount: number;
}

// 课程安排
export interface CourseArrangement {
  id: string;
  courseId: string;
  dayOfWeek: number; // 0=周日, 1=周一...6=周六
  periodStart: number; // 起始节次索引(0=第1节)
  periodEnd: number; // 结束节次索引
  location: string;
  teacher: string;
  weekMask: number; // 周选择掩码
}

// 课程
export interface Course {
  id: string;
  name: string;
  color: string;
  arrangements: CourseArrangement[];
}

// 课表
export interface Timetable {
  id: string;
  semester: Semester;
  periods: Period[];
  courses: Course[];
}

// 签到信息
export interface CheckinInfo {
  courseId: string;
  courseName: string;
  isCheckedIn: boolean;
}

// 用户信息
export interface UserInfo {
  avatarUri: string;
  nickname: string;
  phoneNumber: string;
  isBound: boolean;
}

// 周选择器快捷选项
export enum WeekPickerMode {
  ALL = 'ALL',
  ODD = 'ODD',
  EVEN = 'EVEN',
  CUSTOM = 'CUSTOM'
}

// 课程卡片展示数据
export interface CourseCardData {
  courseId: string;
  courseName: string;
  color: string;
  periodLabel: string; // 如 "上午"
  timeRange: string; // 如 "08:00-09:35"
  location: string;
  teacher: string;
  isFinished: boolean;
}

// 课表网格单元格数据
export interface ScheduleCellData {
  courseId: string;
  courseName: string;
  location: string;
  color: string;
  periodStart: number;
  periodEnd: number;
  dayOfWeek: number;
}