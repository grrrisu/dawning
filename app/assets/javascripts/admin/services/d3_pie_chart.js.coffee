levelModule.factory 'd3PieChart', [ 'd3Color', (d3Color) ->

  render: (data, svg, scope, element, attrs) ->
    width = 250
    height = 250
    radius = Math.min(width, height) / 2

    color = d3Color.lolita()

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
