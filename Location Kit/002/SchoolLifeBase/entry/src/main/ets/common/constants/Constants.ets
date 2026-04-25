/**
 * 课程助手 - 常量定义
 */

// 课程名称最大长度
export const MAX_COURSE_NAME_LENGTH: number = 100;

// 默认学期总周数
export const DEFAULT_TOTAL_WEEKS: number = 25;

// 学期最大周数
export const MAX_TOTAL_WEEKS: number = 31;

// 默认课程节数
export const DEFAULT_PERIOD_COUNT: number = 10;

// 签到码长度
export const CHECKIN_CODE_LENGTH: number = 4;

// 开发模式签到码
export const DEV_CHECKIN_CODE: string = '1111';

// 课程颜色调色板
export const COLOR_PALETTE: string[] = [
  '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
  '#DDA0DD', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E9'
];

// 星期名称
export const WEEKDAY_NAMES: string[] = ['日', '一', '二', '三', '四', '五', '六'];

// 时段名称
export const DAY_PART_NAMES: Record<string, string> = {
  'MORNING': '上午',
  'AFTERNOON': '下午',
  'EVENING': '晚上'
};

// 默认节次时间表 (分钟数)
export const DEFAULT_PERIODS: number[][] = [
  [480, 525],   // 第1节 08:00-08:45
  [530, 575],   // 第2节 08:50-09:35
  [595, 640],   // 第3节 09:55-10:40
  [645, 690],   // 第4节 10:45-11:30
  [780, 825],   // 第5节 13:00-13:45
  [830, 875],   // 第6节 13:50-14:35
  [895, 940],   // 第7节 14:55-15:40
  [945, 990],   // 第8节 15:45-16:30
  [1025, 1070], // 第9节 17:05-17:50
  [1075, 1120]  // 第10节 17:55-18:40
];

// 时段对应的节次范围
export const DAY_PART_PERIODS: Record<string, number[]> = {
  'MORNING': [0, 1, 2, 3],
  'AFTERNOON': [4, 5, 6, 7],
  'EVENING': [8, 9]
};

// 页面路由
export const ROUTE_TIMETABLE: string = 'TimetablePage';
export const ROUTE_COURSE_FORM: string = 'CourseFormPage';
export const ROUTE_COURSE_DETAIL: string = 'CourseDetailPage';
export const ROUTE_CHECKIN: string = 'CheckinPage';

// 存储键名
export const STORE_KEY_TIMETABLE: string = 'timetable';
export const STORE_KEY_SESSION_TOKEN: string = 'sessionToken';
export const STORE_KEY_PRIVACY_AGREED: string = 'privacyAgreed';
export const STORE_KEY_ANCHOR_DATE: string = 'anchorDate';

// UI 尺寸常量
export const PAGE_PADDING: number = 16;
export const CARD_RADIUS: number = 16;
export const CARD_PADDING: number = 16;
export const ITEM_GAP: number = 12;
export const TAB_HEIGHT: number = 48;
export const TITLE_BAR_HEIGHT: number = 56;