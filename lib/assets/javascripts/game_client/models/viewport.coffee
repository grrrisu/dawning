class @Viewport

  constructor: (@width, @fieldsVisible, @map) ->
    @zoom   = 1
    @height = @width
    @map.setFieldWidth(@width / @fieldsVisible)
    @prev_rx = -1
    @prev_ry = -1

  setZoom: (zoom) =>
    @zoom = zoom
    client.presenter.stage.setAttrs
      scale: 1 / @zoom

  checkBoundaries: (pos) =>
    x = pos.x
    y = pos.y
    if x > 0
      x = 0;
    else if x < -@map.width / @zoom + @width
      x = -@map.width / @zoom + @width + 1

    if y > 0
      y = 0
    else if y < -@map.height / @zoom + @height
      y = -@map.height / @zoom + @height + 1

    @ax = -x
    @ay = -y
    rpos = @map.relativePosition(@ax * @zoom, @ay * @zoom)
    @rx = rpos.x
    @ry = rpos.y
    if(@rx != @prev_rx || @ry != @prev_ry)
      @update_map()
      @prev_rx = @rx
      @prev_ry = @ry
    { x: x, y: y }

  center: () =>
    if client.headquarter?
      @center_to_headquarter()
    else
      @center_to_middle_of_world()

  center_to_headquarter: () =>
    @ax = client.headquarter.ax - @width * @zoom / 2;
    @ay = client.headquarter.ay - @height * @zoom / 2;
    @move_stage(@ax, @ay)
    @rx = client.headquarter.rx - Math.floor(@fieldsVisible * @zoom / 2)
    @ry = client.headquarter.ry - Math.floor(@fieldsVisible * @zoom / 2)
    @update_map()

  center_to_middle_of_world: () =>
    @ax = @map.width / 2
    @ay = @map.height / 2
    @move_stage(@ax, @ay)
    @rx = @map.width / (@map.fieldWidth * 2)
    @ry = @map.height / (@map.fieldWidth * 2)
    @update_map()

  move_stage: =>
    client.presenter.stage.setAttrs
      x: -@ax / @zoom
      y: -@ay / @zoom
      scale: 1 / @zoom

  update_map: =>
    @map.update_fields(@rx, @ry, @fieldsVisible * @zoom + 1, @fieldsVisible * @zoom + 1);
    client.presenter.stage.draw()


