module.exports = (ctx, define) ->


  if define.token

    token = ctx.request.token


    { $type } = token

    if define.token[$type] isnt true
      throw "token-type '#{$type}' can't call the io <#{define.name}>,
             ( io-call-chain: -> #{ctx.rubicIOCallChain.join(' -> ')} )."


    # 为防止调用期间过期，仅校验一次有效期
    if ctx.rubicIOCallChain.length is 1

      { $expires } = token

      if $expires < Date.now()
        # @TODO 过期时应该返回相关响应头
        throw "token has expired,
               ( io-call-chain: -> #{ctx.rubicIOCallChain.join(' -> ')} )."