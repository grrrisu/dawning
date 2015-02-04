levelModule.controller('TerminalController', ['$scope', '$sce', 'level', ($scope, $sce, level) ->

  $scope.sending = false

  $scope.history = []

  @historyCursor = 0

  $scope.cannotSubmit = (form) ->
    $scope.sending

  $scope.showOutput = () ->
    $scope.answer?

  $scope.setCommand = (command) ->
    $scope.command = command

  $scope.prevCommand = () =>
    if @historyCursor < $scope.history.length
      ++@historyCursor
      $scope.command = $scope.history[@historyCursor]

  $scope.nextCommand = () =>
    if @historyCursor > 0
      --@historyCursor
      $scope.command = $scope.history[@historyCursor]

  $scope.sendCommand = () =>
    $scope.sending = true
    if $scope.terminalForm.$valid
      level.terminalCommand $scope.level, $scope.command, (data) =>
        $scope.history.unshift($scope.command)
        @historyCursor = 0
        if $scope.answer?
          $scope.answer += "#{data.answer}\n\r"
        else
          $scope.answer = "#{data.answer}\n\r"
        $scope.sending = false
])