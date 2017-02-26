exports.IO_NOT_FOUND = class extends Error
  constructor: ({ioName}) ->
    super()
    @message = "找不到io：#{ioName}"



exports.VALUE_CHECK_FAILED_REQUIRE = class extends Error
  constructor: ({key}) ->
    super()
    @message = "数据校验失败：缺少必要的属性#{key}"



exports.VALUE_CHECK_FAILED_TYPE_BOOLEAN = class extends Error
  constructor: ({key}) ->
    super()
    @message = "数据校验失败：属性#{key}的类型应该是Boolean"



exports.VALUE_CHECK_FAILED_TYPE_NUMBAR = class extends Error
  constructor: ({key}) ->
    super()
    @message = "数据校验失败：属性#{key}的类型应该是Number"



exports.VALUE_CHECK_FAILED_TYPE_STRING = class extends Error
  constructor: ({key}) ->
    super()
    @message = "数据校验失败：属性#{key}的类型应该是String"



exports.VALUE_CHECK_FAILED_TYPE_BUFFER = class extends Error
  constructor: ({key}) ->
    super()
    @message = "数据校验失败：属性#{key}的类型应该是Buffer（二进制数据）"



exports.VALUE_CHECK_FAILED_TYPE_DATE = class extends Error
  constructor: ({key}) ->
    super()
    @message = "数据校验失败：属性#{key}的类型应该是Date（时间戳）"



exports.VALUE_CHECK_FAILED_ENUMS = class extends Error
  constructor: ({key, enums}) ->
    super()
    @message = "数据校验失败：属性#{key}不在枚举范围（#{enums.join(', ')}）中"



exports.VALUE_CHECK_FAILED_MIN_NUMBAR = class extends Error
  constructor: ({key, value, min}) ->
    super()
    @message = "数据校验失败：属性#{key}太小，当前#{value}，不应该小于#{min}"



exports.VALUE_CHECK_FAILED_MIN_STRING = class extends Error
  constructor: ({key, value, min}) ->
    super()
    @message = "数据校验失败：属性#{key}字太少，不应该少于#{min}个字"



exports.VALUE_CHECK_FAILED_MIN_BUFFER = class extends Error
  constructor: ({key, value, min}) ->
    super()
    @message = "数据校验失败：属性#{key}太小，不应该小于#{min}个字节"



exports.VALUE_CHECK_FAILED_MAX_NUMBAR = class extends Error
  constructor: ({key, value, min}) ->
    super()
    @message = "数据校验失败：属性#{key}太大，当前#{value}，不应该大于#{min}"



exports.VALUE_CHECK_FAILED_MAX_STRING = class extends Error
  constructor: ({key, value, min}) ->
    super()
    @message = "数据校验失败：属性#{key}字太多，不应该多于#{min}个字"



exports.VALUE_CHECK_FAILED_MAX_BUFFER = class extends Error
  constructor: ({key, value, min}) ->
    super()
    @message = "数据校验失败：属性#{key}太大，不应该大于#{min}个字节"