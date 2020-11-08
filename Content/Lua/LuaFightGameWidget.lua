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

function LuaFightGameWidget:SetPawns(pawn1,pawn2)
	self.pawn1 = pawn1
	self.pawn2 = pawn2
end


function LuaFightGameWidget:ReceiveBeginPlay()
    -- call super ReceiveBeginPlay
    self.Super:ReceiveBeginPlay()
    print("LuaFightGameWidget:ReceiveBeginPlay")
end

function LuaFightGameWidget:Tick(geom,dt)
    self.Super:Tick(geom,dt)
	-- print("LuaFightGameWidget:Tick", self, geom,dt)
	
	if self.pawn1 then
		self.HpBar1:SetPercent(self.pawn1.HP / self.pawn1.MaxHP )
	end

	if self.pawn2 then
		self.HpBar2:SetPercent(self.pawn2.HP / self.pawn2.MaxHP )
	end
end


function LuaFightGameWidget:OnDestroy()

end







return LuaFightGameWidget