levelModule.directive 'terminalInput', [ () ->
  restrict: 'EA',
  scope: 
    history: '='
  ,
  link: (scope, element, attrs) ->

    scope.setInputValue = (value) ->
      value = "" unless value?
      element.val(value)
    
    element.on 'keydown', (e) ->
      if e.keyIdentifier == 'Up'
        prev = scope.$parent.prevCommand()
        scope.setInputValue(prev)
      else if e.keyIdentifier == 'Down'
        next = scope.$parent.nextCommand()
        scope.setInputValue(next)

]