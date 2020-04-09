---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zheng.
--- DateTime: 2019/5/18 23:06
---

local SubScene = require('Game.Modules.World.Scenes.Core.SubScene')

---@class Game.Modules.World.Scenes.BattleScene : Game.Modules.World.Scenes.Core.SubScene
local BattleScene = class("Game.Modules.World.Scenes.BattleScene",SubScene)

---@param sceneInfo SceneInfo
---@param unityScene UnityEngine.SceneManagement.Scene
function BattleScene:Ctor(sceneInfo, unityScene)
    BattleScene.super.Ctor(self, sceneInfo, unityScene)
end

function BattleScene:OnEnterScene()
    self:LoadSubLevel(1,function(subScene)
        World.battleSubScene = subScene
        vmgr:LoadView(ViewConfig.Battle)
    end)
end

function BattleScene:OnExitScene()
    vmgr:UnloadView(ViewConfig.Battle)
end
return BattleScene