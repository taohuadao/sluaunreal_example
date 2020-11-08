
require("Class")





local GameplayStatics = import "GameplayStatics"
local EPropertyClass = import "EPropertyClass"
local Hud = {}

-- override event from blueprint
function Hud:ReceiveBeginPlay()
    self.Super:ReceiveBeginPlay()

    self.Pawn1 = nil
    self.Pawn2 = nil
    self.MainWidget = nil

    self:SetPawn()
    self:SetMainWidget()
    self:OpenMainWidget()

    print("Hud:ReceiveBeginPlay")
end

-- override event from blueprint
function Hud:ReceiveEndPlay(reason)
    self.Super:ReceiveEndPlay(reason)
    print("Hud:ReceiveEndPlay")
end

function Hud:Tick(dt)
    self.Super:Tick(dt)
    print("hud:Tick", self, dt)
end

function Hud:SetPawn()


    self.Pawn1 = self:GetOwningPawn()
    
    local world = self:GetWorld()
    local bpClass = slua.loadClass("Blueprint'/Game/HitBoxMaker/DemoFightGame/Lua/LuaFightGamePawn.LuaFightGamePawn'")
    local actors = slua.Array(EPropertyClass.Object,bpClass)
    local arr = GameplayStatics.GetAllActorsWithTag(world, "luaplayer2",actors)

    for i=0,arr:Num()-1 do
        print("arr item",i,arr:Get(i))
    end

    if arr:Num() > 0 then
        self.Pawn2 = arr:Get(0)
    end
    Dump(self.Pawn1)
	Dump(self.Pawn2)
	
	self.Pawn1:SetEnemy(self.Pawn2)
	self.Pawn2:SetEnemy(self.Pawn1)


end

function Hud:SetMainWidget()
end

function Hud:OpenMainWidget()

    -- local WidgetClass = slua.loadClass("WidgetBlueprint'/Game/HitBoxMaker/DemoFightGame/Blueprints/FightGame/Widget/LuaGightGameWidget.LuaGightGameWidget'")
    -- self.MainWidget = self:CreateWidget(self:GetWorld(),WidgetClass)
	-- self.MainWidget:AddToViewport();
	
    local ui = slua.loadUI("/Game/HitBoxMaker/DemoFightGame/Blueprints/FightGame/Widget/LuaFightGameWidget.LuaFightGameWidget",self:GetWorld())
    -- slua.dumpUObjects(ui)
    ui:AddToViewport(0);

    ui:SetPawns(self.Pawn1,self.Pawn2)


end

function Hud:ReceiveDrawHUD(a,b)

    self.Super:ReceiveDrawHud(a,b)
end


return Hud
