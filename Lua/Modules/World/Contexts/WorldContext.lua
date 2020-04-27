---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zheng.
--- DateTime: 2020/4/10 23:37
---

local BattleUnit = require("Game.Modules.World.Items.BattleUnit")

---@class WorldContext
---@field New fun()
---@field mode string
---@field id number
---@field checkPointData CheckPointData
---@field currSubScene Game.Modules.World.Scenes.Core.SubScene  当前子场景
---@field battleBehavior Game.Modules.Battle.Behaviors.BattleBehavior    战场行为
---@field battleItemList table<number, Game.Modules.World.Items.BattleUnit>
---@field avatarRoot UnityEngine.GameObject
---@field luaReflect Framework.LuaReflect
---@field pool Game.Modules.Common.Pools.AssetPoolProxy 对象池
---@field attachCamera Game.Modules.Common.Components.AttachCamera
---@field battleLayout Game.Modules.Battle.View.BattleLayout
local WorldContext = class("WorldContext")

local Sid = 1

function WorldContext:Ctor(mode)
    self.id = Sid
    Sid = Sid + 1
    self.mode = mode
    self.battleItemList = {}
    self.dropList = List.New()
end

function WorldContext:CreateAvatarRoot()
    self.avatarRoot = self.currSubScene:CreateGameObject("AvatarRoot" .. self.id)
    self.luaReflect = self.avatarRoot:AddComponent(typeof(Framework.LuaReflect))
    self.luaReflect:PushLuaFunction("AddBattleUnit",handler(self, self.AddBattleUnit))
    self.luaReflect:PushLuaFunction("RemoveBattleUnit",handler(self, self.RemoveBattleUnit))
end

function WorldContext:AddBattleUnit(camp, battleUnit)
    local emptyGrid = self.battleLayout:GetFirstEmptyGrid(camp)
    if emptyGrid then
        local layoutIndex = emptyGrid.index
        local battleItem = self:CreateBattleItem(camp, battleUnit, layoutIndex)
        self.battleLayout:AddUnit(battleItem, camp, layoutIndex)
    else
        logError("There is no empty grid")
    end
end

function WorldContext:RemoveBattleUnit(camp, index)
    local grid = self.battleLayout:GetLayoutGridByIndex(camp, index)
    if grid then
        if grid.owner then
            grid.owner:Dispose()
        end
        grid:ClearOwner()
    else
        logError("There is no empty grid")
    end
end

--创建可以战斗的单位
---@param camp Camp 所属阵营
---@param cards table<number, Game.Modules.Card.Vo.CardVo> 卡牌
---@param state CardState
function WorldContext:CreateBattleItems(cards, camp, state)
    for i = 1, #cards do
        local card = cards[i]
        if state == nil or card.state == state then
            local battleItem = self:CreateBattleItem(camp, card.cardInfo.battleUnit, card.layoutIndex)
            battleItem.ownerCardVo = card
            self.battleLayout:AddUnit(battleItem, camp, card.layoutIndex)
        end
    end
end

---@param card Game.Modules.Card.Vo.CardVo 卡牌
function WorldContext:CreateBattleItem(camp, battleUnit, layoutIndex)
    local battleItemVo = World.CreateBattleUnitVo(battleUnit)
    battleItemVo.camp = camp
    battleItemVo.isLeader = layoutIndex == 1
    battleItemVo.index = layoutIndex
    local battleItem = BattleUnit.New(battleItemVo, self)
    return battleItem
end

function WorldContext:Dispose()
    if self.battleBehavior then
        self.battleBehavior:Dispose()
    end
    if self.attachCamera then
        self.attachCamera:Dispose()
    end
    if self.pool then
        self.pool:Dispose()
    end

    Destroy(self.avatarRoot)
    self.avatarRoot = nil
end

return WorldContext