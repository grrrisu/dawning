levelModule.controller('LevelsController', [ '$scope', '$http', 'level', ($scope, $http, level)->

  $scope.levels = []

  @loadLevels = () =>
    level.all (data) =>
      $scope.levels = data

  $scope.addLevel = () ->
    $scope.levels.unshift({})

  @removeLevel = (level) ->
    index = $scope.levels.findIndex (item) ->
      item.name == level.name
    if index != -1
      $scope.levels.splice(index, 1)

  @loadLevels()

])