levelModule.directive 'c3Chart', ['$window', 'd3PieChart', 'd3BarChart',($window, d3PieChart, d3BarChart) ->
  restrict: 'EA',
  scope: 
    data: '=',
    options: '='
  ,
  link: (scope, element, attrs) ->

    scope.elementWidth = () ->
      $(element[0]).width()

    config =
      bindto: element[0],
      size: 
        height: 200
        width: scope.elementWidth()
      data: scope.data

    $.extend(config, scope.options)

    # Browser onresize event
    window.onresize = ->
      scope.$apply()

    # Watch for resize event
    scope.$watch ->
      angular.element($window)[0].innerWidth
    , ->
      scope.chart.resize({width: scope.elementWidth()}) if scope.chart?
      scope.render

    # watch for data changes and re-render
    scope.$watch 'data', (newVals, oldVals) ->
      config.data.columns = newVals
      scope.render();
    , true # check for objectEquality

    scope.render = () ->
      # If we don't pass any data return 
      return if scope.data.length == 0

      scope.chart = c3.generate(config)
]