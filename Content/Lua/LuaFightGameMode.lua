require("LuaPanda").start("127.0.0.1", 8818)
require("Class")

local GameMode ={}

-- override event from blueprint
function GameMode:ReceiveBeginPlay()
    self.Super:ReceiveBeginPlay()
    print("GameMode:ReceiveBeginPlay")
end

-- override event from blueprint
function GameMode:ReceiveEndPlay(reason)
    self.Super:ReceiveEndPlay(reason)
    print("GameMode:ReceiveEndPlay")
end

function GameMode:Tick(dt)
    self.Super:Tick(dt)
    print("GameMode:Tick",self,dt)
end
--#2	0x0000000103c53380 in AGameModeBase::FindPlayerStart(AController*, FString const&) ()

function GameMode:FindPlayerStart(controlller,str)
    self.Super:FindPlayerStart(controlller,str)
    print("GameMode:"..str)
end
--#2	0x0000000103c532dd in AGameModeBase::ChoosePlayerStart(AController*) ()

function GameMode:ChoosePlayerStart(controlller)
    self.Super:ChoosePlayerStart(controlller)
    print("GameMode:ChoosePlayerStart")
end

--#2	0x0000000103c5340d in AGameModeBase::GetDefaultPawnClassForController(AController*) ()

function GameMode:GetDefaultPawnClassForController(controlller)
    self.Super:GetDefaultPawnClassForController(controlller)
    print("GameMode:GetDefaultPawnClassForController")
end

--#2	0x0000000103c536f9 in AGameModeBase::MustSpectate(APlayerController*) const ()

function GameMode:MustSpectate(controlller)
    self.Super:MustSpectate(controlller)
    print("GameMode:MustSpectate")
end


--#2	0x0000000103c53572 in AGameModeBase::K2_OnChangeName(AController*, FString const&, bool) ()

function GameMode:K2_OnChangeName(controlller,str,flag)
    self.Super:K2_OnChangeName(controlller,str,flag)
    print("GameMode:K2_OnChangeName")
end

--#2	0x0000000103c53492 in AGameModeBase::InitializeHUDForPlayer(APlayerController*) ()

function GameMode:InitializeHUDForPlayer(controlller)
    self.Super:InitializeHUDForPlayer(controlller)
    print("GameMode:InitializeHUDForPlayer")
end

return GameMode