levelModule.directive 'c3Chart', ['$window', 'd3PieChart', 'd3BarChart',($window, d3PieChart, d3BarChart) ->
  restrict: 'EA',
  scope: 
    data: '=',
    options: '='
  ,
  link: (scope, element, attrs) ->
    config =
      bindto: element[0],
      size: 
        height: 200
        width: $(element[0]).width()
      data: scope.data

    $.extend(config, scope.options)

    # Browser onresize event
    window.onresize = ->
      scope.$apply()

    # Watch for resize event
    scope.$watch ->
      angular.element($window)[0].innerWidth
    , ->
      scope.chart.resize({width: $(element[0]).width()}) if scope.chart?
      scope.render

    # watch for data changes and re-render
    scope.$watch 'data', (newVals, oldVals) ->
      scope.render();
    , true # check for objectEquality 

    scope.render = () ->
      scope.chart = c3.generate(config)
]