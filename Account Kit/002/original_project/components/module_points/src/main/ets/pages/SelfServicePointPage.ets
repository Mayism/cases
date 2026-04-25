import { scanBarcode, scanCore } from '@kit.ScanKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { Constants, MenuModel, NavHeaderBar, RouterMap } from '../libcommon/Index'
import { SelfPointRecordViewModel } from '../viewmodels/SelfPointRecordViewModel'
import { PointType } from '../constants/PointConstants'
import { Logger } from '../libcommon/Utils'
import { ContextUtils } from '../libcommon/ContextUtils'

const TAG = '[SelfServicePointPage]';

@Builder
export function SelfServicePointPageBuilder() {
  SelfServicePointPage()
}

@ComponentV2
struct SelfServicePointPage {
  @Local menuList: Array<MenuModel> = [
    new MenuModel($r('app.media.ic_self_icon1'), '自助积分记录', RouterMap.SELF_POINT_RECORD_PAGE),
    new MenuModel($r('app.media.ic_self_icon2'), '积分规则', RouterMap.SELF_POINT_RULE),
    new MenuModel($r('app.media.ic_self_icon3'), '自助积分指南', RouterMap.SELF_POINT_GUIDE),
  ];
  @Local vm: SelfPointRecordViewModel = new SelfPointRecordViewModel();
  @Provider() pathStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    ContextUtils.setUIContext(this.getUIContext());
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: '自助积分', hasBgColor: false })
      Scroll() {
        Column({ space: 12 }) {
          Image($r('app.media.point_banner'))
            .width(Constants.FULL_SIZE)
            .borderRadius(16)
            .constraintSize({
              maxHeight: '35%',
            })
          Column() {
            Row() {
              Column() {
                Text(this.vm.globalPointInfo.myPoints.toString())
                  .fontSize(18)
                  .fontColor($r('sys.color.font_primary'))
                  .fontWeight(FontWeight.Medium)
                Text('我的积分').fontSize(12).fontColor($r('sys.color.font_secondary')).margin({ top: 4 })
              }.alignItems(HorizontalAlign.Start)

              Button(this.vm.globalPointInfo.isCheckIn ? '已签到' : '签到', { controlSize: ControlSize.SMALL })
                .fontSize($r('sys.float.Body_M'))
                .fontColor($r('sys.color.font_on_primary'))
                .width(72)
                .backgroundColor($r('app.color.app_theme'))
                .padding({
                  top: 4,
                  bottom: 4,
                  left: 8,
                  right: 8,
                })
                .enabled(!this.vm.globalPointInfo.isCheckIn)
                .onClick(() => {
                  this.vm.checkIn();
                  ContextUtils.showToast({ message: '签到成功~' });
                })
            }.width(Constants.FULL_SIZE).justifyContent(FlexAlign.SpaceBetween)

            Row({ space: 32 }) {
              Column() {
                Row() {
                  Stack() {
                    Row()
                      .width(40)
                      .height(40)
                      .padding(9)
                      .opacity(0.4)
                      .backgroundColor($r('sys.color.background_primary'))
                      .borderRadius(20)
                    Image($r('app.media.ic_scans')).width(22)
                  }
                }
                .width(Constants.FULL_SIZE)
                .justifyContent(FlexAlign.End)
                .margin({ top: 8, right: 8 })

                Row() {
                  Text('扫码积分').fontSize(16).fontColor($r('sys.color.font_primary'))
                }.width(Constants.FULL_SIZE)
                .margin({ left: 12, bottom: 12 })

              }
              .height(124)
              .layoutWeight(1)
              .justifyContent(FlexAlign.SpaceBetween)
              .borderRadius(16)
              .linearGradient({
                direction: GradientDirection.Right, // 渐变方向
                repeating: false, // 渐变颜色是否重复
                colors: [['#7FDE3C', 0.0], ['#DDFFB8', 1]], // 数组末尾元素占比小于1时满足重复着色效果
              })
              .onClick(() => {
                // 定义扫码参数options
                let options: scanBarcode.ScanOptions = {
                  scanTypes: [scanCore.ScanType.ALL],
                  enableMultiMode: true,
                  enableAlbum: true,
                };
                try {
                  scanBarcode.startScanForResult(ContextUtils.globalContext, options)
                    .then((result: scanBarcode.ScanResult) => {
                      Logger.info(TAG, `Succeeded in getting ScanResult, result is ${JSON.stringify(result)}`);
                      this.vm.showPointSubmitConfirm(PointType.SCAN, result.originalValue);
                    })
                    .catch((error: BusinessError) => {
                      Logger.error(TAG, `Failed to get ScanResult. Code:${error.code}, message: ${error.message}`);
                    });
                } catch (error) {
                  Logger.error(TAG,
                    `Failed to start the scanning service. Code:${error.code}, message: ${error.message}`);
                }
              })

              Column() {
                Row() {
                  Image($r('app.media.ic_camera_bg')).width(40)
                }
                .width(Constants.FULL_SIZE)
                .justifyContent(FlexAlign.End)
                .margin({ top: 8, right: 8 })

                Row() {
                  Text('拍照积分').fontSize(16).fontColor($r('sys.color.font_primary'))
                }.width(Constants.FULL_SIZE)
                .margin({ left: 12, bottom: 12 })
              }
              .height(124)
              .layoutWeight(1)
              .borderRadius(16)
              .linearGradient({
                direction: GradientDirection.Right, // 渐变方向
                repeating: false, // 渐变颜色是否重复
                colors: [['#7FDE3C', 0.0], ['#DDFFB8', 1]], // 数组末尾元素占比小于1时满足重复着色效果
              })
              .justifyContent(FlexAlign.SpaceBetween)
              .onClick(() => {
                let uris: Array<string> = [];
                const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
                photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE; // 过滤选择媒体文件类型为IMAGE。
                photoSelectOptions.maxSelectNumber = 1; // 选择媒体文件的最大数目。
                const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
                photoViewPicker.select(photoSelectOptions)
                  .then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
                    uris = photoSelectResult.photoUris;
                    Logger.info(TAG, 'photoViewPicker.select to file succeed and uris are:' + uris);
                    if (uris.length) {
                      this.vm.showPointSubmitConfirm(PointType.PHOTO, uris[0]);
                    }
                  })
                  .catch((err: BusinessError) => {
                    Logger.error(TAG,
                      `Invoke photoViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
                  })
              })
            }.width(Constants.FULL_SIZE).justifyContent(FlexAlign.SpaceBetween).margin({ top: 14 })
          }
          .width(Constants.FULL_SIZE)
          .borderRadius(16)
          .backgroundColor($r('sys.color.background_primary'))
          .padding({
            top: 16,
            bottom: 16,
            left: 18,
            right: 18,
          })
          .alignItems(HorizontalAlign.Start)

          List({ space: 12 }) {
            ForEach(this.menuList, (item: MenuModel) => {
              ListItem() {
                Row() {
                  Row() {
                    Image(item.icon).width(24)
                    Text(item.title)
                      .fontSize(16)
                      .fontColor($r('sys.color.font_primary'))
                      .fontWeight(FontWeight.Medium)
                      .margin({ left: 8 })
                  }

                  Image($r('app.media.ic_right')).width(16).fillColor('#999999')
                }.width(Constants.FULL_SIZE).height(40).justifyContent(FlexAlign.SpaceBetween)
                .onClick(() => {
                  if (item.url) {
                    this.pathStack.pushPathByName(item.url, null);
                  }
                })
              }
            }, (v: MenuModel) => JSON.stringify(v))
          }
          .divider({ strokeWidth: 1, startMargin: 32 })
          .borderRadius(16)
          .padding({
            left: 8,
            right: 8,
            top: 12,
            bottom: 12,
          })
          .backgroundColor($r('sys.color.background_primary'))
        }
        .width(Constants.FULL_SIZE)
        .padding({
          top: 12,
          bottom: 16,
          left: Constants.BORDER_WIDTH,
          right: Constants.BORDER_WIDTH,
        })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
      .edgeEffect(EdgeEffect.Spring)
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
    .onReady((context) => {
      this.pathStack = context.pathStack;
      this.vm.setStack(this.pathStack);
      this.vm.getParam();
    })
  }
}
