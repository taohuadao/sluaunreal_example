require("Lua/Class")


local NewClass = Class("NewClass")


function NewClass:ctor()
    PrintInfo("im ctor")
end




local a = NewClass:new()
local b = NewClass.new()


