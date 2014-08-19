no = false
yes = true

describe("Conway", function () {
  describe("outOfBounds", function () {
    it("should return true if a value is less than 0", function () {
      expect(outOfBounds([-1,0],3,3)).toBe(true)
      expect(outOfBounds([0,-1],3,3)).toBe(true)
      expect(outOfBounds([-2,-4],3,3)).toBe(true)
    })

    it("should return false if a value is in bounds", function () {
      expect(outOfBounds([2,0],3,3)).toBe(false)
      expect(outOfBounds([1,1],3,3)).toBe(false)
      expect(outOfBounds([0,2],3,3)).toBe(false)
    })

    it("should return true if a value is above bounds", function () {
      expect(outOfBounds([3,0],3,3)).toBe(false)
      expect(outOfBounds([3,3],3,3)).toBe(false)
      expect(outOfBounds([0,3],3,3)).toBe(false)
    })
  })

  describe("nextFromDead()", function () {})
  describe("nextFromLiving()",function () {})

  describe("nextGeneration()", function () {
    describe("cell is alive", function () {
      it("should stay alive if neighbors are between 2 and 3", function () {
        worlds = [
          [
            [no, no, no],
            [no, yes, no],
            [yes, yes, yes]
          ],
          [
            [yes, yes, yes],
            [no, yes, no],
            [no, no, no]
          ],
          [
            [yes, yes, no],
            [yes, yes, no],
            [no, no, no]
          ],
          // 2
          [
            [yes, no, no],
            [no, yes, no],
            [no, no, yes]
          ],
          [
            [yes, no, no],
            [yes, yes, no],
            [no, no, no]
          ]
        ]

        worlds.forEach(function (world ) {
          expect(nextGeneration(4, world)).toBe(true)
        })
      })

      it("should die if neighbors are less than 2 or greater than 3", function() {

        world = [
          no, no, yes,
          no, yes, yes,
          yes, yes, yes
        ]

        expect(nextGeneration(4, world)).toBe(false)
      })
    })

    describe("cell is dead", function () {
      it("should spawn a cell if neighbors are 3", function () {
        worlds = [
          [
            [yes, no, no],
            [no, no, yes],
            [no, no, yes]
          ],
          [
            [yes, no, no],
            [no, no, no],
            [no, yes, yes]
          ]
        ]

        worlds.forEach(function (world) {
          expect(nextGeneration(4,world)).toBe(true)
        })
      })

      it("should not spawn a cell if neighbors are not 3", function () {
        worlds = [
          [
            [no, no, no],
            [no, no, yes],
            [no, no, yes]
          ],
          [
            [yes, no, no],
            [yes, no, no],
            [yes, yes, yes]
          ]
        ]
        expect(nextGeneration(4, world)).toBe(false)
      })

    })
  })
})