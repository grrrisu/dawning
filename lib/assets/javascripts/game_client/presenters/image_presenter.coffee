class @ImagePresenter

  constructor: (@model) ->

  render: (layer) =>
    @node = new Kinetic.Image
      x: @model.ax - @model.image.width / 2
      y: @model.ay - @model.image.height / 2
      image: @model.image
      width: @model.image.width
      height: @model.image.height
      draggable: @model.draggable
      dragBoundFunc: (pos) =>
        @model.checkBoundaries(pos)

    @node.on 'mouseover', (event) =>
      client.presenter.stage.setDraggable(false)

    @node.on 'mouseout', (event) =>
      client.presenter.stage.setDraggable(true)

    @node.on 'dragend', (event) =>
      @model.drop(@node.getX() + @node.getWidth() / 2, @node.getY() + @node.getHeight() / 2)

    layer.add(@node)
    @node.moveToTop()
    layer.draw

  move: (ax, ay) =>
    @node.setAttrs
      x: ax - @node.getWidth() / 2
      y: ay - @node.getHeight() / 2
    @node.getLayer().draw()

