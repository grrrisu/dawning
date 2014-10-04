class Game.ImagePresenter

  constructor: (@model) ->

  render: (layer) =>
    @create_node()
    @update_layer(layer)

  update_layer: (layer) =>
    layer.add(@node)
    @node.moveToTop()
    layer.draw
    @node

  create_node: =>
    @node = new Kinetic.Image(@node_attributes())

  node_attributes: =>
    x: @model.ax - @model.image.width / 4
    y: @model.ay - @model.image.height / 4
    image: @model.image
    width: @model.image.width / 2
    height: @model.image.height / 2

  move: (ax, ay) =>
    @node.setAttrs
      x: ax - @node.getWidth() / 2
      y: ay - @node.getHeight() / 2
    @node.getLayer().draw()

