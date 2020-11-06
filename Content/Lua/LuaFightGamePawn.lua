local EMovementMode = import("EMovementMode")
local EMontagePlayReturnType = import("EMontagePlayReturnType")
local ECollisionResponse = import("ECollisionResponse")
local EChrState = require("Enum/EChrState")

local LuaFightGamePawn = {}

-- override event from blueprint
function LuaFightGamePawn:ReceiveBeginPlay()
    self.bCanEverTick = true
    -- set bCanBeDamaged property in parent
    self.bCanBeDamaged = false

    -- self.CharacterMovement = EMovementMode.
    -- 输入
    self.MoveRight = 0.0
    self.MoveForward = 0.0
    self.GuardInput = true
    self.optionInput = false
    -- self.CharacterMovement = EMovementMode.MOVE_None
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


    -- local montage = FightGameMontageList()
    -- local MontageListStruct = slua.loadObject("/Game/HitBoxMaker/DemoFightGame/Blueprints/Res/Structure/FightGameMontageList.FightGameMontageList")
    -- local struct = MontageListStruct();
    -- print(struct.Hurt)
    -- print(self.MoveForward)
    -- print(self.CharacterMovement)

    -- print(self.AnimationList.Idle)
    -- print(self.AnimationList.Run)

    -- print(self:InAir())
    -- slua.dumpUObjects(EMovementMode)
    -- Dump(EMovementMode)

    self.jumphandle = self.OnJump:Add(function(value, name)self:Jump()end)
    self.attackahandle = self.OnAttackA:Add(function(value, name)self:AttackA()end)
    self.attackbhandle = self.OnAttackB:Add(function(value, name)self:AttackB()end)
    self.movehandle = self.OnMoveRight:Add(function(axis, name)self:Move(axis)end)
    self.optionhandle = self.OnOption:Add(function(press)self:Option(press)end)
    
    -- slua.dumpUObjects(self.MontageList)
    -- self.Super.InputComponent:BindAction("Up", IE_Pressed, self,self.Run);

    -- local str = slua.dumpUObjects(self.MontageList)
    -- print(str)
    print(self.MontageList.Hurt)
    self.abc = 0
    local animInstance = self.Mesh:GetAnimInstance()
    animInstance.OnMontageStarted:Add(Handler(self,self.OnMontageStarted))
    animInstance.OnMontageBlendingOut:Add(Handler(self,self.OnMontageBlendingOut))
    animInstance.OnMontageEnded :Add(Handler(self,self.OnMontageEnded))
    animInstance.OnAllMontageInstancesEnded :Add(Handler(self,self.OnAllMontageInstancesEnded))

    animInstance.OnPlayMontageNotifyBegin:	Add(Handler(self,self.OnPlayMontageNotifyBegin))
    animInstance.OnPlayMontageNotifyEnd:Add(Handler(self,self.OnPlayMontageNotifyEnd))

    self:PlayAnimMontage(self.MontageList.Hurt,1,"")
end

function LuaFightGamePawn:Jump()
    print("LuaFightGamePawn:Jump")

    if not self:CanJump() then 
        return
    end     
    
    self.state = EChrState.BUSY

    -- print(self.MontageList.JumpMontage)

    self.OnFire:Remove(self.handle)
    self:PlayAnimMontage(self.MontageList.JumpMontage, 1, "")
    self.abc = self.abc  +1

    local animInstance = self.Mesh:GetAnimInstance()
    animInstance.OnMontageStarted:Add(Handler(self,self.OnMontageStarted))
    -- print(abc)

    -- local animInstance = self.Mesh:GetAnimInstance()
    -- animInstance:Montage_Play(self.MontageList.JumpMontage,1.0, EMontagePlayReturnType.MontageLength,0,false)


    -- self:CallAction("BackDash", false)

end

function LuaFightGamePawn:CanJump()
    if self.state ~= EChrState.READY then
        return false
    end

    if self:InAir() then
        return false
    end

    return true
end

function LuaFightGamePawn:AttackA()
    print("LuaFightGamePawn:AttackA  ")
end

function LuaFightGamePawn:AttackB()
    print("LuaFightGamePawn:AttackB  ")
end

function LuaFightGamePawn:Move(axis)
    -- print("LuaFightGamePawn:Move  "..axis)

    self.MoveRight = axis
    if self.MoveRight == 0.0 then
        return
    end

    local forward = self:GetActorForwardVector()
    if not forward:Equals(FVector(0,1,0),0.33333) then
        axis = -axis
    end
    self.MoveForward = axis


    if self.MoveForward < 0.0 then
        self:BashDash()
    end
