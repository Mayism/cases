export class DateUtil {
  static formatDate(
    date: Date,
    split: string = '-',
    myWeekday?: string,
    myTimeStyle?: string
  ): string {
    let result = '';

    // 格式化日期 (YYYY-MM-DD)
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    result = `${year}${split}${month}${split}${day}`;

    // 添加星期
    if (myWeekday) {
      const weekdays = ['日', '一', '二', '三', '四', '五', '六'];
      const weekday = weekdays[date.getDay()];
      result += ` 周${weekday}`;
    }

    // 添加时间
    if (myTimeStyle) {
      const hour = String(date.getHours()).padStart(2, '0');
      const minute = String(date.getMinutes()).padStart(2, '0');
      const second = String(date.getSeconds()).padStart(2, '0');

      if (myTimeStyle === 'short') {
        result += ` ${hour}:${minute}`;
      } else if (myTimeStyle === 'long') {
        result += ` ${hour}:${minute}:${second}`;
      } else {
        result += ` ${hour}:${minute}:${second}`;
      }
    }

    return result;
  }

  static parseDateString(dateTimeStr: string): Date {
    if (!dateTimeStr) {
      return new Date()
    }

    const timeStrs: string[] = dateTimeStr?.split(' ');
    const datePart: string = timeStrs[0] || '';
    const timePart: string = timeStrs[1] || '';

    // 解析日期部分
    const dateNumbers: number[] = datePart.split('-').map(num => {
      const parsed = Number(num);
      return isNaN(parsed) ? 0 : parsed;
    });

    if (dateNumbers.length < 3) {
      throw new Error('Invalid date format, expected YYYY-MM-DD');
    }

    let date: Date = new Date(dateNumbers[0], dateNumbers[1] - 1, dateNumbers[2]);

    // 解析时间部分
    if (timePart) {
      const timeNumbers: number[] = timePart.split(':').map(num => {
        const parsed = Number(num);
        return isNaN(parsed) ? 0 : parsed;
      });

      if (timeNumbers.length > 0) {
        date.setHours(timeNumbers[0],
          timeNumbers.length > 1 ? timeNumbers[1] : date.getMinutes(),
          timeNumbers.length > 2 ? timeNumbers[2] : date.getSeconds());
      }
    }

    return date;
  }
}