class @StagePresenter

  constructor: (@viewport) ->

  render: =>
    @stage = new Kinetic.Stage
      container: 'prawns'
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
