local WBL = import("WidgetBlueprintLibrary")
local UIManager = require("UIManager")

local LuaFightGameWidget={}


function LuaFightGameWidget:Initialize() 
    print(self.CounterTx)
    self.bHasScriptImplementedTick = true

    self.Update = function(hpbar,hp,hpmax)
        print(hpbar,hp,hpmax)
    end
    
    UIManager.EventDispatcher:AddListener("damage",self.Update)


end




function LuaFightGameWidget:ReceiveBeginPlay()
    -- call super ReceiveBeginPlay
    self.Super:ReceiveBeginPlay()
    print("LuaFightGameWidget:ReceiveBeginPlay")
end

function LuaFightGameWidget:Tick(geom,dt)
    self.Super:Tick(geom,dt)
    -- print("LuaFightGameWidget:Tick", self, geom,dt)
end


function LuaFightGameWidget:OnDestroy()

end







return LuaFightGameWidget