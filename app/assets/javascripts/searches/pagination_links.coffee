window.PaginationLinks = class PaginationLinks

  constructor: ->
    @pagination = $('#pagination')
    @links      = @pagination.find('a')
    @init()


  init: ->
    @links.click ->
      href = $(this).attr('href')
      # if it is a number of page, then it adds the hidden field and submit the form
      if !isNaN(parseFloat(href)) && isFinite(href)
        facetSearchPanel.addHiddenField 'page', href
        facetSearchPanel.submit()
      # else behaves normally


$ ->
  window.paginationLinks = new PaginationLinks
