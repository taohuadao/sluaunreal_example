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






return GameMode