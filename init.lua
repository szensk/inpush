local path = ... .. "." 

local action = require(path .. "action")
local push = require(path .. "inpush")
push.action = action

return push
