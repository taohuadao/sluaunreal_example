local EventDispatcher = Class("EventDispatcher")

function EventDispatcher:ctor()
    self.listeners = {}
end

function EventDispatcher:AddListener(evt, listener, once)
    if self.listeners[evt] == nil then
        self.listeners[evt] = {}
    end

    local listeners = self.listeners[evt]
    if listeners[listener] ~= nil then
        return false
    end

    listeners[listener] = {f = listener, once = once or false}
    return true
end

function EventDispatcher:HasListener(evt, listener)
    local listeners = self.listeners[evt]
    if listeners == nil then
        return false
    end

    return listeners[listener] ~= nil
end

--- 移除listener
-- @param evt event name (string)
-- @param listener object (table or function)
-- @return removal status (boolean).
-- @see removeAllListeners

function EventDispatcher:RemoveListener(evt, listener)
    local listeners = self.listeners[evt]
    if listeners == nil then
        return false
    end

    if listeners[listener] ~= nil then
        listeners[listener] = nil
        return true
    end
    return false
end

function EventDispatcher:RemoveAllListeners()
    self.listeners = {}
end

--- Dispatch Event  不保证顺序
-- @param evt event name (string)
-- @param
-- @return dispatched (boolean).
-- @see Dispatch

function EventDispatcher:Dispatch(evt, ...)
    local listeners = self.listeners[evt]
    if listeners == nil then
        return false
    end
    local dispatched = false
    for _, listener in pairs(listeners) do
        listener.f(...)
        dispatched = true
        if listener.once then
            listeners[_] = nil
        end
    end
    return dispatched
end

return EventDispatcher