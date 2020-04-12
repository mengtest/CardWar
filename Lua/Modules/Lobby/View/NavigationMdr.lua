---
--- Generated by Tools
--- Created by zheng.
--- DateTime: 2020-04-10-22:53:29
---

local BaseMediator = require("Game.Core.Ioc.BaseMediator")
---@class Game.Modules.Lobby.View.NavigationMdr : Game.Core.Ioc.BaseMediator
---@field lobbyModel Game.Modules.Lobby.Model.LobbyModel
---@field lobbyService Game.Modules.Lobby.Service.LobbyService
local NavigationMdr = class("Game.Modules.Lobby.View.NavigationMdr",BaseMediator)

function NavigationMdr:OnInit()
    
end

function NavigationMdr:On_Click_Button()
    World.worldScene:EnterCheckPoint("battle_1_1")
end

return NavigationMdr
