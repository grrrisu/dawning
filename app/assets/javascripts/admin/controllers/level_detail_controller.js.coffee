levelModule.controller('LevelDetailController', ['$scope', '$routeParams', 'level', ($scope, $routeParams, level) ->

  @key = 'general'

  level.find $routeParams.id, (data) =>
    $scope.level = data

  $scope.setNav = (key) =>
    @key = key
    if key == 'sim_loop'
      @loadObjectsCount()

  $scope.isNav = (key) =>
    @key == key

  $scope.chartData = [
    {name: "Greg", score: 98},
    {name: "Ari", score: 96},
    {name: 'Q', score: 75},
    {name: "Loser", score: 48}
  ]

  $scope.d3OnClick = (item) ->
    console.log(item)
    $scope.$apply ->
      console.log($scope.showDetailPanel)
      if (!$scope.showDetailPanel)
        $scope.showDetailPanel = true
      $scope.detailItem = item;

  @vegetation = =>
    vegetation = Object.findAll $scope.objects_count, (key, value) ->
      key.indexOf('Vegetation::') >= 0
    $scope.vegetation = []
    Object.map vegetation, (key, value) ->
      $scope.vegetation.push({name: key.replace("Vegetation::", ""), value: value})

  @animals = () =>
    animals = Object.findAll $scope.objects_count, (key, value) ->
      key.indexOf('Animal::') >= 0
    $scope.animals = []
    Object.map animals, (key, value) ->
      $scope.animals.push({name: key.replace("Animal::", ""), value: value})

  @flora = () =>
    flora = Object.findAll $scope.objects_count, (key, value) ->
      key.indexOf('Flora::') >= 0
    $scope.flora = []
    Object.map flora, (key, value) ->
      $scope.flora.push({name: key.replace("Flora::", ""), value: value})

  @loadObjectsCount = () =>
    level.objects_count $scope.level, (data) =>
      $scope.objects_count = data
      @flora()
      @animals()
      @vegetation()

])