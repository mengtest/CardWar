---
--- Generated by Tools
--- Created by zheng.
--- DateTime: 2020-04-24-23:17:47
---

local BaseMediator = require("Game.Core.Ioc.BaseMediator")
---@class Game.Modules.Player.View.PlayerInfoMdr : Game.Core.Ioc.BaseMediator
---@field playerModel Game.Modules.Player.Model.PlayerModel
---@field playerService Game.Modules.Player.Service.PlayerService
local PlayerInfoMdr = class("Game.Modules.Player.View.PlayerInfoMdr",BaseMediator)

function PlayerInfoMdr:OnInit()
    
end

return PlayerInfoMdr
