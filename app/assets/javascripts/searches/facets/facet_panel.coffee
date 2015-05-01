window.FacetPanel = class FacetPanel

  constructor: ->
    @cookieName = "#{window.searchedIndex}-facet-panel"
    @panel      = $('#facet-panel')
    @hideBtn    = @panel.find('#facet-panel-hider')
    @chooserBtn = @panel.find('#facet-chooser-button')
    @initCookie()
    @initFacets()
    @facetChooser = new FacetChooser(@panel.find('#facet-chooser'), @facets)
    @initBtns()


  initCookie: ->
    if $.cookie(@cookieName) == null
      $.cookie(@cookieName,{})


  initFacets: ->
    facets = {}
    @panel.find('.facet').each ->
      facets[$(this).attr('id')] = new Facet $(this)
    @facets = facets


  initBtns: ->
    @hideBtn.click =>
      @panel.fadeToggle('slow', -> resultPanel.expand())

    @chooserBtn.click =>
      @facetChooser.toggle()


$ ->
  window.facetPanel = new FacetPanel
