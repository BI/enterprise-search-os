window.QueryBase = class QueryBase

  constructor: (node) ->
    @nodeKey = node.data.key
    obj      = $.extend {}, @defaults(), node.data.query
    $.each obj, (k,v) => @[k] = v
