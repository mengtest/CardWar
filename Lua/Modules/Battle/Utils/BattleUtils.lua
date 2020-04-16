---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zheng.
--- DateTime: 2020/4/13 23:41
---


--布局格子
---@class GridLayoutInfo
---@field grid UnityEngine.GameObject
---@field owner Module.World.Items.Avatar
---@field mat UnityEngine.Material
---@field index number

---@class BattleUtils
local BattleUtils = {}


--目标的有效性
---@param target Module.World.Items.Avatar
function BattleUtils.TargetValid(target)
    if target and not target:IsDead() and not isnull(target.gameObject) then
        return true
    else
        return false
    end
end

--目标的是否符合被结算的有效性
---@param target Module.World.Items.Avatar
function BattleUtils.TargetAccountValid(target)
    if target and not isnull(target.gameObject) and target.isBorn then
        return true
    else
        return false
    end
end

--目标的是否符合被攻击的有效性
---@param target Module.World.Items.Avatar
function BattleUtils.TargetAttackValid(target)
    if BattleUtils.TargetValid(target) and target.isBorn and target.avatarInfo.avatarType ~= AvatarType.Collect then
        return true
    else
        return false
    end
end

--创建单位脚底格子
---@param gridPoints table<number, UnityEngine.Vector3>
---@param forward UnityEngine.Vector3
---@param context WorldContext
---@return table<number, Game.Modules.Battle.Layouts.LayoutGrid>
function BattleUtils.CreateLayoutGrids(gridPoints, forward, context)
    local grids = {}
    local LayoutGrid = require("Game.Modules.Battle.Layouts.LayoutGrid")
    for i = 1, #gridPoints do
        local grid = context.pool:CreateObjectByPool(Prefabs.LayoutGrid)
        grid.name = grid.name .. i
        grid.transform:SetParent(context.avatarRoot.transform)
        grid.transform.forward = forward
        grid.transform.localPosition = gridPoints[i]
        grid.transform.localEulerAngles = Vector3.New(90,grid.transform.localEulerAngles.y,grid.transform.localEulerAngles.z)
        grid.transform.localScale = Vector3.one
        table.insert(grids, LayoutGrid.New(grid,i,forward))
    end
    return grids
end

--获取对立阵营
---@param camp Camp
---@return Camp
function BattleUtils.GetOpposeCamp(camp)
    if camp == nil then
        logError("Camp is nil")
    end
    if camp == Camp.Atk then
        return Camp.Def
    else
        return Camp.Atk
    end
end

return BattleUtils