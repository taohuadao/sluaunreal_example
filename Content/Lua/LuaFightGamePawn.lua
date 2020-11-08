local EMovementMode = import("EMovementMode")
local EMontagePlayReturnType = import("EMontagePlayReturnType")
local ECollisionResponse = import("ECollisionResponse")
local EChrState = require("Enum/EChrState")
local ECollisionEnabled = import("ECollisionEnabled")
local ECollisionChannel = import("ECollisionChannel")
local EDrawDebugTrace = import("EDrawDebugTrace")
local ETeleportType = import("ETeleportType")
local EPSCPoolMethod = import("EPSCPoolMethod")

local GameplayStatics = import "GameplayStatics"

local BlueprintFunctionLibrary = import("BlueprintFunctionLibrary")
local KismetMathLibrary = import("KismetMathLibrary")

print(BlueprintFunctionLibrary)
print(KismetMathLibrary)

local LuaFightGamePawn = {}

-- override event from blueprint
function LuaFightGamePawn:ReceiveBeginPlay()
    self.Super:ReceiveBeginPlay()
    print(slua)
    self.bCanEverTick = true
    -- set bCanBeDamaged property in parent
    self.bCanBeDamaged = false

    -- self.CharacterMovement = EMovementMode.
    -- 输入

    -- print("MoveRight",self.MoveRight)
    -- print("MoveForward",self.MoveForward)
    -- print("GuardInput",self.GuardInput)
    -- print("OptionInput",self.OptionInput)

    self.MoveRight = 0.0
    self.MoveForward = 0.0
    self.GuardInput = false
    self.OptionInput = false
    -- self.CharacterMovement = EMovementMode.MOVE_None
    -- 统计
    self.HP = 200
    self.MaxHP = 200

    -- 数据
    self.state = EChrState.READY
    self.LinkBuffer = nil
    self.Dead = false

    -- 其他
    self.FaceToEnemy = true

    self.Enemy = nil

    print("LuaFightGamePawn:ReceiveBeginPlay")

    -- local montage = FightGameMontageList()
    local MontageListStruct =
        slua.loadObject(
        "/Game/HitBoxMaker/DemoFightGame/Blueprints/Res/Structure/FightGameMontageList.FightGameMontageList"
    )
    local struct = MontageListStruct()
    print(struct.Hurt)
    -- print(self.MoveForward)
    -- print(self.CharacterMovement)

    -- print(self.AnimationList.Idle)
    -- print(self.AnimationList.Run)

    local FeedBack = slua.loadObject("/Game/HitBoxMaker/HitBoxMaker/FeedBackEvent/FeedBack.FeedBack")
    local FeedBackList = slua.loadObject("/Game/HitBoxMaker/HitBoxMaker/FeedBackEvent/FeedBackList.FeedBackList")
    self.FeedBack = FeedBack()

    local sfx = slua.loadObject("/Game/HitBoxMaker/Demo2d/Res/VFX/SmashFX.SmashFX")
    -- self.FeedBackList = FeedBackList()
    print("abc", sfx)

    local callfeedback =
        slua.loadObject("Blueprint'/Game/HitBoxMaker/HitBoxMaker/FeedBackEvent/CallFeedBack.CallFeedBack'")

    self.CallFeedBack = callfeedback
    print(callfeedback)

    -- print(self:InAir())
    -- slua.dumpUObjects(EMovementMode)
    -- Dump(EMovementMode)

    self.jumphandle = self.OnJump:Add(Handler(self, self.Jump))
    self.attackahandle = self.OnAttackA:Add(Handler(self, self.AttackA))
    self.attackbhandle = self.OnAttackB:Add(Handler(self, self.AttackB))
    self.movehandle = self.OnMoveRight:Add(Handler(self, self.Move))
    self.optionhandle = self.OnOption:Add(Handler(self, self.Option))
    self.guardnhandle = self.OnGuard:Add(Handler(self, self.SetGuardInput))

    -- slua.dumpUObjects(self.MontageList)
    -- self.Super.InputComponent:BindAction("Up", IE_Pressed, self,self.Run);

    -- local str = slua.dumpUObjects(self.MontageList)
    -- print(str)
    -- print(self.MontageList.Hurt)
    self.abc = 0
    local animInstance = self.Mesh:GetAnimInstance()
    animInstance.OnMontageStarted:Add(Handler(self, self.OnMontageStarted))
    animInstance.OnMontageBlendingOut:Add(Handler(self, self.OnMontageBlendingOut))
    animInstance.OnMontageEnded:Add(Handler(self, self.OnMontageEnded))
    animInstance.OnAllMontageInstancesEnded:Add(Handler(self, self.OnAllMontageInstancesEnded))

    -- print(animInstance.OnPlayMontageNotifyBegin)
    -- animInstance.OnMontageNotifyBegin = Handler(self,self.OnPlayMontageNotifyBegin)
    -- animInstance.OnMontageNotifyBegin:Add(Handler(self,self.OnPlayMontageNotifyBegin))
    -- animInstance.OnPlayMontageNotifyEnd:Add(Handler(self,self.OnPlayMontageNotifyEnd))

    -- self.OnLanded:Add(Handler(self, self.Landed))

    -- self:PlayAnimMontage(self.MontageList.Hurt, 1, "")
