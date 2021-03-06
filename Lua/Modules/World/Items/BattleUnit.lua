---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zheng.
--- DateTime: 2020/4/12 19:44
--- 战斗单位
---

local SceneUnitHUD = require("Game.Modules.World.Items.SceneUnitHUD")
local PerformancePlayer = require("Game.Modules.Battle.Performances.PerformancePlayer")
local AccountCtrl = require("Game.Modules.Battle.Components.AccountCtrl")
local GridBehaviorStrategy = require("Game.Modules.Battle.Behaviors.Strategy.GridBehaviorStrategy")
local BattleItemEvents = require("Game.Modules.Battle.Events.BattleItemEvents")
local AvatarGridBehavior = require("Game.Modules.Battle.Behaviors.AvatarGridBehavior")
local Avatar = require("Game.Modules.World.Items.Avatar")

---@class Game.Modules.World.Items.BattleUnit : Game.Modules.World.Items.Avatar
---@field New fun(battleUnitVo:Game.Modules.Battle.Vo.BattleUnitVo, context:WorldContext) : Module.World.Items.Monster
---@field battleUnitVo Game.Modules.Battle.Vo.BattleUnitVo
---@field behavior Game.Modules.Battle.Behaviors.GridBattleBehavior
---@field strategy Game.Modules.Battle.Behaviors.Strategy.BehaviorStrategyBase -- 策略
---@field accountCtrl Game.Modules.Battle.Components.AccountCtrl
---@field performancePlayer Game.Modules.Battle.Performances.PerformancePlayer
---@field ownerCardVo Game.Modules.Card.Vo.CardVo 英雄所属卡
---@field layoutIndex number 布局索引 默认0 表示没有上场
---@field layoutGrid Game.Modules.Battle.Layouts.LayoutGrid 所在布局格子
local BattleItem = class("Game.Modules.World.Items.BattleUnit", Avatar)

---@param battleUnitVo Game.Modules.Battle.Vo.BattleUnitVo
---@param context WorldContext
function BattleItem:Ctor(battleUnitVo, context)
    self:SetContext(context)
    self.battleUnitVo = battleUnitVo
    BattleItem.super.Ctor(self, battleUnitVo)
end

--重置属性
function BattleItem:ResetAttr()
    self.battleUnitVo:Reset()
end

function BattleItem:LoadObject()
    if self.avatarInfo.prefabUrl then
        self.renderObj = self.context.pool:CreateObjectByPool(self.avatarInfo.prefabUrl)
        self.renderObj.transform:SetParent(self.transform)
        self.renderObj:ResetTransform()
        self:OnRenderObjInit()
    end
end

function BattleItem:OnRenderObjInit()
    BattleItem.super.OnRenderObjInit(self)
    self:SetLayer(Layers.Name.BattleItem)

    self.accountCtrl = AccountCtrl.New(self)
    self.performancePlayer = PerformancePlayer.New(self)
    self.strategy = GridBehaviorStrategy.New(self)

    self.hud = SceneUnitHUD.New(self)
end

function BattleItem:SetHudVisible(visible)
    if self.hud then
        self.hud.gameObject:SetActive(visible)
    end
end

--出生效果
function BattleItem:Born(callback)
    LuaReflectHelper.PushVo(self, self.battleUnitVo)
    self.luaReflect:PushLuaFunction("JsonToLua", handler(self,self.JsonToLua))
    self:PlayBorn(function()
        if callback then callback() end
        self:PlayIdle()
        self:OnBorn()
    end)
    self:SetRenderEnabled(true)
end

function BattleItem:JsonToLua(key, json)
    LuaReflectHelper.JsonToLua(self, key, json)
end

function BattleItem:OnBorn(callback)
    BattleItemEvents.DispatchItemEvent(BattleItemEvents.BattleItemBorn, self)
    if callback then
        callback()
    end
end

function BattleItem:SetRenderEnabled(enabled)
    self.renderObj:SetActive(enabled)
    --if not enabled then
    --    logError("SetRenderEnabled")
    --end
    if self.shadow then
        self.shadow:SetActive(enabled)
    end
end

function BattleItem:SetBehaviorEnabled(enabled)
    if not self.behavior then

        self.behavior = AvatarGridBehavior.New(self)
    end
    if enabled then
        if self:IsDead() then
            --logError("This item is dead, can not set behavior enabled")
            return
        end
        --self.isMoving = true
        --self:UpdateAroundPos()
        --logError("SetBehaviorEnabled true")
        self.behavior:Play()
    else
        self.behavior:Stop()
    end
end

---@param hurtInfo HurtInfo
function BattleItem:DoHurt(hurtInfo)

end

function BattleItem:OnDeadOver()
    self.deadOver = true
    self:Dispose()
end

function BattleItem:OnDead()
    BattleItem.super.OnDead(self)

    self:Clean()

    self:_debug("BattleItem:OnDead " .. self.gameObject.name )
    local event = {}
    event.type = BattleItemEvents.BattleItemDead
    event.target = self
    BattleItemEvents.Dispatch(event)
    if self.layoutGrid then
        self.layoutGrid:ClearOwner()
        self.layoutGrid = nil
    end
    self:PlayDead(Handler.New(function()
        self:OnDeadOver()
    end))
end

function Avatar:PlayDead(callback)
    self.animCtrl:PlayAnim(self.avatarInfo.animDead, callback)
end

--回收
function BattleItem:Recovery()
    BattleItem.super.Recovery(self)
    local pool = self.context.pool:GetObjectPool(self.avatarInfo.prefabUrl)
    --把影子换回去
    if not isnull(self.shadow)  then
        self.shadow.transform:SetParent(self.renderObj.transform)
    end
    pool:Store(self.renderObj)
end

function BattleItem:Clean()
    if self.behavior then
        self.behavior:Dispose()
        self.behavior = nil
    end
    if self.hud then
        self.hud:Dispose()
        self.hud = nil
    end
    if self.battleUnitVo then
        self.battleUnitVo:Dispose()
        self.battleUnitVo = nil
    end
    if self.cc then
        self.cc.enabled = false
    end
end

function BattleItem:Dispose()
    self:Recovery()
    BattleItem.super.Dispose(self)
    self:Clean()

    if self.animCtrl then
        self.animCtrl:Dispose()
        self.animCtrl = nil
    end

    --if self.effectWidget then
    --    self.effectWidget:RemoveSingCircle()
    --end
    --if self.gameObject.transform.childCount > 0 then
    --    logError("You must recovery the renderObj")
    --end
    Destroy(self.gameObject)
end

return BattleItem