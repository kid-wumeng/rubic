deepKeys = require('deep-keys')



class ValueExistError extends Error
  constructor: ({@key}) ->
    @message = "缺少必要属性"



class ValueTypeError extends Error
  constructor: ({@key, @value, @expectType}) ->
    @message = "属性不是预期类型"



class ValueEnumsError extends Error
  constructor: ({@key, @value, @enums}) ->
    @message = "属性不在枚举范围中"



class ValueMinError extends Error
  constructor: ({@key, @value, @min}) ->
    @message = "属性值太小"



class ValueMaxError extends Error
  constructor: ({@key, @value, @max}) ->
    @message = "属性值太大"



class NeedlessDataError extends Error
  constructor: ({@data}) ->
    @message = "数据中包含多余的属性：#{deepKeys(@data).join(', ')}"



module.exports = {
  ValueExistError
  ValueTypeError
  ValueEnumsError
  ValueMinError
  ValueMaxError
  NeedlessDataError
}