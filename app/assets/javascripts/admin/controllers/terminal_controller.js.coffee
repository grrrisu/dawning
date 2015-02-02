levelModule.controller('TerminalController', ['$scope', '$sce', 'level', ($scope, $sce, level) ->

  $scope.sending = false

  $scope.cannotSubmit = (form) ->
    $scope.sending

  $scope.sendCommand = () ->
    $scope.sending = true
    if $scope.terminalForm.$valid
      level.terminalCommand $scope.level, $scope.command, (data) ->
        console.log(data.answer)
        if $scope.answer?
          $scope.answer += "#{data.answer}\n\r"
        else
          $scope.answer = data.answer
        $scope.sending = false
])