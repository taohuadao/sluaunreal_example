

local Controller={}

-- override event from blueprint
function Controller:ReceiveBeginPlay()
    self.Super:ReceiveBeginPlay()
    self.bCanEverTick = true
    print("Controller:ReceiveBeginPlay")
end

-- override event from blueprint
function Controller:ReceiveEndPlay(reason)
    self.Super:ReceiveEndPlay(reason)
    print("Controller:ReceiveEndPlay")
end

function Controller:Tick(dt)
    -- print("Controller:Tick",self,dt)
end

--#2	0x0000000103e224f2 in APlayerController::ClientRestart(APawn*) ()

function Controller:ClientRestart(pawn)
    self.Super:ClientRestart(pawn)
    print("Controller:ClientRestart")
    -- print("Controller:Tick",self,dt)
end

--#2	0x0000000103e23182 in APlayerController::ServerAcknowledgePossession(APawn*) ()
function Controller:ServerAcknowledgePossession(pawn)
    self.Super:ServerAcknowledgePossession(pawn)
    print("Controller:ServerAcknowledgePossession")
    -- print("Controller:Tick",self,dt)
end

--#2	0x0000000103bec162 in AController::ReceivePossess(APawn*) ()
function Controller:ReceivePossess(pawn)
    self.Super:ReceivePossess(pawn)
    print("Controller:ReceivePossess")
    -- print("Controller:Tick",self,dt)
end


--#2	0x0000000103bec1a2 in AController::ReceiveUnPossess(APawn*) ()

function Controller:ReceiveUnPossess(pawn)
    self.Super:ReceiveUnPossess(pawn)
    print("Controller:ReceiveUnPossess")
    -- print("Controller:Tick",self,dt)
end



--#2	0x0000000103e224f2 in APlayerController::ClientRestart(APawn*) ()
function Controller:ClientRestart(pawn)
    self.Super:ClientRestart(pawn)
    print("Controller:ClientRestart")
    -- print("Controller:Tick",self,dt)
end


--#2	0x0000000103419b3d in APlayerController::PlayerTick(float) ()

function Controller:PlayerTick(dt)
    self.Super:PlayerTick(dt)
    print("Controller:PlayerTick ",dt)
    -- print("Controller:Tick",self,dt)
end

return Controller