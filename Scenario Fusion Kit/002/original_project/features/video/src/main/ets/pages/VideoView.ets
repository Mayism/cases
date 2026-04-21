import { BreakpointType, CommonConstants, Logger, PreferencesUtil, RouterMap, RouterModule } from 'commonlib';
import { VideoViewVm } from '../viewModels/VideoViewVm';
import { VideoModel } from '../viewModels/VideoModel';
import { CommonDataSource } from '../utils/CommonDataSource';
import { BaseTitle, GlobalDialog } from 'componentlib';
import { VideoPlayer } from '../components/VideoPlayer';
import { GetTableInfoResp, GetVideoInfoResp, HttpRequestApi } from 'network';
import { BusinessError } from '@kit.BasicServicesKit';

@Builder
export function videoViewBuilder() {
  VideoView()
}

@ComponentV2
export struct VideoView {
  vm: VideoViewVm = VideoViewVm.instance;
  @Local videoUrl: string =
    'https://agc-storage-drcn.platform.dbankcloud.cn/v0/default-bucket-nkths/videoTest.mp4?token=b7c7a44b-894f-45ee-9c56-33c41350c570';
  private dataSource = new CommonDataSource<VideoModel>([])
  @Local isRefreshing: boolean = false
  @Local isLoading: boolean = false;
  @Local isLoadingMore: boolean = false;
  private listScroller: ListScroller = new ListScroller();
  @Local offsetY: number = 0
  @Local showUpBtn: boolean = false
  @Local videoList: VideoModel[] = []
  @Local playIdx: number[] = []
  private videoInfo: VideoModel[] = []

  aboutToAppear(): void {
    GlobalDialog.showLoadingDialog()
    PreferencesUtil.getChangeFontSize().then((value:number) => {
      this.vm.changeFontSize = value;
      Logger.info('setfontsize', 'Get the value of changeFontSize: ' + this.vm.changeFontSize);
    });
    this.isLoading = true
    this.getList()
  }

  getList() {
    setTimeout(() => {
      HttpRequestApi.getTableInfo('')
        .then((resp: GetVideoInfoResp) => {
          if (resp) {
            this.videoInfo = resp as VideoModel[];
            for (let index = 0; index < 5; index++) {
              let item: VideoModel = new VideoModel()
              item.title = this.videoInfo[index].title
              item.videoUrl = this.videoUrl
              item.previewUri = this.videoInfo[index].previewUri
              item.videoController = new VideoController()
              this.videoList.push(item)
            }
            this.dataSource.setData(this.videoList)
            this.isRefreshing = false
            GlobalDialog.close()
            this.isLoading = false
          } else {
            console.error(`videoModelMockData error: ${JSON.stringify(resp)}.`);
          }
        })
        .catch((e: BusinessError) => {
          console.error(`videoModelMockData error: ${JSON.stringify(e)}.`);
        })

    }, 500)
  }

  @Builder
  VideoCon(item: VideoModel, index: number) {
    Column({ space: 8 }) {
      VideoPlayer({
        data: item,
        index: index,
        videoHeight: 184,
        playIdx: this.playIdx,
        player: (curIndex: number) => {
          for (let i = 0; i < this.playIdx.length; i++) {
            if (this.playIdx[i] !== curIndex) {
              this.videoList[this.playIdx[i]].videoController?.pause()
              this.playIdx.splice(i, 1)
            }
          }
        }
      })

      Row() {
        Text(item.title)
          .fontSize(`${16 + this.vm.changeFontSize}`)
          .fontColor($r('app.color.video_title'))
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')
      .onClick(() => {
        RouterModule.push({ url: RouterMap.VIDEO_DETAIL_PAGE, param: null });
      })

      Row({ space: 12 }) {
        Text('xx新闻')
          .fontSize(`${12 + this.vm.changeFontSize}`)
          .fontColor('#FF989898')
        Text('2小时前')
          .fontSize(`${12 + this.vm.changeFontSize}`)
          .fontColor('#FF989898')
      }
      .justifyContent(FlexAlign.Start)
      .width('100%')
    }
  }

  @Builder
  VideoTitleBuilder() {
    Text('视频')
      .fontSize(24)
      .fontWeight(FontWeight.Bold)
  }

  build() {
    Column({ space: 12 }) {
      BaseTitle({
        customTitle: () => {
          this.VideoTitleBuilder()
        },
      })

      Stack() {
        Refresh({ refreshing: $$this.isRefreshing, builder: this.customRefreshComponent }) {
          List({ space: 24, scroller: this.listScroller }) {
            LazyForEach(this.dataSource, (item: VideoModel, index: number) => {
              ListItem() {
                this.VideoCon(item, index)
              }
            }, (item: VideoModel) => JSON.stringify(item))

            ListItem() {
              this.footer()
            }
          }
          .width('100%')
          .height('100%')
          .scrollBar(BarState.Off)
          .padding({ left: 16, right: 16 })
          .onScrollIndex((start: number, end: number) => {
            // 当达到列表末尾时，触发新数据加载。
            if (end >= this.dataSource.totalCount() - 1) {
              this.isLoadingMore = true;
              // 模拟新数据加载。
              setTimeout(() => {
                let newList: VideoModel[] = []
                for (let i = 0; i < 5; i++) {
                  let item: VideoModel = new VideoModel()
                  item.title = this.videoInfo[i].title
                  item.videoUrl = this.videoUrl
                  item.previewUri = this.videoInfo[i].previewUri
                  item.videoController = new VideoController()
                  this.videoList.push(item)
                  newList.push(item)
                }
                this.dataSource.pushDataArray(...newList)
                console.log('pushDataArray:' + JSON.stringify(this.dataSource))
                this.isLoadingMore = false;
              }, 700)
            }
          })
          .scrollBar(BarState.Off)
          // 开启边缘滑动效果。
          .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
          .onScrollVisibleContentChange((start: VisibleListContentInfo, end: VisibleListContentInfo) => {
            if (this.offsetY !== 0) {
              this.showUpBtn = start.index > 0
            }
          })
          .onScrollFrameBegin((offset: number, state: ScrollState) => {
            this.offsetY = offset
            return { offsetRemain: offset }
          })
        }
        .layoutWeight(1)
        .onRefreshing(() => {
          this.getList()
        })
        .pullToRefresh(true)
        .refreshOffset(64)

        Row() {
          Image($r('app.media.ic_public_backtotop'))
            .width(24)
            .height(24)
            .opacity(0.8)
        }
        .offset({ right: new BreakpointType(16, 24, 32).getValue(AppStorage.get('currentBreakpoint')), bottom: 6 })
        .onClick(() => {
          this.listScroller.scrollToIndex(0, true)
          this.offsetY = 0
        })
        .visibility(this.showUpBtn ? Visibility.Visible : Visibility.Hidden)
        .justifyContent(FlexAlign.Center)
        .width(48)
        .height(48)
        .backgroundColor('#0A59F7')
        .borderRadius(24)
      }
      .alignContent(Alignment.BottomEnd)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bgc'));
  }

  @Builder
  customRefreshComponent() {
    Row() {
      LoadingProgress().color($r('sys.color.icon_secondary')).width(32).height(32)
    }
    .height(32)
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  footer() {
    Row() {
      LoadingProgress().height(32).width(32)
      Text('加载中')
    }.width('100%')
    .height(64)
    .justifyContent(FlexAlign.Center)
    // 当不处于加载中状态时隐藏组件。
    .visibility(this.isLoading ? Visibility.Hidden : (this.isLoadingMore ? Visibility.Visible : Visibility.Hidden))
  }
}
