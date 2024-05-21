// src/main/ets/view/record/StatsCard.ets

import DateUtil from '../../common/utils/DateUtil'
import DatePickDialog from './DatePickDialog'
import { CommonConstants } from '../../common/constants/CommonConstants'
import CalorieStats from './CalorieStats'
import NutrientStats from './NutrientStats'
import RecordVO from '../../viewmodel/RecordVO'
import RecordService from '../../service/RecordService'
import StatsInfo from '../../viewmodel/StatsInfo'

@Component
export default struct StatsCard {
  // 把selectedDate从AppStorage里出去来，这里需要用到 @StorageProp这个注解，同时我们要对取出来的日期处理，因为我们存的是日期毫秒数,这里自己写了个工具类
  @StorageProp('selectedDate') selectedDate: number = DateUtil.beginTimeOfDay(new Date())
  @Consume @Watch('handleRecordsChange') records: RecordVO[]  // 拿到父组件传的数据
  @State info: StatsInfo = new StatsInfo()

  handleRecordsChange(){
    this.info = RecordService.calculateStatsInfo(this.records)
  }

  // 使用自定义弹窗
  controller: CustomDialogController = new CustomDialogController({
    builder: DatePickDialog({selectedDate: new Date(this.selectedDate)})
  })
  build(){
    Column(){
      // 1.日期信息
      Row(){
        Text(DateUtil.formatDate(this.selectedDate))
          .fontColor($r('app.color.secondary_color'))
        Image($r('app.media.ic_public_spinner'))
          .width(20)
          .fillColor($r('app.color.secondary_color'))
      }
      .padding(CommonConstants.SPACE_8)
      .onClick(() => this.controller.open())  // 打开弹窗

      // 2.统计信息
      Swiper(){
        // 2.1.热量统计
        CalorieStats({intake: this.info.intake, expend: this.info.expend})
        // 2.2.营养素统计
        NutrientStats({carbon: this.info.carbon, protein: this.info.protein, fat: this.info.fat})
      }
    }
  }
}