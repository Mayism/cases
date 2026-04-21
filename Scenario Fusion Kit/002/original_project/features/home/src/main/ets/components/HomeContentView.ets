import { JSON, util } from '@kit.ArkTS';
import { AppStorageV2 } from '@kit.ArkUI';
import { CommonConstants, NewsData, NewsDataSource, WindowModel } from 'commonlib';
import { RefreshListController, RefreshListView } from 'componentlib';

const NEWS_MOCK_DATA_COUNT: number = 8;
const MOCK_DATA_FILE_ONE_DIR: string = getContext(this).resourceManager.getStringSync($r('app.string.mock1').id);
const MOCK_DATA_FILE_TWO_DIR: string = getContext(this).resourceManager.getStringSync($r('app.string.mock2').id);
const NEWS_REFRESH_TIME: number = 1000;
const swiperImage: Resource[] = [
  $r('app.media.ic_picture'),
  $r('app.media.ic_fengjing_01')
]

@ComponentV2
export struct HomeContentView {
  @Local newsData: NewsDataSource = new NewsDataSource();
  @Local firstIndex: number = 0;
  private mockFlag: boolean = true;
  readonly SWITCH_BUTTON: number = 3;
  @Local isLoadingMore: boolean = false;

  private refreshListController: RefreshListController = new RefreshListController()
  windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;

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
    Column() {
      Stack() {
        RefreshListView({
          newsData: this.newsData,
          isLoadingMore: this.isLoadingMore,
          changeFontSize: this.windowModel.fontSize,
          refreshListController: this.refreshListController,
          customSwiperBuilder: () => {
            this.CustomSwiper()
          },
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
            .width(24)
            .height(24)
            .opacity(0.8)
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
        .backgroundColor('#0A59F7')
        .borderRadius(24)
        .margin({
          right: 32,
          bottom: 60
        })
      }
      .alignContent(Alignment.BottomEnd)
      .layoutWeight(1)
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('app.color.bgc'))
  }

  @Builder
  CustomSwiper() {
    Column() {
      Text('华为发布机场智能运控中心等五大航空解决方案，加速行业智能化,加速行业智能化,引领行业智能化升级。')
        .fontSize(`${16 + this.windowModel.fontSize}`)
        .fontColor($r('app.color.news_title_fontColor'))
        .layoutWeight(1)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontWeight('medium')
        .padding({ right: 8, left: 12, top: 12 })
        .width('100%')
      Swiper() {
        ForEach(swiperImage, (item: string) => {
          Image(item)
            .aspectRatio(2.25)
            .borderRadius(8)
            .backgroundColor(Color.White)
        }, (item: string) => JSON.stringify(item))
      }
      .borderRadius(8)
      .margin({ right: 12, left: 12, top: 4 })
      .backgroundColor(Color.White)
      Row() {
        Text('xx新闻')
          .fontSize(`${10 + this.windowModel.fontSize}`)
          .fontWeight('regular')
          .fontFamily('鸿蒙黑体')
          .fontColor($r('app.color.news_time_fontColor'))
          .margin({bottom: 6})

        Text('2025年04月12日')
          .fontSize(`${10 + this.windowModel.fontSize}`)
          .fontWeight('regular')
          .fontFamily('鸿蒙黑体')
          .fontColor($r('app.color.news_time_fontColor'))
          .margin({bottom: 6,left: 8})
      }
      .width('100%')
      .margin({left: 24,top: 10})
    }
    .height(`${252 + this.windowModel.fontSize}`)
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