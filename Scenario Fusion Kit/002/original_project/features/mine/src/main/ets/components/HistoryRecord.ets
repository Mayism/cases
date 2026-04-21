import { JSON, util } from '@kit.ArkTS';
import {
  NewsData,
  NewsDataSource,
  RouterMap, RouterModule } from 'commonlib';
import { RefreshListController, RefreshListView } from 'componentlib';
import { MainPageVM } from '../viewModels/MainPageVM';

const NEWS_MOCK_DATA_COUNT: number = 8;
const MOCK_DATA_FILE_ONE_DIR: string = getContext(this).resourceManager.getStringSync($r('app.string.mock1').id);
const MOCK_DATA_FILE_TWO_DIR: string = getContext(this).resourceManager.getStringSync($r('app.string.mock2').id);
const NEWS_REFRESH_TIME: number = 1000;

@Builder
export function historyRecordBuilder() {
  HistoryRecord();
}

@ComponentV2
export struct HistoryRecord {
  vm: MainPageVM = MainPageVM.instance;
  @Local newsData: NewsDataSource = new NewsDataSource();
  @Local firstIndex: number = 0;
  private mockFlag: boolean = true;
  readonly SWITCH_BUTTON: number = 3;
  @Local navTitle: string = '';
  @Local isLoadingMore: boolean = false;
  private refreshListController: RefreshListController = new RefreshListController()

  aboutToAppear() {
    let newsModelMockData: NewsData[] = getNews(MOCK_DATA_FILE_ONE_DIR);
    for (let j = 0; j < NEWS_MOCK_DATA_COUNT; j++) {
      this.newsData.pushData(newsModelMockData[j]);
    }
  }

  aboutToDisappear() {
    this.newsData.clear();
  }

  refreshList() {
    setTimeout(() => {
      this.newsData.clear();
      let newsModelMockData: NewsData[] = [];
      if (this.mockFlag) {
        newsModelMockData = getNews(MOCK_DATA_FILE_TWO_DIR);
      } else {
        newsModelMockData = getNews(MOCK_DATA_FILE_ONE_DIR);
      }
      this.mockFlag = !this.mockFlag;
      for (let j = 0; j < NEWS_MOCK_DATA_COUNT; j++) {
        this.newsData.pushData(newsModelMockData[j]);
      }
      this.refreshListController.changeRefreshState()
    }, NEWS_REFRESH_TIME);
  }

  build() {
    NavDestination() {
        Column() {
          Stack() {
            RefreshListView({
              newsData: this.newsData,
              isLoadingMore: this.isLoadingMore,
              changeFontSize: this.vm.changeFontSize,
              refreshListController: this.refreshListController,
              refresh: () => {
                this.refreshList()
              },
              loadMore: (start: number, end: number) => {
                this.firstIndex = start
                if (end >= this.newsData.totalCount() - 1) {
                  this.isLoadingMore = true;
                  setTimeout(() => {
                    let newsModelMockData: NewsData[] = getNews(MOCK_DATA_FILE_ONE_DIR);
                    for (let j = 0; j < NEWS_MOCK_DATA_COUNT; j++) {
                      this.newsData.pushData(newsModelMockData[j]);
                    }
                    this.isLoadingMore = false;
                  }, NEWS_REFRESH_TIME)
                }
              },
            })

            Row() {
              Image($r('app.media.ic_public_backtotop'))
                .width(24).height(24).opacity(0.8)
            }
            .onClick(() => {
              if (this.firstIndex >= this.SWITCH_BUTTON) {
                this.refreshListController.resetScroll()
              }
            })
            .visibility(this.firstIndex >= this.SWITCH_BUTTON ? Visibility.Visible : Visibility.None)
            .justifyContent(FlexAlign.Center)
            .width(48)
            .height(48)
            .margin({
              right: 32,
              bottom: 10
            })
            .backgroundColor('#0A59F7')
            .borderRadius(24)
          }
          .alignContent(Alignment.BottomEnd)
          .layoutWeight(1)
        }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.bgc'))
    }
    .title(this.navTitle)
    .onReady(() => {
      let params: string | undefined = RouterModule.getNavParam({
        url: RouterMap.HISTORY_RECORD,
      });
      if(params){
        this.navTitle = params;
      }
    });
  }
}

class JsonNewsList {
  public newsList: NewsData[] = [];
}

class JsonNewsData {
  private jsonFileDir: string = '';

  constructor(jsonFileDir: string) {
    this.jsonFileDir = jsonFileDir;
  }

  getNewsData(): Array<NewsData> {
    let value = getContext().resourceManager.getRawFileContentSync(this.jsonFileDir);
    let textDecoder = util.TextDecoder.create('utf-8', {
      ignoreBOM: true
    });
    let textDecoderResult = textDecoder.decodeToString(new Uint8Array(value.buffer));
    let jsonObj: JsonNewsList = JSON.parse(textDecoderResult) as JsonNewsList;
    let newsModelBuckets: NewsData[] = [];
    let newsModelObj = jsonObj.newsList;
    for (let i = 0; i < newsModelObj.length; i++) {
      let contactTemp = new NewsData(newsModelObj[i].newsId, newsModelObj[i].newsTitle,
        newsModelObj[i].newsContent, newsModelObj[i].newsTime, newsModelObj[i].newsImage);
      newsModelBuckets.push(contactTemp);
    }
    return newsModelBuckets;
  }
}

function getNews(mockFileDir: string): Array<NewsData> {
  let jsonObj: JsonNewsData = new JsonNewsData(mockFileDir);
  let newsModelMockData: NewsData[] = jsonObj.getNewsData();
  return newsModelMockData;
}

