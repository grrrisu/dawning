class Game.DragablePresenter extends Game.ImagePresenter

  render: (layer) =>
    @create_node()

    @node.on 'mouseover', (event) =>
      client.presenter.stage.setDraggable(false)

    @node.on 'mouseout', (event) =>
      client.presenter.stage.setDraggable(true)

    @node.on 'dragend', (event) =>
      @model.drop(@node.getX() + @node.getWidth() / 2, @node.getY() + @node.getHeight() / 2)

    @update_layer(layer)

  node_attributes: =>
    $.extend(super(),
      draggable: true
      dragBoundFunc: (pos) =>
        @model.checkBoundaries(pos)
    )
