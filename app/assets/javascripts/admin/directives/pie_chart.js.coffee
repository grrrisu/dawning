levelModule.directive 'pieChart', ['$window', ($window) ->
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
      
      color = d3.scale.category10()
      width = 250
      height = 250
      radius = Math.min(width, height) / 2
      
      arc = d3.svg.arc()
        .outerRadius(radius - 30)
        .innerRadius(0)

      pie = d3.layout.pie()
        .value (d) -> 
          d.value

      chart = svg
        .attr("width", width)
        .attr("height", height)
        .append("g")
          .on 'click', (d, i) ->
            console.log(d)
            scope.onClick({item: d})
          .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")
          

      g = chart.selectAll(".arc")
        .data(pie(data))
        .enter().append("g")
          .attr("class", "arc");

      g.append("path")
        .attr("d", arc)
        .style "fill", (d) -> 
          color(d.data.name)

      # second arc for labels
      arc2 = d3.svg.arc()
        .outerRadius(radius - 20)
        .innerRadius(radius - 20);

      # label attached to second arc
      g.append("text")
        .attr "transform", (d) -> 
          "translate(" + arc2.centroid(d) + ")"
        .attr("dy", ".35em")
        .style("text-anchor", "middle")
        .text (d) ->
          d.data.name
            
]