import common from '@ohos.app.ability.common';
import relationalStore from '@ohos.data.relationalStore';
import { ColumnInfo, ColumnType } from '../bean/ColumnInfo';
import Logger from './Logger';

const DB_FILENAME: string = 'HealthyApp.db'

class DbUtil {
  rdbStore: relationalStore.RdbStore

  initDB(context: common.UIAbilityContext): Promise<void> {
    let config: relationalStore.StoreConfig = {
      name: DB_FILENAME,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    return new Promise<void>((resolve, reject) => {
      relationalStore.getRdbStore(context, config)
        .then(rdbStore => {
          this.rdbStore = rdbStore
          Logger.debug('rdbStore 初始化完成！')
          resolve()
        })
        .catch(reason => {
          Logger.debug('rdbStore 初始化异常', JSON.stringify(reason))
          reject(reason)
        })
    })
  }

  createTable(createSQL: string): Promise<void> {
    return new Promise((resolve, reject) => {
      this.rdbStore.executeSql(createSQL)
        .then(() => {
          Logger.debug('创建表成功', createSQL)
          resolve()
        })
        .catch(err => {
          Logger.error('创建表失败,' + err.message, JSON.stringify(err))
          reject(err)
        })
    })
  }
  // obj是匿名对象{id: 12, name:zs,age: 18}
  insert(tableName: string, obj: any, columns: ColumnInfo[]): Promise<number> {
    return new Promise((resolve, reject) => {
      // 1.构建新增数据
      let value = this.buildValueBucket(obj, columns)
        this.rdbStore.insert(tableName, value, (err, id) => {
           if (err) {
             Logger.error('新增失败！', JSON.stringify(err))
             reject(err)
           }else {
             Logger.debug('新增成功！新增id：', id.toString())
             resolve(id)
           }
        })
    })
  }

  delete(predicates: relationalStore.RdbPredicates): Promise<number> {
    return new Promise((resolve, reject) => {
       this.rdbStore.delete(predicates, (err, rows) => {
         if (err) {
           Logger.error('删除失败！', JSON.stringify(err))
           reject(err)
         } else {
           Logger.debug('删除成功！删除行数：', rows.toString())
           resolve(rows)
         }
       })
    })
  }

  // columns 把你要查询的字段告诉我
  // 以后调用的时候知道类型
  queryForList<T>(predicates: relationalStore.RdbPredicates, columns: ColumnInfo[]): Promise<T[]> {
    return new Promise((resolve, reject) => {
      this.rdbStore.query(predicates, columns.map(info => info.columnName), (err, result) => {  // map将对象里的属性映射成数组
        if (err) {
          Logger.error('查询失败！', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('查询成功！查询行数：', result.rowCount.toString())
          resolve(this.parseResultSet(result, columns))   // 由于查询结果是一个ResultSet，我们解析成数组，以后调用的时候方便
        }
      })
    })
  }

  // 解析函数
  parseResultSet<T>(result: relationalStore.ResultSet, columns: ColumnInfo[]){
    // 1.声明最终返回的结果
    let arr = []
    if (result.rowCount <= 0) {
      return arr
    }
    // 3.处理结果
    while (!result.isAtLastRow) {
      // 3.1.去下一行
      result.goToNextRow()
      // 3.2.解析这行数据，转为对象
      let obj = {}
      columns.forEach(info => {
        let val = null
         switch (info.type) {  // 判断类型
           case ColumnType.LONG:  // 如果是LONG
             val = result.getLong(result.getColumnIndex(info.columnName))
             break
           case ColumnType.DOUBLE: // 如果是DOUBLE
             val = result.getDouble(result.getColumnIndex(info.columnName))
             break
           case ColumnType.STRING:  // 如果是STRING
             val = result.getString(result.getColumnIndex(info.columnName))
             break
           case ColumnType.BLOB:  // 如果是BLOB
             val = result.getBlob(result.getColumnIndex(info.columnName))
             break
         }
        obj[info.name] = val
      })
      // 3.3.将对象填入结果数组
      arr.push(obj)
      Logger.debug('查询到数据：', JSON.stringify(obj))
    }
    return arr
  }

  buildValueBucket(obj: any, columns: ColumnInfo[]): relationalStore.ValuesBucket{
    let value = {}
    columns.forEach(info => {
      let val = obj[info.name]
      if (typeof val !== 'undefined') {
        value[info.columnName] = val  // 数据库的字段名和我们添加时候写的属性名称对应起来
      }
    })
    return value
  }
}

let dbUtil: DbUtil = new DbUtil();

export default dbUtil as DbUtil