import { NewsTypeModel } from './NewsTypeModel';

export class NewsViewModel {
  getDefaultTypeList(): NewsTypeModel[] {
    return [
      { id: 0, name: '热门' },
      { id: 1, name: '本地' }
    ];
  }
}