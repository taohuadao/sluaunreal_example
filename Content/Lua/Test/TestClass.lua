require("Lua/Class")


local NewClass = Class("NewClass")


function NewClass:ctor()
    PrintInfo("im ctor")
end




local a = NewClass:new()
local b = NewClass.new()


local array = {a=1,b=2,c=3,d=4}


for _,v in pairs(array) do

    print(_, v)
    
end
print("-------------------")
for _,v in pairs(array) do

    print(_,v)
    table.remove(array, _)
    
end
print("-------------------")
for _,v in pairs(array) do

    print(_, v)
    
end


