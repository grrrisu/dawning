levelModule.factory 'd3BarChart', [ 'd3Color', (d3Color) ->

  render: (data, svg, scope, element, attrs) ->
    margin = parseInt(attrs.margin) || 20
    barHeight = parseInt(attrs.barHeight) || 20
    barPadding = parseInt(attrs.barPadding) || 5

    color = d3Color.lolita()

    # setup variables
    width = d3.select(element[0]).node().offsetWidth - margin
    # calculate the height
    height = scope.data.length * (barHeight + barPadding)
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
        .attr "y", (d, i) ->
          15 + i * (20 + barPadding);
        .attr("x", 15)
        .text (d) ->
          d.name    

]
