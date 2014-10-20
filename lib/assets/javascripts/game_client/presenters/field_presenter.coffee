class Game.FieldPresenter

  constructor: (@map) ->

  render: (field_data, rx, ry) =>
    ground = new Kinetic.Rect
      x: field_data.x * @map.fieldWidth
      y: field_data.y * @map.fieldWidth
      width: @map.fieldWidth
      height: @map.fieldWidth
      fillPatternImage: client.images[@field_pattern(field_data)]
      fillPatternScaleX: 1 / Kinetic.pixelRatio
      fillPatternScaleY: 1 / Kinetic.pixelRatio
      stroke: '#454545'
      strokeWidth: 2

    ground.on 'click', (e) =>
      console.log("ground: [" + ground.attrs.x + ", " + ground.attrs.y + "]")

    @map.layer().add(ground);
    ground

  field_pattern: (data) =>
    switch data.vegetation.type
      when 0 then "0_desert" # "#F8D76D";
      when 1 then "1_grass" # "#DBB253";
      when 2 then "2_grass" # "#A3AE45";
      when 3 then "3_grass" # "#94CB54";
      when 5 then "5_grass" # "#2EB24B";
      when 8 then "8_forest" # "#35942A";
      when 13 then "13_forest" # "#296134";
