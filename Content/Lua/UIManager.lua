

local EventDispatcher = require("Core/EventDispatcher")

local UIManager = Class("UIManager")


function UIManager:ctor()
    self.EventDispatcher = EventDispatcher:new()
end











return UIManager.new()