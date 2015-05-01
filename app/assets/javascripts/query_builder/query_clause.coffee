window.QueryClause = class QueryClause extends QueryBase

  # function instead of property because we don't want it to be serialized with the dict
  defaults: ->
    fieldLabel:  'ANY Field'
    field:       '_all'
    clauseLabel: 'contains ANY'
    clause:      'OR'
    terms:       []


  render: ->
    "<div class='clause-container'><span class='query-item item-field-menu'>#{@fieldLabel}</span>
     <span class='query-item item-clause-menu'>#{@clauseLabel}</span>
     <textarea class='clause-input' rows='1'></textarea></div>"


  toQuery: ->
    return '' if @terms.length == 0
    fragment = switch true
                 when @clause == 'LESS'
                   '[* TO ' + @quotedTerms()[0] + ']'
                 when @clause == 'GREATER'
                   '[' + @quotedTerms()[0] + ' TO *]'
                 when @clause == 'RANGE'
                   '[' + @quotedTerms().join(' TO ') + ']' if @terms.length == 2
                 when /^\d+/.test(@clause)
                   '"' + @terms.join(' ') + '"~' + @clause
                 when @clause == 'QUERY'
                   @terms[0]
                 when @clause == 'NOT'
                   ' * NOT (' + @quotedTerms().join(' OR ') + ')'
                 else
                   @quotedTerms().join(" #{@clause} ")
    return '' unless fragment?
    "(#{@field}:#{fragment})"


  quotedTerms: ->
    $.map @terms, (term, i) -> if /\s/.test(term) then "\"#{term}\"" else term


  containerFeedback: (node) ->
    border = if @toQuery() == '' then '1px dashed gray' else '1px solid #CCCCCC'
    $(node.span).find('.clause-container').css('border', border)


  prompt: ->
    switch @clause
      when 'RANGE'
        switch @terms.length
          when 0 then 'add the FROM and TO terms...'
          when 1 then 'add the TO term...'
          when 2 then ''
      when 'LESS'
        switch @terms.length
          when 0 then 'add the MAX term...'
          when 1 then ''
      when 'GREATER'
        switch @terms.length
          when 0 then 'add the MIN term...'
          when 1 then ''
      else
        'click to add terms...'


  autocompleteEnabled: ->
    switch @clause
      when 'RANGE', 'LESS', 'GREATER'
        false
      else
        true

  filterEnabled: ->
    switch @clause
      when 'RANGE', 'LESS', 'GREATER'
        false
      else
        true

  noMoreTags: ->
    switch @clause
      when 'RANGE'
        @terms.length >= 2
      when 'LESS', 'GREATER'
        @terms.length >= 1
      else
        false

  disabled: ->
    @prompt() == ''
