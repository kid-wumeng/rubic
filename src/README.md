# 规则

## 通用属性

* ``countString`` 计算字符串长度的模式，可选``width``（默认）与``length``，也可以设为一个自定义计数函数

## Model专用属性

* ``private`` 除非显式设置fields，否则无法读取本字段

## 内部属性

* ``key`` 相对键名，比如``content``
* ``keyAbs`` 绝对键名，比如``comment.replies.content``