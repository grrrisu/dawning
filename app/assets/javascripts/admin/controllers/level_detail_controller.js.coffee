levelModule.factory 'dataService', [ ->

  @randomNumber = () ->
    Math.floor((Math.random() * 500) + 1)
  
  loadData: (callback) =>
    callback(
      x: new Date(),
      data1: @randomNumber(),
      data2: @randomNumber()
    )
]

levelModule.controller('LevelDetailController', ['$scope', '$routeParams', 'level', '$interval', 'dataService', ($scope, $routeParams, level, $interval, dataService) ->

  @key = 'general'

  level.find $routeParams.id, (data) =>
    $scope.level = data
    
    $interval =>
      #console.log('interval')
      @loadObjectsCount()
    , data.time_unit.time_unit * 100

  $scope.setNav = (key) =>
    @key = key
    if key == 'sim_loop'
      @loadObjectsCount()

  $scope.isNav = (key) =>
    @key == key

  $scope.d3OnClick = (item) ->
    console.log(item)
    $scope.$apply ->
      console.log($scope.showDetailPanel)
      if (!$scope.showDetailPanel)
        $scope.showDetailPanel = true
      $scope.detailItem = item;

  $scope.pieOptions =
    data:
      columns: [[]]
      type: 'pie'
      onclick: (d, element) ->
        $scope.d3OnClick(d)
    legend:
      position: 'right'
    tooltip:
      format:
        value: (value, ratio, id, index) ->
          (ratio * 100).toFixed(1) + "% : " + value 

  $scope.timelineOptions =
    data:
      x: 'time',
      # types: 
      #   data1: 'area',
      #   data2: 'area'
      # groups: [['data1', 'data2']]
      # colors: @animalColors

  $scope.vegetation = []
  $scope.flora = []
  $scope.animals = []
  $scope.timeline = []

  @vegetationColors =
    'Vegetation 0': "#fee08b", 
    'Vegetation 1': "#ffffbf", 
    'Vegetation 2': "#d9ef8b", 
    'Vegetation 3': "#a6d96a", 
    'Vegetation 5': "#66bd63", 
    'Vegetation 8': "#1a9850", 
    'Vegetation 13': "#006837"

  @floraColors = 
    'Banana1': "#df65b0",
    'Banana2': "#ce1256",
    'Banana3': "#67001f"

  @animalColors =
    'Rabbit': "#abdda4",
    'Gazelle': "#66c2a5",
    'Mammoth': "#3288bd",
    'Leopard': "#d53e4f"

  @prepareOptions  = (colorSet) ->
    options = angular.copy($scope.pieOptions)
    options.data.colors = colorSet
    options

  $scope.vegetationOptions = @prepareOptions(@vegetationColors)
  $scope.floraOptions = @prepareOptions(@floraColors)
  $scope.animalOptions = @prepareOptions(@animalColors)
  $scope.timelineOptions.data.colors = @animalColors
  
  @filterData = (data, needle) =>
    res = Object.findAll data, (key, value) ->
      key.indexOf(needle) >= 0 || key == 'time'
    res

  @extractData = (data, needle, replacement) ->
    pieData = []
    Object.map data, (key, value) ->
      pieData.push([key.replace(needle, replacement), value])
    pieData

  @prepareTimeline = (data) ->
    columns = [['time']]
    keys = data.map (item) ->
      columns.push([item[0]])
      item[0]
    $scope.timeline = columns
    $scope.timelineOptions.data.groups = [keys]
    types = {}
    keys.each (item) ->
      types[item] = 'area'
    $scope.timelineOptions.data.types = types

  @extractTimeline = (data) ->
    data.each (data_item) ->
      $scope.timeline.each (timeline) ->
        if data_item[0] == timeline[0]
          timeline.add(data_item[1])

  @removeTime = (data) ->
    data.remove (item) =>
     item[0] == 'time'


  @loadObjectsCount = () =>
    level.objects_count $scope.level, (data) =>
      data['time'] = 500
      $scope.objects_count = data

      vegetation = @filterData(data, 'Vegetation::')
      flora      = @filterData(data, 'Flora::')
      animals    = @filterData(data, 'Animal::')

      vegetation = @extractData(vegetation, "::", " ")
      flora      = @extractData(flora, "Flora::", "")
      animals    = @extractData(animals, "Animal::", "")

      if $scope.timeline.length == 0
        @prepareTimeline(animals)
      @extractTimeline(animals)

      $scope.vegetation = @removeTime(vegetation)
      $scope.flora      = @removeTime(flora)
      $scope.animals    = @removeTime(animals)
      
])