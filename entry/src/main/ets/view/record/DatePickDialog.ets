// src/main/ets/view/record/DatePickDialog.ets

import { CommonConstants } from '../../common/constants/CommonConstants'

// 定义日期弹窗
@CustomDialog
export default struct DatePickDialog {
  controller: CustomDialogController
  selectedDate: Date = new Date()
  build() {
    Column({space: CommonConstants.SPACE_12}){
      // 1.日期选择器，DatePicker官方组件
      DatePicker({
        start: new Date('2020-01-01'),
        end: new Date(),
        selected: this.selectedDate
      })
        .onChange((value: DatePickerResult) => {
          // 注意这里，选择的结果是年月日，没有时分秒，默认是当日的0时，0分，0秒
          this.selectedDate.setFullYear(value.year, value.month, value.day)
        })

      // 2.按钮
      Row({space:CommonConstants.SPACE_12}){
        Button('取消')
          .width(120)
          .backgroundColor($r('app.color.light_gray'))
          .onClick(() => {
            this.controller.close()
          })

        Button('确定')
          .width(120)
          .backgroundColor($r('app.color.primary_color'))
          .onClick(()=> {
            // 1.保存日期到全局存储
            // AppStorage是一个全局的存储空间，getTime（）获取的是日期毫秒数，以为存一个日期对象，会不好处理
            AppStorage.SetOrCreate('selectedDate', this.selectedDate.getTime())
            // 2.关闭窗口
            this.controller.close()
          })

      }

    }
    .padding(CommonConstants.SPACE_12)
  }
}