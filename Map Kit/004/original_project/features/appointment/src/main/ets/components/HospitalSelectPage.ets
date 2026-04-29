import { HospitalModel } from '../model/HospitalModel'
import { AppointmentViewModel } from '../viewmodel/AppointmentViewModel'
import { SkeletonTheme, UISkeleton } from 'common'

interface HospitalCardParam {
  picUrl: string,
  name: string
}

/**
 * 医院选择页面
 */
@ComponentV2
export struct HospitalSelectPage {
  @Local appointmentViewModel: AppointmentViewModel = AppointmentViewModel.getInstance(true)

  async aboutToAppear() {
    await this.appointmentViewModel.loadHospitalList()
  }

  build() {
    if (this.appointmentViewModel.isHospitalListLoading) {
      Stack() {
        List({ space: 24 }) {
          ForEach([1, 2, 3], () => {
            ListItem() {
              Row({ space: 16 }) {
                Column() {
                  UISkeleton({ theme: SkeletonTheme.IMAGE, options: [{ width: 54, height: 54 }] })
                }
                .width(54)
                .height(54)

                Column() {
                  UISkeleton({
                    alignRow: FlexAlign.Center,
                    alignCol: FlexAlign.Center,
                    options: [{ width: '100%', height: 20 }, { width: '100%', height: 20 }]
                  })
                }
                .layoutWeight(1)
              }
              .height(54)
              .alignItems(VerticalAlign.Center)
            }
          }, (item: number) => item.toString())
        }
        .width('100%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .alignContent(Alignment.Top)
      .padding(24)
    } else {
      List() {
        ForEach(this.appointmentViewModel.hospitalList, (item: HospitalModel, index: number) => {
          ListItem() {
            this.hospitalCardBuilder({
              picUrl: item.picUrl,
              name: item.name
            })
          }
          .margin({
            left: 16,
            right: 16,
            top: 16
          })
          .onClick(() => {
            this.appointmentViewModel.selectHospital(item)
          })
        }, (item: HospitalModel) => {
          return item.id.toString()
        })
      }
      .width('100%')
      .height('100%')
    }
  }

  @Builder
  hospitalCardBuilder(param: HospitalCardParam) {
    Row({ space: 10 }) {
      Image(param.picUrl)
        .alt($r('app.media.bg_hospital1'))
        .borderRadius(4)
        .width(54)
        .height(54)

      Column({ space: 10 }) {
        Text(param.name)
          .fontSize(14)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontWeight(500)
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .borderRadius(8)
    .backgroundColor($r('sys.color.ohos_id_color_card_bg'))
    .padding({
      left: 17,
      right: 17,
      top: 15,
      bottom: 15
    })
  }
}
