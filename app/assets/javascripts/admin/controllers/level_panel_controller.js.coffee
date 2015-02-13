levelModule.controller('LevelPanelController', [ '$scope', '$http', 'levelStates', 'levelConfigs', 'level', ($scope, $http, levelStates, levelConfigs, level) ->

  levelConfigs.all().then (data) =>
    @config_files = data
  , (error) =>
    console.log(error)

  @sending = false

  $scope.stateClass = () =>
    levelStates.stateClass($scope.level.state)

  $scope.hasState = (state) ->
    if typeof(state) == 'string'
      $scope.level.state is state
    else
      state.indexOf($scope.level.state) > -1

  $scope.launchLevel = () =>
    if $scope.launchForm.$valid
      @sending = 'launch'
      level.launch $scope.new_level_name, @updateLevel
      $scope.$parent.refreshLevels()

  $scope.buildLevel = () =>
    if $scope.buildForm.$valid
      @sending = 'build'
      level.build $scope.level, @updateLevel

  $scope.runLevel = () =>
    @sending = 'run'
    level.run $scope.level, @updateLevel

  $scope.stopLevel = () =>
    @sending = 'stop'
    level.stop $scope.level, @updateLevel

  $scope.joinLevel = () =>
    @sending = 'join'
    level.join $scope.level, (data) =>
      window.location.href = '/levels/'+$scope.level.id+'/map.html'

  $scope.removeLevel = () =>
    @sending = 'remove'
    level.remove $scope.level, (data) =>
      $scope.$parent.removeLevel($scope.level)
      @resetSending()

  @updateLevel = (data) =>
    $scope.level = data
    @resetSending()

  @resetSending = () =>
    @sending = false

  $scope.buttonIcon = (icon, action) =>
    classes = {'fa-spin': @sending == action, 'fa-spinner': @sending == action}
    classes[icon] = @sending != action
    classes

  $scope.cannotSubmit = (form) =>
    @sending || form.$invalid

])