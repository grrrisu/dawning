data = [
  {id: 1, name: 'Foobar', state: 'launched'}
  {id: 2, name: 'Test Level', state: 'ready'}
  {id: 3, name: 'Default Level', state: 'running'}
  {id: 4, name: 'Old Level', state: 'stopped'}
]

app = angular.module('monitor', [])

controller = app.controller('MonitorController', ->
  @levels = data
)
