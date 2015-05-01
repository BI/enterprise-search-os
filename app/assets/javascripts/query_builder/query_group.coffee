window.QueryGroup = class QueryGroup extends QueryBase

  # function instead of property because we don't want it to be serialized with the dict
  defaults: ->
    clauseLabel: 'Match ALL'
    clause:      'AND'


  render: ->
    "<span class='query-item group-clause-menu'>#{@clauseLabel}</span>"


  toQuery: ->
    children = queryTree.tree.getNodeByKey(@nodeKey).getChildren()
    return '' unless children?
    childQueries  = []
    $.each children, (i,c) ->
      q = c.data.query.toQuery()
      childQueries.push q unless q == ''
    return '' if childQueries.length == 0
    if @clause == 'NOT'
      notStr = if (@nodeKey == 'query-root') then '* NOT ' else 'NOT '
      "(#{notStr}(" + childQueries.join(" OR ") + '))'
    else
      '(' + childQueries.join(" #{@clause} ") + ')'




