levelModule.directive 'barChart', ['$window', ($window) ->
  restrict: 'EA',
  scope: 
    data: '=',
    onClick: '&' # delegate to parent scope
  ,
  link: (scope, element, attrs) ->

    margin = parseInt(attrs.margin) || 20
    barHeight = parseInt(attrs.barHeight) || 20
    barPadding = parseInt(attrs.barPadding) || 5
    
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

      # setup variables
      width = d3.select(element[0]).node().offsetWidth - margin
      # calculate the height
      height = scope.data.length * (barHeight + barPadding)
      # Use the category20() scale function for multicolor support
      color = d3.scale.category10()
      # our xScale
      xScale = d3.scale.linear()
        .domain([0, d3.max(data, (d) ->
          return d.value;
        )])
        .range([0, width]);

      # set the height based on the calculations above
      svg.attr('height', height);

      #create the rectangles for the bar chart
      svg.selectAll('rect')
        .data(data)
        .enter()
          .append('rect')
          .on 'click', (d, i) ->
            scope.onClick({item: d})
          .attr('height', barHeight)
          .attr('width', 140)
          .attr('x', Math.round(margin/2))
          .attr 'y', (d,i) -> 
            return i * (barHeight + barPadding);
          .attr 'fill', (d) -> 
            return color(d.value)
          .transition()
            .duration(1000)
            .attr 'width', (d) ->
              return xScale(d.value)

      svg.selectAll("text")
        .data(data)
        .enter()
          .append("text")
          .attr("fill", "#fff")
          .attr "y", (d, i) ->
            15 + i * (20 + barPadding);
          .attr("x", 15)
          .text (d) ->
            d.name
            
]