$.fn.tagcloud.defaults =

  size:
    start: 12
    end:   24
    unit: 'px'

  color:
    start: '#cde'
    end:   '#f52'

$ ->
  $(".wordcloud span").tagcloud()

