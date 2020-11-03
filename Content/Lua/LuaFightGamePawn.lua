local EMovementMode = import("EMovementMode")
local EChrState = require("Enum/EChrState")

local LuaFightGamePawn = {}

-- override event from blueprint
function LuaFightGamePawn:ReceiveBeginPlay()
    self.bCanEverTick = true
    -- set bCanBeDamaged property in parent
    self.bCanBeDamaged = false

    -- 输入
    self.MoveForward = 0.0
    self.GuardInput = false
    self.optionInput = false

    -- 统计
    self.HP = 200
    self.MaxHP = 200

    -- 数据
    self.state = EChrState.READY
    self.LinkBuffer = nil
    self.Dead = false

    -- 其他
    self.FaceToEnemy = false

    print("LuaFightGamePawn:ReceiveBeginPlay")
    print(self.MoveForward)
    print(self.CharacterMovement)

    print(self.AnimationList.Idle)
    print(self.AnimationList.Run)

    print(self:InAir())
    -- slua.dumpUObjects(EMovementMode)
    -- Dump(EMovementMode)

    self:PlayAnimMontage(self.MontageList.Hurt_Montage, 1, "")
end


function LuaFightGamePawn:SetupPlayerInputComponent(input)
    print("LuaFightGamePawn:SetupPlayerInputComponent")
end


function LuaFightGamePawn:InAir()
    return self.CharacterMovement ~= EMovementMode.MOVE_Walking
end

-- override event from blueprint
function LuaFightGamePawn:ReceiveEndPlay(reason)
    -- print("LuaFightGamePawn:ReceiveEndPlay")
end

function LuaFightGamePawn:Tick(dt)
    -- -- print("LuaFightGamePawn:Tick",self,dt)
    -- -- call actor function
    -- local pos = self:K2_GetActorLocation()
    -- -- can pass self as Actor*
    -- local dist = self:GetHorizontalDistanceTo(self)
    -- -- print("LuaFightGamePawn pos",pos,dist)
end

function LuaFightGamePawn:LookAtMovement()
end

function LuaFightGamePawn:LookAtEnemy()
end

-- Event Graph
function LuaFightGamePawn:CanBackDash()
end

---
-- @param delay:boolean  是否延迟
-- @return nil
function LuaFightGamePawn:ResetLootAtEnemy(delay)
    if delay then
    else
    end
end


function LuaFightGamePawn:RotateCondition(actor)
    -- actor:


end





-- Jump

return LuaFightGamePawn
