local actor={}

-- override event from blueprint
function actor:ReceiveBeginPlay()
    self.bCanEverTick = true
    -- set bCanBeDamaged property in parent
    self.bCanBeDamaged = false
    print("LuaFightGamePawn:ReceiveBeginPlay")
    print(self.MoveForward)

    print(self.AnimationList.Idle)
    print(self.AnimationList.Run)

end

-- override event from blueprint
function actor:ReceiveEndPlay(reason)
    -- print("LuaFightGamePawn:ReceiveEndPlay")
end

function actor:Tick(dt)
    -- print("LuaFightGamePawn:Tick",self,dt)
    -- call actor function
    local pos = self:K2_GetActorLocation()
    -- can pass self as Actor*
    local dist = self:GetHorizontalDistanceTo(self)
    -- print("LuaFightGamePawn pos",pos,dist)
end

return actor