end

function LuaFightGamePawn:SetMoveForward(MoveForward)
    self.MoveForward = MoveForward
end
function LuaFightGamePawn:GetMoveForward()
    return self.MoveForward
end

function LuaFightGamePawn:GetOption()
    return self.OptionInput
end

function LuaFightGamePawn:GetGuard()
    return self.GuardInput
end

function LuaFightGamePawn:SetEnemy(enemy)
    self.Enemy = enemy
end

function LuaFightGamePawn:OnLanded(hit)
    print("OnLanded", hit)
    self.LinkBuffer = nil

    local transform = self:LandedDeedBackTransform(hit)
end

function LuaFightGamePawn:LandedDeedBackTransform(hit)
end

function LuaFightGamePawn:Jump()
    print("LuaFightGamePawn:Jump")

    if self.state ~= EChrState.READY then
        return
    end

    if self:InAir() then
        return
    end

    self.state = EChrState.BUSY

    -- if not self:CanJump() then
    --     return
    -- end

    -- print(self.MontageList.JumpMontage)
    -- self.OnFire:Remove(self.handle)
    self:PlayAnimMontage(self.MontageList.JumpMontage, 1, "")
    self.abc = self.abc + 1

    self:SwitchAirCollision(true)

    local forward = self:GetActorForwardVector()

    print("forward", forward:ToString())
    local impulse = FVector(0, 0, 600) + forward * 250 * self.MoveForward
    print("impulse", impulse:ToString())
    self.CharacterMovement:AddImpulse(impulse, true)

    -- local animInstance = self.Mesh:GetAnimInstance()
    -- animInstance.OnMontageStarted:Add(Handler(self,self.OnMontageStarted))
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
    if self:InAir() then
        self:CallAction("AirPunch", false)
    else
        print("GuardInput ", self.GuardInput, "OptionInput ", self.OptionInput)

        if self.GuardInput then
            self:CallAction("fUppercut", false)
        else
            if self.OptionInput then
                self:CallAction("Uppercut", false)
            else
                self:CallAction("Punch1", false)
            end
        end
    end
end

function LuaFightGamePawn:AttackB()
    print("LuaFightGamePawn:AttackB  ")

    if self:InAir() then
        self:CallAction("AirKick", false)
    else
        print("GuardInput ", self.GuardInput, "OptionInput ", self.OptionInput)

        if self.GuardInput then
            self:CallAction("kick2", false)
        else
            self:CallAction("kick1", false)
        end
    end
end

function LuaFightGamePawn:Move(axis)
    -- print("LuaFightGamePawn:Move  "..axis)

    self.MoveRight = axis
    local forward = self:GetActorForwardVector()
    if not forward:Equals(FVector(0, 1, 0), 0.33333) then
        axis = -axis
    end

    self:SetMoveForward(axis)

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

    self:CallAction("BackDash", false)
end

function LuaFightGamePawn:CallAction(action, force)
    if not self:CanUseAction(action, force) then
        return
    end

    self.state = EChrState.BUSY
    local montage = self.ActionList:Get(action)
    -- local animInstance = self.Mesh:GetAnimInstance()
    -- animInstance:Montage_Play(montage,1.0, EMontagePlayReturnType.MontageLength,0,false)

    self:PlayAnimMontage(montage, 1, "")
    self.abc = self.abc + 1
    -- print(montage,animInstance);
end

function LuaFightGamePawn:OnMontageStarted(a, b, c)
    print(self.abc, "OnMontageStarted", a, b, c)
end

function LuaFightGamePawn:OnMontageBlendingOut(a, b, c)
    print(self.abc, "OnMontageBlendingOut", a, b, c)
end

function LuaFightGamePawn:OnMontageEnded(a, b, c)
    print(self.abc, "OnMontageEnded", a, b, c)
    self.state = EChrState.READY
end

function LuaFightGamePawn:OnAllMontageInstancesEnded(a, b, c)
    print(self.abc, "OnAllMontageInstancesEnded", a, b, c)
end

function LuaFightGamePawn:OnPlayMontageNotifyBegin(a, b, c)
    print(self.abc, "OnPlayMontageNotifyBegin", a, b, c)
end

