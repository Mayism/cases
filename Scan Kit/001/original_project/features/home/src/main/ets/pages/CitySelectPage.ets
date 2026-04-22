import { CitySearchController, UICitySelect } from 'module_city_select';
import { AppInfoModel, RouterModule, WindowModel } from 'common/Index';
import { AppStorageV2 } from '@kit.ArkUI';
import { UtilLog } from '@hw-agconnect/util-log';

@Builder
export function CitySelectPageBuilder() {
  CitySelectPage()
}

@ComponentV2
struct CitySelectPage {
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!
  @Local appInfoModel: AppInfoModel = AppStorageV2.connect(AppInfoModel, () => new AppInfoModel())!;
  controller: CitySearchController = new CitySearchController();

  onBackPress(): boolean | void {
    return this.controller.onBackPressed();
  }

  aboutToAppear(): void {
    UtilLog.info(`CitySelectPage.`);
  }

  build() {
    NavDestination() {
      Column() {
        UICitySelect({
          currentCity: this.appInfoModel.localCity,
          controller: this.controller,
          emitUpdateCityLocation: (city: string) => {
            this.appInfoModel.localCity = city;
          },
          goBack: (citySelected?: string) => {
            if (citySelected) {
              this.appInfoModel.localCity = citySelected
              RouterModule.pop()
            }
          },
        })
      }
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .padding({ top: this.windowModel.getWindowTopHeight(), bottom: this.windowModel.getWindowBottomHeight() })
    .title('城市选择')
  }
}
