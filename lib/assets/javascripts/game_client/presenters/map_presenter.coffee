class @MapPresenter

  constructor: (@model) ->

  setLayer: (layer) =>
    @layer = layer

  render_fog: () =>
    @fog   = new Kinetic.Rect
      width: @model.mapWidth()
      height: @model.mapHeight()
      fillPatternImage: client.images['fog']
      stroke: 'black'
      strokeWidth: 1

    @layer.add(@fog);
    @layer.draw()
    @fog

  render_field: (data, rx, ry) =>
    ground = new Kinetic.Rect
      x: rx * @model.fieldWidth
      y: ry * @model.fieldWidth
      width: @model.fieldWidth
      height: @model.fieldWidth
      fillPatternImage: client.images[@field_pattern(data)]
      stroke: 'black'
      strokeWidth: 1

    @layer.add(ground);
    ground

  field_pattern: (data) =>
    switch data.vegetation
      when 0 then "0_desert" # "#F8D76D";
      when 1 then "1_grass" # "#DBB253";
      when 2 then "2_grass" # "#A3AE45";
      when 3 then "3_grass" # "#94CB54";
      when 5 then "5_grass" # "#2EB24B";
      when 8 then "8_forest" # "#35942A";
      when 13 then "13_forest" # "#296134";
