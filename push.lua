-- Input Library: Push
local all_keys = {
    "space", "return", "escape", "backspace", "tab", "space", "!", "\"", "#", "$", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", "0", "1", "2", "3", "4",
    "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", "@", "[", "\\", "]", "^", "", "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
    "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "capslock", "f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "f10", "f11", "f12", "printscreen",
    "scrolllock", "pause", "insert", "home", "pageup", "delete", "end", "pagedown", "right", "left", "down", "up", "numlock", "kp/", "kp*", "kp-", "kp+", "kpenter",
    "kp0", "kp1", "kp2", "kp3", "kp4", "kp5", "kp6", "kp7", "kp8", "kp9", "kp.", "kp,", "kp=", "application", "power", "f13", "f14", "f15", "f16", "f17", "f18", "f19",
    "f20", "f21", "f22", "f23", "f24", "execute", "help", "menu", "select", "stop", "again", "undo", "cut", "copy", "paste", "find", "mute", "volumeup", "volumedown",
    "alterase", "sysreq", "cancel", "clear", "prior", "return2", "separator", "out", "oper", "clearagain", "thsousandsseparator", "decimalseparator", "currencyunit",
    "currencysubunit", "lctrl", "lshift", "lalt", "lgui", "rctrl", "rshift", "ralt", "rgui", "mode", "audionext", "audioprev", "audiostop", "audioplay", "audiomute",
    "mediaselect", "brightnessdown", "brightnessup", "displayswitch", "kbdillumtoggle", "kbdillumdown", "kbdillumup", "eject", "sleep", "mouse1", "mouse2", "mouse3",
    "mouse4", "mouse5", "wheelup", "wheeldown", "fdown", "fup", "fleft", "fright", "back", "guide", "start", "leftstick", "rightstick", "l1", "r1", "l2", "r2", "dpup",
    "dpdown", "dpleft", "dpright", "leftx", "lefty", "rightx", "righty"
}

local input  = nil
local keys   = {}

local function fire(key, action)
  if type(action) == 'function' then
    if key.down then action() end
  else
    action.down     = key.down
    action.pressed  = key.pressed
    action.released = key.released
  end
end

local actions = {}
input = {
  bind = function(condition, action)
    local typ = type(condition)
    local act = {
      condition = condition,
      action = action
    }
    local reg = actions[action]
    if reg then
      reg[#reg + 1] = act
    else
      actions[action] = {act}
    end
    return act
  end,
  unbind = function(binding)
    if binding == 'all' then
      actions = { }
    else
      --TODO -- actions[binding] = nil
    end
  end,
  update = function(dt)
    for i,v in ipairs(all_keys) do
      input[v].down = love.keyboard.isDown(v)
    end
    for k, act in pairs(actions) do
      for i, v in ipairs(act) do
        if type(v.action) == 'table' then
          if v.action.down and i > 1 then break end -- bail early so as to not overwrite
        end
        local typ = type(v.condition)
        if typ == 'string' then
          fire(input[v.condition], v.action)
        elseif typ == 'function' then
          fire({down = v.condition()}, v.action)
        else
          fire(v.condition, v.action)
        end
      end
    end
    for i,v in ipairs(all_keys) do
      input[v].pressed  = false
      input[v].released = false
    end
  end,
  keypressed = function(key)
    local inkey = input[key]
    if inkey then
      inkey.pressed = true
    end
  end,
  keyreleased = function(key)
    local inkey = input[key]
    if inkey then
      inkey.released = true
    end
  end,
  mousepressed = function(btn)
    local inkey = input[key]
    if inkey then
      inkey.pressed = true
    end
  end,
  mousereleased = function(btn)
    local inkey = input[key]
    if inkey then
      inkey.released = true
    end
  end
}

for i,v in ipairs(all_keys) do
  input[v] = {
    pressed  = false,
    released = false,
    down = false
  }
end

return input

