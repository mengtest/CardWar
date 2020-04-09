---
--- Generated by Tools
--- Created by zheng.
--- DateTime: 2019-05-18-23:26:57
---

--场景信息
---@class SceneInfo
---@field debugName string
---@field level string
---@field sceneName string
---@field levelUrl string
---@field subLevels table<string,SubSceneInfo>
---@field needLoading boolean

--子场景信息
---@class SubSceneInfo
---@field level string
---@field levelUrl string

local BaseModel = require("Game.Core.Ioc.BaseModel")
---@class Game.Modules.World.Model.WorldModel : Game.Core.Ioc.BaseModel
---@field worldService Game.Modules.World.Service.WorldService
local WorldModel = class("WorldModel",BaseModel)

function WorldModel:Ctor()
    
end

return WorldModel
