describe 'Viewport', ->

  beforeEach ->
    @map = new Game.Map()
    @map.setFieldWidth(5)
    @map.setWorldSize({width: 50, height: 100})
    @map.mapWidth()
    @map.mapHeight()
    @viewport = new Game.Viewport(55, 11, @map)
    spyOn(@viewport, 'update_map')

  describe 'checkBoundaries', ->

    it "within boundaries", ->
      pos = @viewport.checkBoundaries({x: -20, y: -50})
      expect(pos.x).toEqual(-20)
      expect(pos.y).toEqual(-50)
      expect(@viewport.rx).toEqual(4)
      expect(@viewport.ry).toEqual(10)


    it "exiting on the left bottom", ->
      pos = @viewport.checkBoundaries({x: 7, y: 7})
      expect(pos.x).toEqual(0)
      expect(pos.y).toEqual(0)
      expect(@viewport.rx).toEqual(0)
      expect(@viewport.ry).toEqual(0)

    it "exiting on the right top", ->
      pos = @viewport.checkBoundaries({x: - 5 * 50, y: - 5 * 100})
      expect(pos.x).toEqual(-5 * 50 + 55 + 1) # = -194 : map.width - viewport.width - 1
      expect(pos.y).toEqual(-5 * 100 + 55 + 1) # = -444
      expect(@viewport.rx).toEqual(50 - 11 -1) # 38
      expect(@viewport.ry).toEqual(100 - 11 -1) # 88


    describe 'with zoom 2', ->

      beforeEach ->
        #client.presenter.stage = jasmine.createSpyObj('stage', ['setAttrs'])
        #@viewport.setZoom(2)
        @viewport.zoom = 2

      it "within boundaries", ->
        pos = @viewport.checkBoundaries({x: -10, y: -25})
        expect(pos.x).toEqual(-10)
        expect(pos.y).toEqual(-25)
        expect(@viewport.rx).toEqual(4)
        expect(@viewport.ry).toEqual(10)

      it "exiting on the left bottom", ->
        pos = @viewport.checkBoundaries({x: 7, y: 7})
        expect(pos.x).toEqual(0)
        expect(pos.y).toEqual(0)
        expect(@viewport.rx).toEqual(0)
        expect(@viewport.ry).toEqual(0)

      it "exiting on the right top", ->
        pos = @viewport.checkBoundaries({x: - 2.5 * 50, y: - 2.5 * 100})
        expect(pos.x).toEqual(-2.5 * 50 + 55 + 1) # map.width/z - viewport.width - 1
        expect(pos.y).toEqual(-2.5 * 100 + 55 + 1)
        expect(@viewport.rx).toEqual(50 - 22 -1)
        expect(@viewport.ry).toEqual(100 - 22 -1)
