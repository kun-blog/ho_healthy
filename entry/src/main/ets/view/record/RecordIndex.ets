// src/main/ets/view/record/RecordIndex.ets
import RecordList from './RecordList'
import SearchHeader from './SearchHeader'
import StatsCard from './StatsCard'

@Component
export default struct RecordIndex {

  // 监听状态变化，触发组件加载
  @Prop @Watch('handlePageShow') isPageShow: boolean

  handlePageShow(){
    if(this.isPageShow){
      this.aboutToAppear()
    }
  }
  build() {
    Column(){
      // 1.头部搜索栏
      SearchHeader()
      // 2.统计卡片
      StatsCard()
      // 3.记录列表
      RecordList()
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.index_page_background'))
  }
}