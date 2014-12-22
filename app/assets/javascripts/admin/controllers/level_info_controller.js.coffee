levelModule.controller('levelInfoController', [ '$scope', 'level', '$timeout', ($scope, level, $timeout) ->

  @watching = []

  @watch = (current) =>
    @watching.push(current.id)
    @refresh(current)

  @showWatchButton = (current) =>
    already_watching = @watching.any (item) ->
      item == current.id
    current.state == 'running' && !already_watching

  @refresh = (current) =>
    $timeout () =>
      if current && current.id && current.state == 'running'
        level.find current.id, (data) =>
          $scope.$parent.level = data
          @refresh($scope.$parent.level)
    , 5000

])