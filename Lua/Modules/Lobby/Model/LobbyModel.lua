---
--- Generated by Tools
--- Created by zheng.
--- DateTime: 2020-04-10-22:53:40
---

local BaseModel = require("Game.Core.Ioc.BaseModel")
---@class Game.Modules.Lobby.Model.LobbyModel : Game.Core.Ioc.BaseModel
---@field lobbyService Game.Modules.Lobby.Service.LobbyService
local LobbyModel = class("Game.Modules.Lobby.Model.LobbyModel",BaseModel)

function LobbyModel:Ctor()
    
end

return LobbyModel