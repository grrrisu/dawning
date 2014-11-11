time_unit = { unit: 60, time_elapsed: 3200, started: '2014-09-27T18:30:49-0300' }

data = [
  {},
  {id: 1, name: 'Foobar', state: 'launched', config: 'default.yml'},
  {id: 2, name: 'Test Level', state: 'ready', config: 'default.yml', time_unit: time_unit, event_queue: {}, sim_loops: []},
  {id: 3, name: 'Default Level', state: 'running', config: 'default.yml', time_unit: time_unit, event_queue: {}, sim_loops: []},
  {id: 4, name: 'Old Level', state: 'stopped', config: 'default.yml', time_unit: time_unit, event_queue: {}, sim_loops: []}
]

states = {
  'launched': { state_class: 'fa-rocket', button_class: 'btn btn-primary spinner' },
  'ready': { state_class: 'fa-cubes', button_class: 'btn btn-success spinner' },
  'running': { state_class: 'fa-spin fa-refresh', button_class: 'btn btn-warning spinner' },
  'stopped': { state_class: 'fa-moon-o', button_class: 'btn btn-danger spinner'}
}

app = angular.module('monitor', [])

app.controller('MonitorController', ->
  @levels = data
  @states = states

  # TODO move to model
  @hasState = (level, state) ->
    level.state is state

  @state_class = (state) ->
    if state?
      @states[state].state_class
    else
      'fa-star'

  @button_class = (state) ->
    @states[state].button_class if state?

)

app.controller('LaunchController', ->

  @launchLevel = (monitorCtrl, level) ->
    level.state = 'launched'
    monitorCtrl.levels.unshift({})
)
