import { AppStorageV2 } from '@kit.ArkUI';
import { Constants, FormCardJump, RouterUtil, TabBarType, Logger } from 'lib_common';
import { MinePageBuilder } from 'business_mine';
import { HomePageBuilder } from './HomePage';
import { CustomTabBar } from '../components/CustomTabBar';

const TAG: string = '[IndexPage]';

@Builder
export function IndexPageBuilder() {
  IndexPage()
}

@ComponentV2
struct IndexPage {
  @Provider('currentIndex') currentIndex: TabBarType = TabBarType.HOME_PAGE;
  @Local formCardJump: FormCardJump = AppStorageV2.connect(FormCardJump, () => new FormCardJump())!;

  @Monitor('formCardJump.form.id','formCardJump.form.url')
  formChange(monitor: IMonitor) {
    Logger.info(TAG, 'Monitor formCardJump.form.url:' + monitor.value('formCardJump.form.url')?.now)
    if (monitor.value('formCardJump.form.url')?.now) {
      RouterUtil.pushPathByName(monitor.value('formCardJump.form.url')?.now as string)
      this.formCardJump.form.url = ''
    }
  }

  aboutToAppear(): void {
    if (this.formCardJump.form.url) {
      RouterUtil.pushPathByName(this.formCardJump.form.url)
    }
  }

  build() {
    NavDestination() {
      Stack() {
        Flex({
          direction: FlexDirection.Column,
        }) {
          Tabs({ index: this.currentIndex }) {
            TabContent() {
              wrapBuilder(HomePageBuilder).builder()
            }

            TabContent() {
            }

            TabContent() {
              wrapBuilder(MinePageBuilder).builder()
            }
          }
          .layoutWeight(1)
          .barHeight(0)
          .scrollable(false)
          .onChange((index) => {
            this.currentIndex = index;
          })

          CustomTabBar()
        }
        .width(Constants.FULL_SIZE)
        .height(Constants.FULL_SIZE);
      };
    }.hideTitleBar(true)
  }
}