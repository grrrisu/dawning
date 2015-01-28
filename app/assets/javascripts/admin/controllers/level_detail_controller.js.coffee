levelModule.controller('LevelDetailController', ['$scope', '$routeParams', 'level', '$interval', 'c3ObjectChart', ($scope, $routeParams, level, $interval, c3ObjectChart) ->

  @key = 'general'

  level.find $routeParams.id, (data) =>
    $scope.level = data
    
    $interval =>
      if $scope.level.state == 'running'
        c3ObjectChart.loadObjectsCount($scope)
    , data.time_unit.time_unit * 1000

  $scope.setNav = (key) =>
    @key = key
    if key == 'sim_loop'
      c3ObjectChart.loadObjectsCount($scope)

  $scope.isNav = (key) =>
    @key == key

  $scope.d3OnClick = (item) ->
    console.log(item)

  $scope.pieOptions = c3ObjectChart.pieOptions
  window.c3objectChart = c3ObjectChart
  $scope.timelineOptions = c3ObjectChart.timelineOptions

  $scope.vegetation = []
  $scope.flora = []
  $scope.animals = []
  $scope.timeline = []

  @prepareOptions  = (colorSet) ->
    options = angular.copy($scope.pieOptions)
    options.data.colors = colorSet
    options

  $scope.vegetationOptions = @prepareOptions(c3ObjectChart.vegetationColors)
  $scope.floraOptions = @prepareOptions(c3ObjectChart.floraColors)
  $scope.animalOptions = @prepareOptions(c3ObjectChart.animalColors)
  $scope.timelineOptions.data.colors = c3ObjectChart.animalColors
      
])