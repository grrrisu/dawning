class Game.MapData

  constructor: () ->
    @dataSets = [];

  setDataDimensions: (fieldWidth, fieldHeight) =>
    @dataWidth  = Math.round(fieldWidth / 10);
    @dataHeight = Math.round(fieldHeight / 10);

  currentView: () =>
    return [
      [@dataX - 10, @dataX + (@dataWidth + 1) * 10 - 1],
      [@dataY - 10, @dataY + (@dataHeight + 1) * 10 - 1]
    ];

  updateData: () =>
    @removeData();
    @loadData();

  removeData: () =>
    @dataSets.remove (dataSet) =>
      return dataSet.x < @dataX - 10 ||
             dataSet.x2 > @dataX + (@dataWidth + 1) * 10 ||
             dataSet.y < @dataY - 10 ||
             dataSet.y2 > @dataY + (@dataHeight + 1) * 10;

  loadData: () =>
    for x in [-10..(@dataWidth * 10)] by 10
      for y in [-10..(@dataHeight * 10)] by 10
        px = x + @dataX;
        py = y + @dataY;

        unless @isDataSetLoaded(px, py)
          request_view = {x: px, y: py, width: 10, height: 10};
          Game.main.mapController.view(request_view);

  isDataSetLoaded: (x, y) =>
    @dataSets.any (dataSet) ->
      dataSet.x == x && dataSet.y == y

  addDataSet: (data) =>
    data['x2'] = data.x + data['view'][0].length - 1;
    data['y2'] = data.y + data['view'].length - 1;
    @dataSets.push(data);

  getVegetation: (rx, ry) =>
    field = @getField(rx, ry)
    if field?
      return field.vegetation;

  mapMovedTo: (rx, ry, callback) =>
    if @rx != rx || @ry != ry
      deltaX = rx - @rx;
      deltaY = ry - @ry;
      @setDataPosition(rx, ry);
      @updateData();
      callback(deltaX, deltaY);

  setDataPosition: (rx, ry) =>
    @rx = rx;
    @ry = ry;
    @dataX = Math.round(@rx / 10) * 10; # dataset start x
    @dataY = Math.round(@ry / 10) * 10; # dataset start y

  eachField: (startX, endX, startY, endY, callback) =>
    for y in [startY...endY]
      for x in [startX...endX]
        callback(@rx + x, @ry + y);

  getField: (rx, ry) ->
    dataSet = @_getDataSet(rx, ry);
    if dataSet?
      return dataSet['view'][ry - dataSet.y][rx - dataSet.x];
    else
      console.log("no data set for #{rx}, #{ry}");
      return null;

  # private

  _getDataSet: (rx, ry) =>
    @dataSets.find (dataSet) ->
      return dataSet.x <= rx && dataSet.x2 > rx && dataSet.y <= ry && dataSet.y2 > ry;
