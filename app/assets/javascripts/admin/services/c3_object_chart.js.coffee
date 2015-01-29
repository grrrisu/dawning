levelModule.factory 'c3ObjectChart', ['level', '$interval', (level, $interval) ->

  @filterData = (data, needle) =>
    res = Object.findAll data, (key, value) ->
      key.indexOf(needle) >= 0 || key == 'time'
    res

  @extractData = (data, needle, replacement) ->
    pieData = []
    Object.map data, (key, value) ->
      pieData.push([key.replace(needle, replacement), value])
    pieData

  @prepareTimeline = (scope, data) ->
    columns = []
    keys = data.map (item) ->
      columns.push([item[0]])
      item[0]
    scope.timeline = columns
    scope.timelineOptions.data.groups = [keys]
    types = {}
    keys.each (item) ->
      types[item] = 'area'
    scope.timelineOptions.data.types = types

  @extractTimeline = (scope, data) ->
    scope.timeline.each (timeline) ->
      data_found = data.find (data_item) ->
        data_item[0] == timeline[0]
      if data_found?
        timeline.add(data_found[1])
      else
        timeline.add(0)

  @removeTime = (data) ->
    data.remove (item) =>
     item[0] == 'time'

  vegetationColors:
    'Vegetation 0': "#fee08b", 
    'Vegetation 1': "#ffffbf", 
    'Vegetation 2': "#d9ef8b", 
    'Vegetation 3': "#a6d96a", 
    'Vegetation 5': "#66bd63", 
    'Vegetation 8': "#1a9850", 
    'Vegetation 13': "#006837"

  floraColors:
    'Banana1': "#df65b0",
    'Banana2': "#ce1256",
    'Banana3': "#67001f"

  animalColors:
    'Rabbit': "#abdda4",
    'Gazelle': "#66c2a5",
    'Mammoth': "#3288bd",
    'Leopard': "#d53e4f"

  pieOptions:
    data:
      columns: [[]]
      type: 'pie'
      # onclick: (d, element) ->
      #   $scope.d3OnClick(d)
    legend:
      position: 'right'
    tooltip:
      format:
        value: (value, ratio, id, index) ->
          (ratio * 100).toFixed(1) + "% : " + value

  timelineOptions:
    data:
      x: 'time',
      # types: 
      #   data1: 'area',
      #   data2: 'area'
      # groups: [['data1', 'data2']]
      # colors: @animalColors

  loadObjectsCount: (scope) =>
    level.objects_count scope.level, (data) =>
      scope.objects_count = data

      vegetation = @filterData(data, 'Vegetation::')
      flora      = @filterData(data, 'Flora::')
      animals    = @filterData(data, 'Animal::')

      vegetation = @extractData(vegetation, "::", " ")
      flora      = @extractData(flora, "Flora::", "")
      animals    = @extractData(animals, "Animal::", "")

      if scope.timeline.length == 0
        @prepareTimeline(scope, animals)
      @extractTimeline(scope, animals)

      scope.vegetation = @removeTime(vegetation)
      scope.flora      = @removeTime(flora)
      scope.animals    = @removeTime(animals)
]