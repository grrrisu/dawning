levelModule.controller('LevelDetailController', ['$scope', '$routeParams', 'level', '$interval', 'c3ObjectChart', ($scope, $routeParams, level, $interval, c3ObjectChart) ->

  @key = 'general'

  $scope.stacked = true

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

  $scope.toggleStacked = () ->
    if $scope.stacked == true
      $scope.timelineOptions.data.groups = @timelineGroupOptions
      $scope.timelineOptions.data.types  = @timelineTypesOptions
    else
      @timelineGroupOptions = $scope.timelineOptions.data.groups
      @timelineTypesOptions = $scope.timelineOptions.data.types
      delete $scope.timelineOptions.data.groups
      delete $scope.timelineOptions.data.types

  $scope.pieOptions = c3ObjectChart.pieOptions
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