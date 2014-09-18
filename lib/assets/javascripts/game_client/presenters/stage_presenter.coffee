class Game.StagePresenter

  constructor: (@viewport) ->

  render: =>
    console.log('pixelRatio: ' + window.devicePixelRatio)
    Kinetic.pixelRatio = window.devicePixelRatio
    @stage = new Kinetic.Stage
      container: 'pawns'
      width: @viewport.width
      height: @viewport.height
      fill: 'red'
      draggable: true
      dragBoundFunc: (pos) =>
        @viewport.checkBoundaries(pos)

    @map_layer  = new Kinetic.Layer()
    @pawn_layer = new Kinetic.Layer()
    @stage.add(@map_layer)
    @stage.add(@pawn_layer)