end


function LuaFightGamePawn:CallMoveForward()

end

function LuaFightGamePawn:BashDash()
    if self:InAir() then
        return  
    end

    if not self.GuardInput then
        return
    end

    if self.state ~= EChrState.READY then
        return
    end


    self:CallAction("BackDash",false)
    
end


function LuaFightGamePawn:CallAction(action,force)
    if not self:CanUseAction(action, force) then
        return
    end
    
    self.state = EChrState.BUSY
    local montage = self.ActionList:Get(action)
    -- local animInstance = self.Mesh:GetAnimInstance()
    -- animInstance:Montage_Play(montage,1.0, EMontagePlayReturnType.MontageLength,0,false)

    

    self:PlayAnimMontage(montage, 1, "")
    self.abc = self.abc  +1
    -- print(montage,animInstance);

end

function LuaFightGamePawn:OnMontageBlendingOut(a,b,c)
    print(self.abc,"OnMontageBlendingOut",a,b,c)

    
end

function LuaFightGamePawn:OnMontageEnded(a,b,c)
    print(self.abc,"OnMontageEnded",a,b,c)
    self.state = EChrState.READY
end


function LuaFightGamePawn:OnAllMontageInstancesEnded(a,b,c)
    print(self.abc,"OnAllMontageInstancesEnded",a,b,c)
end


function LuaFightGamePawn:OnPlayMontageNotifyBegin(a,b,c)
    print(self.abc,"OnPlayMontageNotifyBegin",a,b,c)
end

function LuaFightGamePawn:OnPlayMontageNotifyEnd(a,b,c)
    print(self.abc,"OnPlayMontageNotifyEnd",a,b,c)
end




function LuaFightGamePawn:CanUseAction(action,force)

    local item = self.ActionList:Get(action)
    if item == nil then
        return false
    end 

    if not force and self.state ~= EChrState.READY then
        return false
    end

    self.LinkBuffer = action
    return true
end

function LuaFightGamePawn:ActionMulticast(montage)


end


function LuaFightGamePawn:Option(press)
    print("LuaFightGamePawn:Option  ",press)
end

function LuaFightGamePawn:Run()
end

function LuaFightGamePawn:ReceiveSetupPlayerInputComponent(input)
    print("LuaFightGamePawn:SetupPlayerInputComponent")
end

function LuaFightGamePawn:InAir()
    return self.CharacterMovement == EMovementMode.MOVE_Flying
end

-- override event from blueprint
function LuaFightGamePawn:ReceiveEndPlay(reason)
    self.Super:ReceiveEndPlay(reason)
    -- print("LuaFightGamePawn:ReceiveEndPlay")
end

function LuaFightGamePawn:Tick(dt)
    self.Super:Tick(dt)
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

function LuaFightGamePawn:ReceiveAttackA()
    -- actor:
    print("LuaFightGamePawn:AttackA")
end

function LuaFightGamePawn:ReceiveAttackB()
    -- actor:
    print("LuaFightGamePawn:AttackB")
end

function LuaFightGamePawn:ReceiveHit(a, b, c, d, e, f, g, h)
    self.Super:ReceiveHit(a, b, c, d, e, f, g, h)

    -- print("LuaFightGamePawn:ReceiveHit")
end
-- @param controller AController
function LuaFightGamePawn:ReceiveProssessed(controller)
    print("LuaFightGamePawn:ReceiveProssessed")
end

-- @params(EMovementMode, EMovementMode, unsigned char, unsigned char)
function LuaFightGamePawn:K2_OnMovementModeChanged()
    print("LuaFightGamePawn:K2_OnMovementModeChanged")
end

function LuaFightGamePawn:ProcessUserConstructionScript()
    print("LuaFightGamePawn:ProcessUserConstructionStript")
end

--#2	0x0000000103b221f2 in AActor::ReceiveActorBeginOverlap(AActor*) ()
function LuaFightGamePawn:ReceiveActorBeginOverlap(actor)
    self.Super:ReceiveActorBeginOverlap(actor)
    print("LuaFightGamePawn:ReceiveActorBeginOverlap")
end

-- Jump

function LuaFightGamePawn:SwitchAirCollision(air)

    local rep = air and ECollisionResponse.ECR_Overlap or ECollisionResponse.ECR_Block
    local type = air and ECollisionEnabled.QueryAndPhysics or ECollisionEnabled.NoCollision

    self.CapsuleComponent:SetCollisionResponseToChannel(ECollisionChannel.ECC_Pawn,rep)
    self.AirCollision:SetCollisionEnabled(type);

end



return LuaFightGamePawn
