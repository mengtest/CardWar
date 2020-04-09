---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zheng.
--- DateTime: 2019/5/18 23:55
---

local LuaMonoBehaviour = require('Betel.LuaMonoBehaviour')

---@class Game.Modules.World.Scenes.Core.SubScene : Betel.LuaMonoBehaviour
---@field New fun(subSceneInfo:SubSceneInfo, unityScene:UnityEngine.SceneManagement.Scene)
---@field unityScene UnityEngine.SceneManagement.Scene
---@field subSceneInfo SubSceneInfo
local SubScene = class("Game.Modules.World.Scenes.Core.SubScene",LuaMonoBehaviour)

---@param subSceneInfo SubSceneInfo
---@param unityScene UnityEngine.SceneManagement.Scene
function SubScene:Ctor(subSceneInfo, unityScene)
    SubScene.super.Ctor(self)
    self.subSceneInfo = subSceneInfo
    self.unityScene = unityScene
end

function SubScene:Init()
    UnityEngine.SceneManagement.SceneManager.SetActiveScene(self.unityScene)
end

---@return UnityEngine.GameObject
function SubScene:GetRootObjByName(name)
    local rootObjs = self.unityScene:GetRootGameObjects()
    for i = 0, rootObjs.Length - 1 do
        if rootObjs[i].name == name then
            return rootObjs[i]
        end
    end
    return nil
end

function SubScene:Unload(callback)
    sceneMgr:UnloadSubSceneAsync(self.subSceneInfo.level, function(levelName)
        if callback ~= nil then
            callback(levelName)
        end
    end)
end

return SubScene