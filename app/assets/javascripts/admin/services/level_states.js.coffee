levelModule.factory('levelStates', [ ()->
  @state_classes =
    'launched': 'fa-rocket',
    'ready': 'fa-cubes',
    'running': 'fa-spin fa-cog',
    'stopped': 'fa-moon-o'

  stateClass: (state) =>
    if state?
      @state_classes[state]
    else
      'fa-star'
])