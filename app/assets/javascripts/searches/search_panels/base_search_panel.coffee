window.BaseSearchPanel = class BaseSearchPanel

  constructor: (@panel) ->
    @form           = @panel.find('form')
    @queryField     = @panel.find('#q')
    @selector       = @panel.find('#search_type_selector')
    @initSelector()


  initSelector: ->
    selIndex = $('#search_type_selector :selected')
    @selector.change =>
      val = $('#search_type_selector :selected').val()
      if val == '#'
        @selector.val(selIndex.val())
        alert 'Advanced Search Coming Soon'
      else
        window.location = val