function LuaFightGamePawn:OnPlayMontageNotifyEnd(a, b, c)
    print(self.abc, "OnPlayMontageNotifyEnd", a, b, c)
end

function LuaFightGamePawn:CanUseAction(action, force)
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
    print("LuaFightGamePawn:Option  ", press)
    self.OptionInput = press
end

function LuaFightGamePawn:SetGuardInput(press)
    print("LuaFightGamePawn:GuardInput  ", press)
    self.GuardInput = press
end

function LuaFightGamePawn:Run()
end

function LuaFightGamePawn:ReceiveSetupPlayerInputComponent(input)
    print("LuaFightGamePawn:SetupPlayerInputComponent")
end

-- function LuaFightGamePawn:InAir()
--     return self.CharacterMovement.MovementMode ~= EMovementMode.MOVE_Walking

--     -- return self.CharacterMovement == EMovementMode.MOVE_Flying
-- end

-- override event from blueprint
function LuaFightGamePawn:ReceiveEndPlay(reason)
    self.Super:ReceiveEndPlay(reason)
    -- print("LuaFightGamePawn:ReceiveEndPlay")
end

function LuaFightGamePawn:Tick(dt)
    self.Super:Tick(dt)

    if not self.FaceToEnemy then
        return
    end
    self:LookAtEnemy()
    -- self:LookAtMovement()

    -- self:TracePawn()
end

--

--[[
	UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="WorldStatic"))
	TEnumAsByte<enum ECollisionResponse> WorldStatic;    // 0

	UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="WorldDynamic"))
	TEnumAsByte<enum ECollisionResponse> WorldDynamic;    // 1.

	UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="Pawn"))
	TEnumAsByte<enum ECollisionResponse> Pawn;    		// 2

	UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="Visibility"))
	TEnumAsByte<enum ECollisionResponse> Visibility;    // 3

	UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="Camera"))
	TEnumAsByte<enum ECollisionResponse> Camera;    // 4

	UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="PhysicsBody"))
	TEnumAsByte<enum ECollisionResponse> PhysicsBody;    // 5

	UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="Vehicle"))
	TEnumAsByte<enum ECollisionResponse> Vehicle;    // 6

	UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="Destructible"))
	TEnumAsByte<enum ECollisionResponse> Destructible;    // 7
]] function LuaFightGamePawn:TracePawn()
    local locationa = self:K2_GetActorLocation()
    local locationb = locationa + FVector(0, 0, 1)

    local hit =
        BlueprintFunctionLibrary.SphereTraceForObjects(
        self,
        locationa,
        locationb,
        1250,
        {1, 6},
        false,
        nil,
        EDrawDebugTrace.None
    )
    print(hit)
end

function LuaFightGamePawn:CameraToEnemy()
end

function LuaFightGamePawn:LookAtMovement()
    if self.state ~= EChrState.READY then
        return
    end

    if self.Dead then
        return
    end

    if self.MoveRight < 0.0 then
        self:SetActorRotation(true)
    elseif self.MoveRight > 0.0 then
        self:SetActorRotation(false)
    else
    end
end

function LuaFightGamePawn:LookAtEnemy()
    if self.state ~= EChrState.READY then
        return
    end

    if self.Dead then
        return
    end

    local location = self:K2_GetActorLocation()
    local locationEnemy = self.Enemy:K2_GetActorLocation()

    local delta = ((locationEnemy - location) * FVector(1, 1, 0))

    delta:Normalize(0.0001)

    local forward = self:GetActorForwardVector()
    local left = forward:Equals(FVector(0, 1, 0), 0.3333)

    if not delta:Equals(forward, 0.3333) then
        -- 需要转向

        print(delta:ToString())
        print(forward:ToString())
        print("需要转向")

        self:SetActorRotation(left)
    end
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
    print("LuaFightGamePawn:ReceiveProssessed start")

    local location = controller:GetControlRotation()

    print("LuaFightGamePawn:ReceiveProssessed ", location:ToString())

    print("LuaFightGamePawn:ReceiveProssessed end")
end

-- @params(EMovementMode, EMovementMode, unsigned char, unsigned char)
-- function ACharacter.K2_OnMovementModeChanged(PrevMovementMode, NewMovementMode, PrevCustomMode, NewCustomMode) end
function LuaFightGamePawn:K2_OnMovementModeChanged(PrevMovementMode, NewMovementMode, PrevCustomMode, NewCustomMode)
    print("LuaFightGamePawn:K2_OnMovementModeChanged")

    if NewMovementMode == EMovementMode.MOVE_Walking then
        self:SwitchAirCollision(false)
    else
        if NewMovementMode == EMovementMode.MOVE_Falling or NewMovementMode == EMovementMode.MOVE_Flying then
            self:SwitchAirCollision(true)
        end
    end
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

    self.CapsuleComponent:SetCollisionResponseToChannel(ECollisionChannel.ECC_Pawn, rep)
    self.AirCollision:SetCollisionEnabled(type)
