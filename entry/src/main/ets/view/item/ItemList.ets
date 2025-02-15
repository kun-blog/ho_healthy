// src/main/ets/view/item/ItemList.ets

import { CommonConstants } from '../../common/constants/CommonConstants'
import DateUtil from '../../common/utils/DateUtil'
import ItemModel from '../../model/ItemModel'
import RecordService from '../../service/RecordService'
import GroupInfo from '../../viewmodel/GroupInfo'
import ItemCategory from '../../viewmodel/ItemCategory'
import RecordItem from '../../viewmodel/RecordItem'
import RecordVO from '../../viewmodel/RecordVO'
@Component
export default struct ItemList {
  @StorageProp('selectedDate')
  // 监控日期变更，触发aboutToAppear函数
  // 在StatsCard组件里，已经存了日期，直接取出来用
  @Watch('aboutToAppear')  selectedDate: number = DateUtil.beginTimeOfDay(new Date())

  @Provide records: RecordVO[] = []

  // 接收父组件传递过来的函数
  showPanel: (item: RecordItem) => void
  @State isFood: boolean = false

  async aboutToAppear(){
    this.records = await RecordService.queryRecordByDate(this.selectedDate)
  }

  build() {
    Tabs() {
      TabContent() {
        this.TabContentBuilder(ItemModel.list(this.isFood))
      }
      .tabBar('全部')
      ForEach(
        ItemModel.listItemGroupByCategory(this.isFood),
           (group: GroupInfo<ItemCategory, RecordItem>) => {
             TabContent() {
               this.TabContentBuilder(group.items)
             }
             .tabBar(group.type.name)
           })
    }
    .width(CommonConstants.THOUSANDTH_940)
    .height('100%')
    .barMode(BarMode.Scrollable)
  }

  @Builder TabContentBuilder(items: RecordItem[]) {
    List({space: CommonConstants.SPACE_10}){
      ForEach(items, (item: RecordItem) => {
        ListItem(){
          Row({space: CommonConstants.SPACE_6}){
            Image(item.image).width(50)
            Column({space: CommonConstants.SPACE_4}){
              Text(item.name).fontWeight(CommonConstants.FONT_WEIGHT_500)
              Text(`${item.calorie}千卡/${item.unit}`).fontSize(14).fontColor($r('app.color.light_gray'))
            }
            Blank()
            Image($r('app.media.ic_public_add_norm_filled'))
              .width(18)
              .fillColor($r('app.color.primary_color'))
          }
          .width('100%')
          .padding(CommonConstants.SPACE_6)
        }
        .onClick(() => this.showPanel(item))
      })
    }
    .width('100%')
    .height('100%')
  }
}