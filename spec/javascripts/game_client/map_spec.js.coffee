describe 'Map', ->

  beforeEach ->
    @map = new Map()
    @map.setFieldWidth(5)
    #@map.setWorldSize(100)

  describe 'should calculate relative position', ->

    it "for 0, 0", ->
      rpos = @map.relativePosition(0,0)
      expect(rpos.x).toEqual(0)
      expect(rpos.y).toEqual(0)

    it "for 50, 100", ->
      rpos = @map.relativePosition(50,100)
      expect(rpos.x).toEqual(10)
      expect(rpos.y).toEqual(20)

    it "for 4, 6", ->
      rpos = @map.relativePosition(4,6)
      expect(rpos.x).toEqual(0)
      expect(rpos.y).toEqual(1)
