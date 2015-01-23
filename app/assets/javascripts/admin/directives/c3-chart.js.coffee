levelModule.directive 'c3Chart', ['$window', 'd3PieChart', 'd3BarChart',($window, d3PieChart, d3BarChart) ->
  restrict: 'EA',
  scope: 
    data: '=',
    options: '='
  ,
  link: (scope, element, attrs) ->
    console.log(scope.options)
    console.log(element[0].offsetWidth)
    config =
      bindto: element[0],
      size: 
        height: 200
        width: element.offsetWidth - 50
      data: scope.data

    $.extend(config, scope.options)

    # watch for data changes and re-render
    scope.$watch 'data', (newVals, oldVals) ->
      scope.render();
    , true # check for objectEquality 

    scope.render = () ->
      c3.generate(config)
]