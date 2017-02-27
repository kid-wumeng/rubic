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



exports.VALUE_CHECK_FAILED_MIMES = class extends Error
  constructor: ({key, value, mimes}) ->
    super()
    @message = "数据校验失败：属性#{key}的MIME类型限制为：#{mimes.join(', ')}"



exports.VALUE_CHECK_FAILED_CUSTOM = class extends Error
  constructor: ({key, value, mimes}) ->
    super()
    @message = "数据校验失败：未通过开发者的自定义检查"



exports.TOKEN_SECRET_NOT_FOUND = class extends Error
  constructor: () ->
    super()
    @message = "令牌系统异常"



exports.TOKEN_TYPE_NOT_FOUND = class extends Error
  constructor: ({type}) ->
    super()
    @message = "找不到这种类型的令牌：#{type}"



exports.TOKEN_CHECK_FAILED_REQUIRE = class extends Error
  constructor: () ->
    super()
    @message = "令牌校验失败：缺少必要的令牌"



exports.TOKEN_CHECK_FAILED_TYPE = class extends Error
  constructor: () ->
    super()
    @message = "令牌校验失败：类型不匹配"



exports.TOKEN_CHECK_FAILED_EXPIRES = class extends Error
  constructor: () ->
    super()
    @message = "令牌校验失败：已过期，请重新登录"