levelModule.directive 'd3Chart', ['$window', 'd3PieChart', 'd3BarChart',($window, d3PieChart, d3BarChart) ->
  restrict: 'EA',
  scope: 
    data: '=',
    onClick: '&' # delegate to parent scope
  ,
  link: (scope, element, attrs) ->
    svg = d3.select(element[0])
      .append('svg')
      .style('width', '100%') # make element responsive

    # Browser onresize event
    window.onresize = ->
      scope.$apply()

    # Watch for resize event
    scope.$watch ->
      angular.element($window)[0].innerWidth
    , -> 
      scope.render(scope.data)

    # watch for data changes and re-render
    scope.$watch 'data', (newVals, oldVals) ->
      scope.render(newVals);
    , true # check for objectEquality 

    # our custom d3 code
    scope.render = (data) ->
      # remove all previous items before render
      svg.selectAll('*').remove()

      # If we don't pass any data, return out of the element
      return unless data?

      if attrs.d3Chart == 'pie'
        d3PieChart.render(data, svg, scope, element, attrs)
      else if attrs.d3Chart == 'bar'
        d3BarChart.render(data, svg, scope, element, attrs)  
]