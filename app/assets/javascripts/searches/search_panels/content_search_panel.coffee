window.ContentSearchPanel = class ContentSearchPanel extends BaseSearchPanel

  constructor: ->
    super $('#content-search-panel')
    @panelInit()

  panelInit: ->
    @panel.find('#reset-button').click =>
      @queryField.val('')
      false

$ ->
  window.contentSearchPanel = new ContentSearchPanel
