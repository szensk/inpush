push
===========
A simple work-in-progress input library for the [LÖVE](https://love2d.org/) (version >= 0.9.0) game engine. It binds triggers to actions. Each action can have multiple triggers. Actions and triggers can also be anonymous functions.

Usage
=====
```lua
local push   = require 'push'
local action = require 'action'

love.load = function()
  push.bind(push.a, action.left) -- you can access keys via push["keyname"]
  push.bind(push.left, action.left) 
  push.bind('q', action.quit) -- or you can use the Love2D string representation 
  push.bind('escape', action.quit) -- allows multiple triggers to the same action
  push.bind('1', function() love.window.setTitle("Pressed 1") end) -- the action can be an anonymous function
  push.bind(function() -- the trigger can be an anonymous function as well
    return (push.lctrl.down or push.rctrl.down) and push.v.pressed
  end, action.paste)
end

love.update = function(dt)
  if action.quit.pressed then --will only be true when the quit action's trigger has been pressed 
    love.event.push('quit') 
  end
  push.update(dt)
 end

love.keypressed = function(key)
  push.keypressed(key)
end
```
