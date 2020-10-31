


local EMovementMode = import('EMovementMode');
local LuaFightGamePawn={}



function PrintTable(tbl)
    for k,v in pairs(tbl) do
        print(k.."  "..v);
    end
end



-- override event from blueprint
function LuaFightGamePawn:ReceiveBeginPlay()
    self.bCanEverTick = true
    -- set bCanBeDamaged property in parent
    self.bCanBeDamaged = false

    

    self.HP = self.MaxHP

    print(self.HP)

    print("LuaFightGamePawn:ReceiveBeginPlay")
    print(self.MoveForward)
    print(self.CharacterMovement)
    

    print(self.AnimationList.Idle)
    print(self.AnimationList.Run)

  

    print(self:InAir())
    PrintTable(EMovementMode)

    self:PlayAnimMontage(self.MontageList.Hurt_Montage,1,"")

    

end

function LuaFightGamePawn:InAir()

    return self.CharacterMovement ~= EMovementMode.MOVE_Walking

end

-- override event from blueprint
function LuaFightGamePawn:ReceiveEndPlay(reason)
    -- print("LuaFightGamePawn:ReceiveEndPlay")
end

function LuaFightGamePawn:Tick(dt)
    -- print("LuaFightGamePawn:Tick",self,dt)
    -- call actor function
    local pos = self:K2_GetActorLocation()
    -- can pass self as Actor*
    local dist = self:GetHorizontalDistanceTo(self)
    -- print("LuaFightGamePawn pos",pos,dist)
end

return LuaFightGamePawn