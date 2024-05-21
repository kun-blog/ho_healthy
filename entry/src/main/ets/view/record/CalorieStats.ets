// src/main/ets/view/record/CalorieStats.ets
import { CommonConstants } from '../../common/constants/CommonConstants'
@Component
export default struct CalorieStats {
  // 饮食摄入
  @Prop intake: number
  // 消耗
  @Prop expend: number
  //推荐的
  recommend: number = CommonConstants.RECOMMEND_CALORIE

  // 计算还可以吃的量
  remainCalorie(){
    return this.recommend - this.intake + this.expend
  }
  build() {
    Row({space: CommonConstants.SPACE_6}){
      // 1.饮食摄入
      this.StatsBuilder({label: '饮食摄入', value: this.intake})
      // 2.还可以吃
      Stack(){ // 堆叠容器
        // 2.1.进度条
        Progress({
          value: this.intake,
          total: this.recommend,
          type: ProgressType.Ring
        })
          .width(120)
          .style({strokeWidth: CommonConstants.DEFAULT_10})  // 进度条加粗
          .color($r('app.color.primary_color'))
        // 2.2.统计数据
        this.StatsBuilder({label: '还可以吃', value: this.remainCalorie(),tips: `推荐${this.recommend}`})
      }
      // 3.运动消耗
      this.StatsBuilder({label: '运动消耗', value: this.expend})
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
    .padding({top: 30, bottom: 35})
  }

  // 注意，给Builder函数，传递参数的时候，传引用值，否者状态变化，无法触发视图重新渲染，写法是两个$$符号
  @Builder StatsBuilder($$:{label: string, value: number, tips?: string}){
    Column({space: CommonConstants.SPACE_6}){
      Text($$.label)
        .fontColor($r('app.color.gray'))
        .fontWeight(CommonConstants.FONT_WEIGHT_600)
      Text($$.value.toFixed(0))
        .fontSize(20)
        .fontWeight(CommonConstants.FONT_WEIGHT_700)
      if($$.tips){
        Text($$.tips)
          .fontSize(12)
          .fontColor($r('app.color.light_gray'))
      }
    }
  }
}