end

function LuaFightGamePawn:ClearLink()
    self.LinkBuffer = nil
end

-- @param left boolean
function LuaFightGamePawn:SetActorRotation(left)
    -- print("SetActorRotation", left)

    local locationa = self:K2_GetActorLocation()
    local controller = self:GetController()
    if not controller then
        return
    end

    local turnleft = FVector(0, 0, -90)
    local turnright = FVector(0, 0, 90)

    local rotation = self:K2_GetActorRotation()

    -- print("rotation",rotation:ToString())

    if left then
        -- self:OnRotation(turnleft)
        -- self:K2_SetActorRotation(self,false,FVector(0, 0, -180))
        -- self:K2_SetActorLocationAndRotation(locationa, turnleft, false, 0, ETeleportType.None);
        controller:SetControlRotation(self, turnleft)
    else
        -- self:OnRotation(turnright)
        -- self:K2_SetActorRotation(self,false,FVector(0, 0, 0))
        -- self:K2_SetActorLocationAndRotation(self,locationa, turnleft, false, 0, ETeleportType.None);
        controller:SetControlRotation(self, turnright)
    end
end

function LuaFightGamePawn:ReceivePointDamage(
    Damage,
    DamageType,
    HitLocation,
    HitNormal,
    HitComponent,
    BoneName,
    ShotFromDirection,
    InstigatedBy,
    DamageCauser,
    HitInfo)
    if DamageType.bCausedByWorld then
        self:WorldDamage(Damage, HitLocation, HitNormal)
    else
        self:PawnDamage(Damage, HitLocation, HitNormal, DamageType)
    end
end

function LuaFightGamePawn:WorldDamage(Damage, HitLocation, HitDirection)
end

function LuaFightGamePawn:PawnDamage(Damage, HitLocation, HitDirection, HitType)
    if self.Dead then
        return
    end

    if self:IFBlock(HitLocation) then
        return
    end

    self.state = EChrState.DAMAGE

    local transform = KismetMathLibrary.Conv_VectorToTransform(HitLocation)

    -- local location = transform:GetLocation()
    -- local rotation = transform:Rotator()
    -- local scale = transform:GetScaled()

    -- KismetMathLibrary.BreakTransform(transform,location,rotation,scale)

    --[[

	Particle
	Sound
	Force
	Shake
	ShakeRadius
	Attached

	]]
    -- local Smash = self.DataTable:Get("Smash")

    --[[	static UParticleSystemComponent* SpawnEmitterAtLocation(
	const UObject* WorldContextObject, 
	UParticleSystem* EmitterTemplate, 
	FVector Location, FRotator Rotation = FRotator::ZeroRotator, 
	FVector Scale = FVector(1.f), 
	bool bAutoDestroy = true, 
	EPSCPoolMethod PoolingMethod = EPSCPoolMethod::None, 
	bool bAutoActivateSystem = true);]]
    --local world = self:GetWorld()
    --local sfx = slua.loadObject("/Game/HitBoxMaker/Demo2d/Res/VFX/SmashFX.SmashFX")

    -- GameplayStatics.SpawnEmitterAtLocation(world,sfx,HitLocation,self)
    --self.CallFeedBack.FeedBackPreset(self.FeedBackList,"Smash",transform,self,nil)

    if HitType.DamageTag == "LaunchUp" then
        self:PlayAnimMontage(self.MontageList.LaunchUp, 1, "")
        self:SwitchAirCollision(true)
    elseif HitType.DamageTag == "LaunchDown" then
        self:PlayAnimMontage(self.MontageList.LaunchDown, 1, "")
        self:SwitchAirCollision(true)
    else
        if self:InAir() then
            self:PlayAnimMontage(self.MontageList.HurtAir, 1, "")
        else
            self:PlayAnimMontage(self.MontageList.Hurt, 1, "")
        end
	end
	
	self:HurtDamage(Damage)
end

function LuaFightGamePawn:FeedBackPreset()
end

function LuaFightGamePawn:IFBlock(HitLocation)
    if self.state == EChrState.READY then
        if self.CharacterMovement.MovementMode == EMovementMode.MOVE_Walking and self.MoveRight == 0 and self.GuardInput then
            self:BlockImpact(HitLocation)
            return true
        end
    end

    return false
end

function LuaFightGamePawn:BlockImpact(HitLocation)
end

function LuaFightGamePawn:HurtDamage(damage)
    if self.HP > damage then
        self.HP = self.HP - damage
    else
        self.HP = self.MaxHP
    end
end

return LuaFightGamePawn
