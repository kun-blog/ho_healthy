// src/main/ets/view/record/RecordList.ets
import router from '@ohos.router'

import { CommonConstants } from '../../common/constants/CommonConstants'
import RecordService from '../../service/RecordService'
import GroupInfo from '../../viewmodel/GroupInfo'
import RecordType from '../../viewmodel/RecordType'
import RecordVO from '../../viewmodel/RecordVO'

@Extend(Text) function grayText() {
  .fontSize(14)
  .fontColor($r('app.color.light_gray'))
}

@Component
export default struct RecordList {
  // 拿到父组件传来的数据，并监听数据是否变化，变化触发handleRecordsChange函数
  @Consume @Watch('handleRecordsChange') records: RecordVO[]

  @State groups: GroupInfo<RecordType, RecordVO>[] = []

  handleRecordsChange(){
    this.groups = RecordService.calculateGroupInfo(this.records)
  }



  build() {
 List({space: CommonConstants.SPACE_10}){
   ForEach(this.groups, (group: GroupInfo<RecordType, RecordVO>) => {
     ListItem() {
       Column({ space: CommonConstants.SPACE_8 }) {
         // 1.分组的标题
         Row({space: CommonConstants.SPACE_4}){
           Image($r('app.media.ic_breakfast')).width(24)
           Text(group.type.name).fontSize(18).fontWeight(CommonConstants.FONT_WEIGHT_700)
           Text(`建议${group.type.min}~${group.type.max}千卡`).grayText()
           Blank()
           Text(group.calorie.toFixed(0)).fontSize(14).fontColor($r('app.color.primary_color'))
           Text('千卡').grayText()
           Image($r('app.media.ic_public_add_norm_filled'))
             .width(20)
             .fillColor($r('app.color.primary_color'))
         }
         .width('100%')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/ItemIndex',
              params: {type: group.type}
            })
          })
         // 2.组内记录列表
         List(){
           ForEach([1,2], (item) => {
             ListItem(){
               Row({space: CommonConstants.SPACE_6}){
                 Image($r('app.media.toast')).width(50)
                 Column({space: CommonConstants.SPACE_4}){
                   Text('全麦土司').fontWeight(CommonConstants.FONT_WEIGHT_500)
                   Text(`1片`).grayText()
                 }
                 Blank()
                 Text('91千卡').grayText()
               }
               .width('100%')
               .padding(CommonConstants.SPACE_6)
             }.swipeAction({end: this.deleteButton.bind(this)})
           })
         }
         .width('100%')
       }
       .width('100%')
       .backgroundColor(Color.White)
       .borderRadius(CommonConstants.DEFAULT_18)
       .padding(CommonConstants.SPACE_12)
     }
   })
  }
 .width(CommonConstants.THOUSANDTH_940)
 .height('100%')
 .margin({top: 10})
  }

  @Builder deleteButton() {
    Image($r('app.media.ic_public_delete_filled'))
      .width(20)
      .height(20)
      .fillColor(Color.Red)
      .margin(5)
  }
}


