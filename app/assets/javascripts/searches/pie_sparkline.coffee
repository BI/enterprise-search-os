window.PieSparkline = class PieSparkline

  @apply: ($items) ->
    $items.sparkline 'html',
      type: 'pie'
      sliceColors: ['#ffffff', '#006400']
      borderWidth: 1
      borderColor: '#006400'
