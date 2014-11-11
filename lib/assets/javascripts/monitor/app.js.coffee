data = [
  {name: 'Test Level', state: 'built'}
  {name: 'Default Level', state: 'running'}
]

app = angular.module('monitor', [])

controller = app.controller('MonitorController', ->
  @levels = data
)
