---
--- Generated by Tools
--- Created by zhengnan.
--- DateTime: 2020-03-03-13:42:04
--- 常规场景战斗模块
---


local BattleLayout = require("Game.Modules.Battle.Layouts.BattleLayout")
local BattleEvents = require("Game.Modules.Battle.Events.BattleEvents")
local WorldContext = require("Game.Modules.World.Contexts.WorldContext")
local PoolProxy = require("Game.Modules.Common.Pools.AssetPoolProxy")
local BaseMediator = require("Game.Core.Ioc.BaseMediator")
---@class Game.Modules.Battle.View.BattleMdrBase : Game.Core.Ioc.BaseMediator
---@field battleModel Game.Modules.Battle.Model.BattleModel
---@field playerModel Game.Modules.Player.Model.PlayerModel
---@field battleService Game.Modules.Battle.Service.BattleService
---@field context WorldContext
---@field checkPointData CheckPointData
local BattleMdrBase = class("Module.Battle.View.BattleMdrBase",BaseMediator)

function BattleMdrBase:OnInit()
    self.battleModel.currCheckPointData = World.worldScene.currSubScene.checkPointData
    self.battleModel.playerVo = self.playerModel.playerVo;

    self:InitCheckPointData()   --初始化关卡数据
    self:InitObjectPool()       --初始化对象池
    self:InitLayoutData()       --初始化布局
    self:InitBattleMode()       --初始化战斗模式
    self:StartBattle()          --开始战斗
    BattleEvents.Dispatch({type = BattleEvents.BattleStart, checkPointData = self.checkPointData})
end

function BattleMdrBase:RegisterListeners()

end

--初始化关卡数据
function BattleMdrBase:InitCheckPointData()
    self.checkPointData = self.battleModel.currCheckPointData
    log("Init CheckPoint " .. self.battleModel.currCheckPointData.id)
    self.context = WorldContext.New(self.checkPointData.mode)
    self.battleModel.currentContext = self.context
    self.context.currSubScene = World.worldScene.currSubScene
    self.context.avatarRoot = self.context.currSubScene:CreateGameObject("AvatarRoot" .. self.context.id)
    --A*
    --self.context.grid = self.context.currSubScene:FindRootObjInSubScene("A*"):GetComponent(typeof(AStar.Grid))
    --self.context.gridGap = self.context.grid.nodeRadius * 2
    --self.context.grid.gameObject:SetActive(true)
end


--初始化对象池
function BattleMdrBase:InitObjectPool()
    local poolObj = self.context.currSubScene:CreateGameObject("[Pool" .. self.context.id .. "]")
    self.context.pool = PoolProxy.New(poolObj)
    local poolNumMap = self.context.pool:InitCheckPointObjectPool(self.checkPointData)

    for i = 1, #self.battleModel.playerVo.cards do
        table.insert(poolNumMap, { [self.battleModel.playerVo.cards[i].cardInfo.avatarName] = 1})
    end
    table.insert(poolNumMap, { ["DropItem"] = 1})

    local poolsInfos = PoolFactory.CalcPoolInfoMap(poolNumMap)
    table.insert(poolsInfos,{prefabUrl = Prefabs.LayoutGrid, initNum = 18})
    self.context.pool:InitObjectPool(poolsInfos)
end

function BattleMdrBase:InitLayoutData()
    local obstructs = self.context.currSubScene:FindRootObjInSubScene("Obstructs")
    if obstructs then
        obstructs:SetActive(false)
    end
    local layoutPrefab = Instantiate(self.checkPointData.layoutPrefabUrl)
    --布局
    local areaPointObj = layoutPrefab:FindChild(self.checkPointData.layoutPoints)
    self.context.battleLayout = BattleLayout.New(self.context, areaPointObj)--创建布局
end

--初始化战斗模式
function BattleMdrBase:InitBattleMode()

end

function BattleMdrBase:StartBattle()

end

function BattleMdrBase:OnRemove()
    BattleMdrBase.super.OnRemove(self)
    --释放上下文
    self.context:Dispose()
    self.battleModel:Clear()
    BattleEvents.Dispatch(BattleEvents.BattleEnd)
end

return BattleMdrBase
