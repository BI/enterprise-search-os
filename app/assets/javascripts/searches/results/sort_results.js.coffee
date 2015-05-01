window.SortResults = class SortResults

  constructor: ->
    @buttons = $('a.result-sort')
    @initButtons()

  initButtons: ->
    @buttons.click ->
      facetSearchPanel.reorderResults($(this).attr('href'))
      false


$ ->
  window.sortResults = new SortResults
