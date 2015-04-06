local action = { }
local actionmt = {
  __index = function(t, k)
    local act = rawget(t, k)
    if act then
      return act
    else
      act = {
        pressed = false,
        released = false,
        down = false
      }
      rawset(t, k, act)
      return act
    end
  end
}
setmetatable(action, actionmt)
return action
