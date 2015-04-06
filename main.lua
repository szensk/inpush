local push   = require 'push'
local action = require 'action'

-- experimental; perhaps not useful
local env = { push = push }
function push.string(s)
  s = s:gsub("(%w+)([^!%$])", "push.%1.down%2"):gsub("(%w+[!%$])", "push.%1")
  s = ("return (%s)"):format(s)
  s = s:gsub("%|", " or "):gsub("%&", " and "):gsub("%!", ".pressed"):gsub("%$", ".released")
  return setfenv(assert(loadstring(s)), env)
end
setmetatable(push, { __call = function(t,s) return t.string(s) end })

-- test code
local leftstr  = ""
local pastestr = ""

love.load = function()
  push.bind(push.a, action.left) --you can use the key itself
  push.bind(push.left, action.left) 
  push.bind('q', action.quit) -- or the Love2D string representation
  push.bind('escape', action.quit) -- TODO: allow multiple triggers to the same action
  push.bind('a', function() love.window.setTitle("Pressed a") end)
  push.bind(push'(lctrl | rctrl) & v!', action.paste) -- same as below
  --push.bind(function()
  --  return (push.lctrl.down or push.rctrl.down) and push.v.pressed
  --end, action.paste)
end

love.draw = function()
  love.graphics.setColor(240, 16, 16)
  love.graphics.print(("Keys: %s | %s"):format(leftstr, pastestr), 5, 5)
  leftstr  = action.left.down and "ldown" or "lup"
  pastestr = action.paste.down and "pdown" or "pup"
  leftstr  = leftstr .. ((action.left.pressed and "pressed") or "")
end

love.update = function(dt)
  if action.quit.pressed then love.event.push('quit') end
  push.update(dt)
 end

love.keypressed = function(key)
  push.keypressed(key)
end

