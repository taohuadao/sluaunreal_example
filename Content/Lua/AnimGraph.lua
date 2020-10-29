require("Class")



local AnimGraph = Class("AnimGraph");



function AnimGraph:ctor(pawn)
    assert(pawn ~= nil, "pawn must not nil")
    self.pawn = pawn

    self.animationList = pawn.animationList
    self.moveForward = pawn.moveForward
    self.guard = pawn.guard
    self.falling = pawn.falling



end


function AnimGraph:Updata()

    local moveForward = self.pawn.moveForward
    local guard = self.pawn.guard
    local falling = self.pawn:InAir()
    local Owner = moveForward > 0 and guard
    



end




return AnimGraph