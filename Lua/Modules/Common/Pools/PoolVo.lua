---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhengnan.
--- DateTime: 2020/1/8 12:02
--- 池对象Vo
---

local BaseVo = require("Game.Core.BaseVo")
---@class Game.Modules.Common.Pools.PoolVo : Game.Core.BaseVo
---@field New fun():Game.Modules.Common.Pools.PoolVo
---@field delete boolean
local PoolVo = class("Game.Modules.Common.Pools.PoolVo", BaseVo)

function PoolVo:Ctor()

end

function PoolVo:Dispose()

end

return PoolVo