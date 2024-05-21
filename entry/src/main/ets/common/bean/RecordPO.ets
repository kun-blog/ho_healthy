// 记录的数据
// 注意和数据库字段名字不一样，所以还需要定义一个，数据库字段和数据记录数据相对应的类ColumnInfo

export default class RecordPO{
  /**
   * 记录id
   */
  id?: number
  /**
   * 饮食记录类型
   */
  typeId: number
  /**
   * 记录中的食物或运动信息
   */
  itemId: number

  /**
   * 食物数量或运动时长，如果是运动信息则无
   */
  amount: number
  /**
   * 记录的日期
   */
  createTime: number
}