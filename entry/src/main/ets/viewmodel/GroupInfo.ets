import ItemCategory from './ItemCategory'
import RecordItem from './RecordItem'

// 我们分组，可能是食物，也可能是运动，所以用泛型
export default class GroupInfo<TYPE, ELEMENT> {
  /**
   * 分组类型（食物类型或运动类型）
   */
  type: TYPE
  /**
   * 组内数据集合（食物或运动）
   */
  items: ELEMENT[]

  /**
   * 组内记录的总热量
   */
  calorie: number = 0


  constructor(type: TYPE, items: ELEMENT[]) {
    this.type = type
    this.items = items
  }
}