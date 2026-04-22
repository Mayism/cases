import { CourseDetailModel } from 'external_interactions'

@ComponentV2
export struct CourseContent{
  @Param courseList : CourseDetailModel[] = []
  @Param @Once onBackClick : (msg : string) => void = () => {};
  @Builder
  courseBuilder(){
    Grid() {
      ForEach(this.courseList, (item: CourseDetailModel) => {
        GridItem() {
          CourseGrid({courseDetail : item, onBackClick:(id : string)=>{
            this.onBackClick && this.onBackClick(id)
          }})
        }
      }, (item: CourseDetailModel) => JSON.stringify(item))
    }
    .width('100%')
    .columnsTemplate('1fr 1fr')
    .columnsGap(8)
    .rowsGap(8)
  }
  build() {
    Column(){
      Row(){
        this.courseBuilder()
      }
    }
  }
}

@ComponentV2
export struct CourseGrid{
  @Param courseDetail: CourseDetailModel | undefined = undefined;
  @Param @Once onBackClick : (msg : string) => void = () => {};
  build() {
    if(this.courseDetail){
      Column() {
        Image($r(this.courseDetail.advImage))
          .width('100%')
          .height('70%')
          .borderRadius({ topLeft: 8, topRight: 8 })
          .aspectRatio(16 / 9)
        Column() {
          Text(this.courseDetail.courseName)
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom:4 })
          Text('¥' + this.courseDetail.price)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .alignItems(HorizontalAlign.Start)
        .shadow({
          radius: 2,
          color:'#ECECEC',
          offsetY: 5,
        })
        .width('100%')
        .backgroundColor('#fff')
        .padding({left: 8, top: 12, right: 8, bottom: 12})
        .borderRadius({bottomLeft: 8, bottomRight: 8})
      }
      .width('100%')
      .borderRadius({ topLeft: 8, topRight: 8 })
      .onClick(() => {
        if(this.courseDetail){
          this.onBackClick && this.onBackClick(this.courseDetail.id)
        }
      })
    }
  }
}