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
    legend:
      position: 'right'
    tooltip:
      format:
        value: (value, ratio, id, index) ->
          (ratio * 100).toFixed(1) + "% : " + value 
    # color:
    #   pattern: ['#328dbd', '#2cb377', '#f28248', '#fdde6c', '#9d3fa3', '#583b97', '#8bbb42']

  $scope.vegetation = []
  $scope.flora = []
  $scope.animals = []

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

  $scope.timelineData =
    x: 'x',
    columns: [['x'], ['data1'] , ['data2']]
    types: 
      data1: 'area',
      data2: 'area'
    groups: [['data1', 'data2']]
    colors: @animalColors

  $scope.pieVegetation =
    columns: $scope.vegetation
    type: 'pie'
    colors: @vegetationColors
    onclick: (d, element) ->
      $scope.d3OnClick(d)

  $scope.pieFlora =
    columns: $scope.flora
    type: 'pie'
    colors: @floraColors
    onclick: (d, element) ->
      $scope.d3OnClick(d)

  $scope.pieAnimals =
    columns: $scope.animals
    type: 'pie'
    colors: @animalColors
    onclick: (d, element) ->
      $scope.d3OnClick(d)

  # $interval =>
  #   dataService.loadData (data) ->
  #     $scope.timelineData.columns[0].push(data.x);
  #     $scope.timelineData.columns[1].push(data.data1);
  #     $scope.timelineData.columns[2].push(data.data2);
  # ,1000


  @d3vegetation = =>
    vegetation = Object.findAll $scope.objects_count, (key, value) ->
      key.indexOf('Vegetation::') >= 0
    $scope.d3vegetation = []
    Object.map vegetation, (key, value) ->
      $scope.d3vegetation.push({name: key.replace("::", " "), value: value})
    
  @d3flora = () =>
    flora = Object.findAll $scope.objects_count, (key, value) ->
      key.indexOf('Flora::') >= 0
    $scope.d3flora = []
    Object.map flora, (key, value) ->
      $scope.d3flora.push({name: key.replace("Flora::", ""), value: value})

  @d3animals = () =>
    animals = Object.findAll $scope.objects_count, (key, value) ->
      key.indexOf('Animal::') >= 0
    $scope.d3animals = []
    Object.map animals, (key, value) ->
      $scope.d3animals.push({name: key.replace("Animal::", ""), value: value})


  @vegetation = =>
    vegetation = Object.findAll $scope.objects_count, (key, value) ->
      key.indexOf('Vegetation::') >= 0
    Object.map vegetation, (key, value) ->
      $scope.vegetation.push([key.replace("::", " "), value])
    
  @flora = () =>
    flora = Object.findAll $scope.objects_count, (key, value) ->
      key.indexOf('Flora::') >= 0
    Object.map flora, (key, value) ->
      $scope.flora.push([key.replace("Flora::", ""), value])

  @animals = () =>
    animals = Object.findAll $scope.objects_count, (key, value) ->
      key.indexOf('Animal::') >= 0
    Object.map animals, (key, value) ->
      $scope.animals.push([key.replace("Animal::", ""), value])

  @loadObjectsCount = () =>
    level.objects_count $scope.level, (data) =>
      $scope.objects_count = data
      @d3flora()
      @d3animals()
      @d3vegetation()
      @flora()
      @animals()
      @vegetation()

])