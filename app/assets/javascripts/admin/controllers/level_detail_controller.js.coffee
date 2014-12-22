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

  @animals = () =>
    $scope.animals = Object.findAll $scope.objects_count, (key, value) ->
      key.indexOf('Animal::') >= 0

  @loadObjectsCount = () =>
    level.objects_count $scope.level, (data) =>
      $scope.objects_count = data
      @animals()

])