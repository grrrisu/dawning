describe("MapData", function() {

  beforeEach(function() {
    data =
    `{
      "x": 25,
      "y": 50,
      "view":
      [
        [
          {
            "x": 25,
            "y": 50,
            "vegetation": {
              "type": 1,
              "size": 50
            }
          },
          {
            "x": 26,
            "y": 50,
            "vegetation": {
              "type": 2,
              "size": 100
            }
          }
        ],
        [
          {
            "x": 25,
            "y": 51,
            "vegetation": {
              "type": 3,
              "size": 250
            }
          },
          {
            "x": 26,
            "y": 51,
            "vegetation": {
              "type": 5,
              "size": 500
            }
          }
        ]
      ]
    }`;

    mapData = new Game.MapData();
    mapData.addDataSet(data);
  });

  describe("getter and setter", function() {

    it("should set dimensions", function() {
      dataSet = mapData.dataSets[0]
      expect(dataSet['x2']).toEqual(26);
      expect(dataSet['y2']).toEqual(51);
    });

    it("should get vegetation", function() {
      vegetation = mapData.getVegetation(25, 50);
      expect(vegetation.type).toEqual(1);
    });

    it("should set position", function() {
      mapData.setDataPosition(33, 47);
      expect(mapData.rx).toEqual(33);
      expect(mapData.ry).toEqual(47);
      expect(mapData.dataX).toEqual(30);
      expect(mapData.dataY).toEqual(50);
    });

    it("should get current view", function() {
      mapData.setDataPosition(33, 47);
      mapData.setDataDimensions(33, 11);
      currentView = mapData.currentView();
      expect(currentView[0]).toEqual([20, 69]);
      expect(currentView[1]).toEqual([40, 69]);
    });

  });

  describe("with position", function() {

    beforeEach(function() {
      mapData.setDataPosition(33, 47);
      mapData.setDataDimensions(11, 11);
    });

    it("should not remove already loaded data", function(){
      // dataX 30 dataY 50
      mapData.dataSets = [
        {x: 30, y: 50, x2: 40, y2: 60},
        {x: 30, y: 60, x2: 40, y2: 70},
        {x: 30, y: 40, x2: 40, y2: 50},
        {x: 40, y: 50, x2: 50, y2: 60},
        {x: 40, y: 60, x2: 50, y2: 70},
        {x: 40, y: 40, x2: 50, y2: 50},
        {x: 20, y: 50, x2: 30, y2: 60},
        {x: 20, y: 60, x2: 30, y2: 70},
        {x: 20, y: 40, x2: 30, y2: 50}
      ];
      mapData.removeData();
      expect(mapData.dataSets.length).toEqual(9);
    });

    it("should remove distant data", function(){
      mapData.dataSets = [
        {x: 10, y: 50, x2: 20, y2: 60},
        {x: 10, y: 60, x2: 20, y2: 70},
        {x: 10, y: 40, x2: 20, y2: 50},
        {x: 40, y: 30, x2: 50, y2: 40},
        {x: 40, y: 70, x2: 50, y2: 80},
        {x: 40, y: 40, x2: 50, y2: 50},
        {x: 50, y: 50, x2: 60, y2: 60},
        {x: 50, y: 60, x2: 60, y2: 70},
        {x: 50, y: 40, x2: 60, y2: 50}
      ];
      mapData.removeData();
      expect(mapData.dataSets.length).toEqual(1);
    });

    it("should load data", function() {
      callback = function() {};
      spyOn(mapData, "isDataSetLoaded").and.returnValue(true);

      mapData.loadData(callback);
      expect(mapData.isDataSetLoaded).toHaveBeenCalled();
      expect(mapData.isDataSetLoaded.calls.count()).toEqual(9);
      expect(mapData.isDataSetLoaded.calls.argsFor(0)).toEqual([20, 40]);
      expect(mapData.isDataSetLoaded.calls.argsFor(1)).toEqual([20, 50]);
      expect(mapData.isDataSetLoaded.calls.argsFor(2)).toEqual([20, 60]);
      expect(mapData.isDataSetLoaded.calls.argsFor(3)).toEqual([30, 40]);
      expect(mapData.isDataSetLoaded.calls.argsFor(4)).toEqual([30, 50]);
      expect(mapData.isDataSetLoaded.calls.argsFor(5)).toEqual([30, 60]);
      expect(mapData.isDataSetLoaded.calls.argsFor(6)).toEqual([40, 40]);
      expect(mapData.isDataSetLoaded.calls.argsFor(7)).toEqual([40, 50]);
      expect(mapData.isDataSetLoaded.calls.argsFor(8)).toEqual([40, 60]);
    });

  });

  describe("move map", function() {

    beforeEach(function() {
      mapData.setDataDimensions(11, 11);
      mapData.setDataPosition(5, 5); // position before moving
      callback = jasmine.createSpy('mapCallback');
      updateDataCall = spyOn(mapData, "updateData");
    });

    it("should set new position", function(){
      spyOn(mapData, "setDataPosition");
      mapData.mapMovedTo(2, 5, callback);
      expect(mapData.setDataPosition).toHaveBeenCalledWith(2, 5);
    });

    it("should remove data", function(){
      obsoleteData = {x: 20, y: 20, x2: 30, y2: 30}
      mapData.dataSets.push(obsoleteData);

      updateDataCall.and.callThrough();
      spyOn(mapData, "loadData");

      expect(mapData.dataSets.length).toEqual(2);
      mapData.mapMovedTo(2, 5, callback);
      expect(mapData.dataSets.length).toEqual(0);
    });

    it("should load new data", function() {
      spyOn(mapData, "isDataSetLoaded").and.returnValue(true);
      updateDataCall.and.callThrough();

      mapData.mapMovedTo(2, 5, callback);

      expect(mapData.isDataSetLoaded).toHaveBeenCalled();
      expect(mapData.isDataSetLoaded.calls.argsFor(0)).toEqual([-10, 0]);
      expect(mapData.isDataSetLoaded.calls.argsFor(1)).toEqual([-10, 10]);
      expect(mapData.isDataSetLoaded.calls.argsFor(2)).toEqual([-10, 20]);
      expect(mapData.isDataSetLoaded.calls.argsFor(3)).toEqual([0, 0]);
      expect(mapData.isDataSetLoaded.calls.argsFor(4)).toEqual([0, 10]);
      expect(mapData.isDataSetLoaded.calls.argsFor(5)).toEqual([0, 20]);
      expect(mapData.isDataSetLoaded.calls.argsFor(6)).toEqual([10, 0]);
      expect(mapData.isDataSetLoaded.calls.argsFor(7)).toEqual([10, 10]);
      expect(mapData.isDataSetLoaded.calls.argsFor(8)).toEqual([10, 20]);
    });

    it("should call parent with delta", function() {
      mapData.mapMovedTo(2, 5, callback);
      expect(callback).toHaveBeenCalledWith(-3, 0);
    });

  });

});
