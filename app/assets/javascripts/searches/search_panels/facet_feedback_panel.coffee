# The facet feedback is the little stripe under the search and expected results
window.FacetFeedbackPanel = class FacetFeedbackPanel

  constructor: ->
    @panel           = $('#facet-feedback')
    @removeLike      = @panel.find('#remove-result-like,.mlt-selected')
    @removeAllFacets = @panel.find('#remove-all-facets')
    @selectedFacets  = @panel.find('.selected-term')
    @init()


  init: ->
    @removeLike.click ->
      facetSearchPanel.removeHiddenField('mlt_id', $(this).attr('href'))
      facetSearchPanel.submit()

    @removeAllFacets.click ->
      facetSearchPanel.removeAllFacetTerms()
      facetSearchPanel.submit()

    @selectedFacets.click ->
      facetSearchPanel.removeHiddenField($(this).attr('href').split('=')...)
      facetSearchPanel.submit()


$ ->
  window.facetFeedbackPanel = new FacetFeedbackPanel
