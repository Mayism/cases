import { AppStorageV2 } from '@kit.ArkUI';
import { AppInfoModel, RouterMap, RouterModule } from 'common/Index';
import { hilog } from '@kit.PerformanceAnalysisKit';

@ComponentV2
export struct HomeHeaderComp {
  @Param breakpoint: string = ''
  @Local appInfoModel: AppInfoModel = AppStorageV2.connect(AppInfoModel, () => new AppInfoModel())!;

  build() {
    Row() {
      Button() {
        Stack() {
          SymbolGlyph($r('sys.symbol.local'))
            .fontSize(24)
            .fontColor([$r('sys.color.icon_primary'), '#000000'])
          Text(this.appInfoModel.localCity || '无法获取')
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .margin({ left: 32 })
        }.alignContent(Alignment.Start)
      }
      .height(40)
      .constraintSize({ maxWidth: this.breakpoint === 'sm' ? 128 : '80%' })
      .padding({
        left: 16,
        top: 8,
        right: 16,
        bottom: 8,
      })
      .margin({ left: 16 })
      .borderRadius(20)
      .backgroundColor($r('sys.color.background_primary'))
      .onClick(() => {
        RouterModule.push<string>(RouterMap.CITY_SELECT_PAGE)
      });
    }.height(56).constraintSize({ maxWidth: this.breakpoint === 'sm' ? 192 : '80%' })
  }
}
