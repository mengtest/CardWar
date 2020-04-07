---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zheng.
--- DateTime: 2018/6/14 0:16
---

local NetworkListener = require("Betel.Net.NetworkListener")
local LuaMonoBehaviour = require('Betel.LuaMonoBehaviour')
---@class Game.Core.Ioc.BaseMediator : Betel.LuaMonoBehaviour
---@field gameObject UnityEngine.GameObject
---@field layer UILayer 该模块所在UI层级
---@field rectTransform UnityEngine.RectTransform
---@field scene Game.Modules.World.Scenes.BaseScene
---@field uiCanvas UnityEngine.Canvas
---@field uiCamera UnityEngine.Camera
---@field isEnableMonoBehaviour boolean 是否启用Unity MonoBehaviour
local BaseMediator = class("BaseMediator",LuaMonoBehaviour)

function BaseMediator:Ctor()
    BaseMediator.super.Ctor(self)
    self.layer = UILayer.LAYER_DEPTH_UI --默认在深度排序层级
    self.netWorkListener = NetworkListener.New()
    self.clickEventMap = {} --主动注册的点击事件
    self.removeCallback = nil
    self.autoClickEventObjs = {} --自动注册的点击事件
    self.isEnableMonoBehaviour = false --默认不启用Unity MonoBehaviour
end

function BaseMediator:Start()
    self.rectTransform = self.gameObject:GetRect()
    self:OnInit()
    self:OnAutoRegisterEvent()
    self:RegisterListeners()
    nmgr:AddListener(self.netWorkListener)
end

function BaseMediator:OnInit()

end

function BaseMediator:RegisterListeners()

end

function BaseMediator:AddPush(action, callback)
    if callback ~= nil then
        self.netWorkListener:addPushCallback(action, callback)
    end
end

--自动注册按钮点击事件
function BaseMediator:OnAutoRegisterEvent()
    local buttons = Tools3D.GetComponents(self.gameObject, typeof(UnityEngine.UI.Button), true)
    for i = 0,buttons.Length - 1 do
        local funName = "On_Click_"..buttons[i].gameObject.name
        if self[funName] then
            log("Auto Register Events:" .. funName)
            LuaHelper.AddButtonClick(buttons[i].gameObject,handler(self,self[funName]))
            buttons[i].gameObject:GetOrAddComponent(typeof(Framework.PointerScaler))
            table.insert(self.autoClickEventObjs, buttons[i].gameObject)
        end
    end

    local images = Tools3D.GetComponents(self.gameObject, typeof(UnityEngine.UI.Image), true)
    for i = 0,images.Length - 1 do
        local button = images[i].gameObject:GetComponent(typeof(UnityEngine.UI.Button))
        if button == nil then
            local funName = "On_Click_"..images[i].gameObject.name
            if self[funName] then
                log("Auto Register Events:" .. funName)
                LuaHelper.AddObjectClickEvent(images[i].gameObject,handler(self,self[funName]))
                images[i].gameObject:GetOrAddComponent(typeof(Framework.PointerScaler))
                table.insert(self.autoClickEventObjs, images[i].gameObject)
            end
        end
    end
end

--自动移除点击事件
function BaseMediator:OnAutoRemoveEvent()
    for i = 1,#self.autoClickEventObjs do
        LuaHelper.RemoveButtonClick(self.autoClickEventObjs[i])
    end
end

function BaseMediator:AddClickEventListener(go, clickFun)
    if self.clickEventMap[clickFun] == nil  then
        self.clickEventMap[clickFun] = {}
    end
    local handler = handler(self,clickFun)
    LuaHelper.AddObjectClickEvent(go,handler)
    table.insert(self.clickEventMap[clickFun], {go = go, handler = handler})
end

--function BaseMediator:AddObjectEventListener(listener, go, func)
--    if not self.clickEventMap[func] then
--        listener(go, func)
--        self.clickEventMap[func] = {go,func}
--    end
--end

function BaseMediator:RegisterButtonClick(go, clickFun, addPointerScaler)
    if addPointerScaler == nil or addPointerScaler == true then
        go:GetOrAddComponent(typeof(Framework.PointerScaler))
    end
    LuaHelper.AddButtonClick(go,handler(self,clickFun))
end

---@param useManualUpdate boolean 是否手动Update(忽略time scale)
---@return DG.Tweening.Sequence
function BaseMediator:CreateSequence(useManualUpdate)
    local sequence = BaseMediator.super.CreateSequence(self)
    if useManualUpdate == nil or useManualUpdate == false then
        sequence:SetUpdate(DG.Tweening.UpdateType.Manual)
    end
    return sequence
end

--获取世界坐标的本地(本UI模块)坐标
---@param worldPos UnityEngine.Vector3
function BaseMediator:UIWorldPosToLocalPosition(worldPos)
    return Convert.WorldPosToCanvasLocalPosition(worldPos, self.uiCanvas.worldCamera, self.uiCanvas, self.rectTransform)
end

--获取世界坐标的本地(本UI模块)坐标
---@param worldPos UnityEngine.Vector3
function BaseMediator:WorldPosToLocalPosition(worldPos, sceneCamera)
    return Convert.WorldPosToCanvasLocalPosition(worldPos, sceneCamera, self.uiCanvas, self.rectTransform)
end

function BaseMediator:Unload()
    vmgr:UnloadView(self.viewInfo)
end

function BaseMediator:DoRemove(callback,removeCallback)
    callback()
    self:OnAutoRemoveEvent()
    self.removeCallback = removeCallback
end

function BaseMediator:OnDestroy()
    print("OnDestroy view: "..self.viewInfo.name)
    self.viewInfo.status = ViewStatus.Unloaded
    nmgr:RemoveListener(self.netWorkListener)
    self:Dispose()
    self:OnRemove()
    if self.removeCallback ~= nil then
        self.removeCallback(self)
        self.removeCallback = nil
    end
    for _, map in pairs(self.clickEventMap) do
        for i = 1, #map do
            LuaHelper.RemoveObjectEvent(map[i].go, map[i].handler)
        end
    end
end

function BaseMediator:OnRemove()

end

--调试
function BaseMediator:_debug(msg)
    if self.gameObject then
        print(string.format("<color=#0F9783FF>[%s]</color>\n<color=#FFFFFFFF>%s</color>",self.gameObject.name,msg))
    else
        print(string.format("<color=#0F9783FF>[%s]</color>\n<color=#FFFFFFFF>%s</color>",self.__classname,msg))
    end
end

return BaseMediator