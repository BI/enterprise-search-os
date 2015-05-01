$ ->
  $('a.more_like_this').click ->
    facetSearchPanel.addHiddenField('mlt_id', $(this).attr('href'))
    facetSearchPanel.submit()
    false
