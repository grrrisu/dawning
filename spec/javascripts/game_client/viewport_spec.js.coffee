describe 'Viewport', ->

  beforeEach ->
    @map = new Map()
    @map.setFieldWidth(5)
    @map.setWorldSize({width: 50, height: 100})
    @viewport = new Viewport(55, 11, @map)
    spyOn(@viewport, 'update_map')

  describe 'checkBoundaries', ->

    it "exiting on the left bottom", ->
      pos = @viewport.checkBoundaries({x: 7, y: 7})
      expect(pos.x).toEqual(0)
      expect(pos.y).toEqual(0)

    it "exiting on the right top", ->
      pos = @viewport.checkBoundaries({x: - 5 * 50, y: - 5 * 100})
      expect(pos.x).toEqual(0)
      expect(pos.y).toEqual(0)
