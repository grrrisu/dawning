data = {name: 'Test Level', state: 'built'}
app = angular.module('monitor', [])
controller = app.controller('MonitorController', ->
  @level = data
)
