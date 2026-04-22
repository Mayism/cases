import { UtilLog } from '@hw-agconnect/util-log';
import { advertising, AutoAdComponent } from '@kit.AdsKit';

const TAG = 'AdvertisementComponent';

@ComponentV2
export struct AdvertisementComponent {
  @Param adId: string = 'testw6vs28auh3';
  @Param adVisibilityState: Visibility = Visibility.None;
  @Event changeAdShow: (state: Visibility) => void;
  // 广告请求参数
  private adRequestParams: advertising.AdRequestParams = {
    // todo 'testw6vs28auh3'为测试专用的广告位ID，App正式发布时需要改为正式的广告位ID
    adId: 'testw6vs28auh3',
    // 横幅广告类型
    adType: 8,
    // 广告位宽
    adWidth: 360,
    // 广告位高
    adHeight: 144,
  };
  // 广告配置参数
  private adOptions: advertising.AdOptions = {
    // 是否允许流量下载 0：不允许，1：允许，不设置以广告主设置为准
    allowMobileTraffic: 0,
    // 是否希望根据 COPPA 的规定将您的内容视为面向儿童的内容: -1: 默认值，不确定 0: 不希望 1: 希望
    tagForChildProtection: -1,
    // 是否希望按适合未达到法定承诺年龄的欧洲经济区 (EEA) 用户的方式处理该广告请求 -1: 默认值，不确定 0: 不希望 1: 希望
    tagForUnderAgeOfPromise: -1,
    // 设置广告内容分级上限 W: 3+,所有受众 PI: 7+,家长指导 J: 12+,青少年 A: 16+/18+,成人受众
    adContentClassification: 'A',
  };
  // 广告展示参数，默认为全屏广告视频参数
  private adDisplayOptions: advertising.AdDisplayOptions = {
    // 广告轮播的时间间隔，单位ms，取值范围[30000, 120000]
    refreshTime: 30000,
  };
  // 横幅广告的宽高比
  private ratio: number = 1;

  aboutToAppear() {
    this.adRequestParams.adId = this.adId;
    if (this.adRequestParams.adWidth && this.adRequestParams.adHeight) {
      this.ratio = 16 / 9;
    }
  }

  build() {
    Row() {
      AutoAdComponent({
        adParam: this.adRequestParams,
        adOptions: this.adOptions,
        displayOptions: this.adDisplayOptions,
        interactionListener: {
          onStatusChanged: (status: string, ad: advertising.Advertisement, data: string) => {
            switch (status) {
              case AdStatus.AD_OPEN:
                UtilLog.info(TAG, `Status is onAdOpen${JSON.stringify(ad)},data:${data}`);
                break;
              case AdStatus.AD_CLICKED:
                UtilLog.info(TAG, 'Status is onAdClick');
                break;
              case AdStatus.AD_CLOSED:
                UtilLog.info(TAG, 'Status is onAdClose');
                this.changeAdShow(Visibility.None);
                break;
              case AdStatus.AD_LOAD:
                UtilLog.info(TAG, 'Status is onAdLoad');
                break;
              case AdStatus.AD_FAIL:
                UtilLog.error(TAG, 'Status is onAdFail');
                this.changeAdShow(Visibility.None);
                break;
            }
          },
        },
      })
    }
    .borderRadius(20)
    .clip(true)
    .width('100%')
    .aspectRatio(this.ratio)
  }
}

// 广告状态变化的枚举值
enum AdStatus {
  AD_OPEN = 'onAdOpen',
  AD_CLICKED = 'onAdClick',
  AD_CLOSED = 'onAdClose',
  AD_LOAD = 'onAdLoad',
  AD_FAIL = 'onAdFail'
}