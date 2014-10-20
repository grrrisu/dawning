class Game.MapPresenter

  constructor: (@model) ->

  setLayer: (layer) =>
    @layer = layer

  setPawnLayer: (layer) =>
    @pawn_layer = layer

  render_fog: () =>
    @fog   = new Kinetic.Rect
      width: @model.mapWidth()
      height: @model.mapHeight()
      fillPatternImage: client.images['fog']
      fillPatternScaleX: 1 / Kinetic.pixelRatio
      fillPatternScaleY: 1 / Kinetic.pixelRatio
      stroke: 'black'
      strokeWidth: 1

    @layer.add(@fog);
    @layer.draw()
    @fog
