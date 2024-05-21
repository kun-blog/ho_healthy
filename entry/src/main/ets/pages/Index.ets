// src/main/ets/pages/Index.ets
import BreakpointType from '../common/bean/BreanpointType'
import BreakpointConstants from '../common/constants/BreakpointConstants'
import { CommonConstants } from '../common/constants/CommonConstants'
import BreakpointSystem from '../common/utils/BreakpointSystem'
import RecordIndex from '../view/record/RecordIndex'


@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  private breakpointSystem: BreakpointSystem = new BreakpointSystem()
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM

  @State isPageShow: boolean = false

  // 由于RecordIndex是组件，每次页面变化无法触发重新查询，所以我们在首页监听变化，改变状态，传给子组件
  onPageShow(){
    this.isPageShow = true
  }
  onPageHide(){
    this.isPageShow = false
  }

  // 定义一个构建函数，自定义tabar
  @Builder TabBarBuilder(title:ResourceStr, image: ResourceStr, index: number){
    Column({ space: CommonConstants.SPACE_8 }) {
      Image(image)
        .width(22)
        .fillColor(this.selectColor(index))
      Text(title)
        .fontSize(14)
        .fontColor(this.selectColor(index))
    }
  }

  // 选中颜色，根据来显示颜色，选中绿色，未选中灰色
  selectColor(index: number){
    return this.currentIndex === index ? $r('app.color.primary_color') : $r('app.color.gray')
  }

  aboutToAppear(){
    // 开启媒体查询监听函数
    this.breakpointSystem.register()
  }

  aboutToDisappear(){
    // 关闭媒体查询监听函数
    this.breakpointSystem.unregister()
  }

  build() {
    Tabs({ barPosition: BreakpointConstants.BAR_POSITION.getValue(this.currentBreakpoint) }){
      TabContent(){
        RecordIndex({isPageShow: this.isPageShow})
      }
      .tabBar(this.TabBarBuilder($r('app.string.tab_record'), $r('app.media.ic_calendar'), 0))

      TabContent(){
        Text('发现页面')
      }
      .tabBar(this.TabBarBuilder($r('app.string.tab_discover'), $r('app.media.discover'), 1))

      TabContent(){
        Text('我的主页')
      }
      .tabBar(this.TabBarBuilder($r('app.string.tab_user'), $r('app.media.ic_user_portrait'), 2))
    }
    .width('100%')
    .height('100%')
    .onChange(index => this.currentIndex = index)
    .vertical(new BreakpointType({
      sm: false,
      md: true,
      lg: true
    }).getValue(this.currentBreakpoint))
  }
}