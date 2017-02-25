_ = require('lodash')



class SchemaFormater



###
  例子，
  格式化前：
    schema = {
      a:
        $type: String
      b:
        c:
          $type: Number
          $default: 1
      d: [{
        e:
          f:
            $type: String
          g: [{
            $type: String
          }]
      }]
    }
  格式化后：
    schema = {
      'a':
        $type: String
      'b.c':
        $type: Number
        $default: 1
      'd':
        $type: Array
        $schema:
          'e.f':
            $type: String
          'e.g':
            $type: Array
            $schema:
              $type: String
    }
###



###
@PUBLIC
###
SchemaFormater.formatLinear = (schema={}) ->
  newSchema = {}
  cursor = []
  @traversal(schema, newSchema, cursor)
  return newSchema



# 深度优先遍历，逐步填充newSchema
# cursor是记录路径轨迹的栈，类似['a', 'b']，
# 进入下一层压栈，返回上一层弹栈
SchemaFormater.traversal = (node, newSchema, cursor) ->
  # 规则集节点，录入到newSchema
  if node.$type
    newSchema[cursor.join('.')] = node
  else
    # 普通的嵌套节点，继续向下遍历
    if _.isPlainObject(node)
      for name, child of node
        cursor.push(name)
        @traversal(child, newSchema, cursor)
    # 数组节点，录入子模式(node[0])到newSchema
    if Array.isArray(node)
      newSchema[cursor.join('.')] =
        $type: Array
        $schema: if node[0].$type then node[0] else @formatLinear(node[0])
  # 无论是哪种节点，处理完毕后都要返回上一层
  cursor.pop()



SchemaFormater.formatLogogram = (node) ->
  if _.isPlainObject(node)
    for name, child of node
      if name[0] is '$'
        continue
      node[name] = @formatLogogramEach(child)
  else if Array.isArray(node)
    node[0] = @formatLogogramEach(node[0])
  return node



SchemaFormater.formatLogogramEach = (value) ->
  if [Boolean, Number, String, Buffer, Date].includes(value)
    return {$type: value}
  else if typeof(value) is 'string'
    return {$ref: value}
  else
    return @formatLogogram(value)



module.exports = SchemaFormater