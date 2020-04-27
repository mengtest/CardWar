---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhengnan.
--- DateTime: 2020/2/21 10:48
--- 每个网格区域中的一波
---

--单个波数据
---@class GridWaveInfo : WaveBaseInfo
---@field waveMode string 类型 boss , normal
---@field needPause boolean
---@field index number
---@field wavePoints table<number,WavePointInfo>
---@field delay number
---@field enterScript string  进入该区域触发的剧情
---@field exitScript string   离开该区域触发的剧情

local BattleUnit = require("Game.Modules.World.Items.BattleUnit")
local WaveBase = require("Game.Modules.Battle.Layouts.WaveBase")

---@class Game.Modules.Battle.Layouts.GridWave : Game.Modules.Battle.Layouts.WaveBase
---@field New fun(waveInfo:GridWaveInfo, forward:UnityEngine.Vector3):Game.Modules.Battle.Layouts.GridWave
local GridWave = class("Game.Modules.Battle.Layouts.GridWave", WaveBase)

---@param waveInfo GridWaveInfo
function GridWave:Ctor(waveInfo)
    GridWave.super.Ctor(self)
    self.waveInfo = waveInfo
    self.itemList = List.New()
end

---@param callback fun()
function GridWave:Refresh(callback)
    self:StartCoroutine(function()
        for i = 1, #self.waveInfo.wavePoints do
            local wavePoint = self.waveInfo.wavePoints[i]
            --if wavePoint.delay > 0 then
            --    coroutine.wait(wavePoint.delay)
            --end
            local battleItemVo = World.CreateBattleUnitVo(wavePoint.battleUnit)--克隆数据
            battleItemVo.camp = Camp.Def --所有怪物默认都是守方阵营
            local battleItem = BattleUnit.New(battleItemVo, self.context)
            local layoutGrid = self.context.battleLayout:AddUnit(battleItem,Camp.Def, wavePoint.grid)
            battleItem:SetBornPos(layoutGrid.transform.position, layoutGrid.forward)
            if wavePoint.bornMode == WaveBornMode.BornEffect then
                battleItem:Born()
                coroutine.step()
            elseif wavePoint.bornMode == WaveBornMode.WaitBorn then
                local bornOver = false
                battleItem:Born(function()
                    bornOver = true
                end)
                while not bornOver do
                    coroutine.step()
                end
            else
                battleItem:OnBorn()
            end
            --monster:CreateHpBar()
            battleItem:ResetAttr()
            battleItem.isBorn = true
            battleItem:SetRenderEnabled(true)
            self:_debug(string.format("Refresh %d/%d", i,#self.waveInfo.wavePoints))
            self.itemList:Push(battleItem)
        end
        if callback then
            callback()
        end
    end)
end

function GridWave:Active()
    if self.isActive then
        return --重复激活
    end
    self.isActive = true
end

--是否都已经死亡
function GridWave:IsAllDead()
    if not self.isActive then
        return false
    end
    local allDead = true
    for i = 1, self.itemList:Size() do
        local monster = self.itemList[i] ---@type Game.Modules.World.Items.BattleUnit
        if not monster:IsDead() then
            allDead = false
            break;
        end
    end
    return allDead
end

--是否都已经死亡
function GridWave:IsAllDeadOver()
    if not self.isActive then
        return false
    end
    local allDead = true
    for i = 1, self.itemList:Size() do
        local monster = self.itemList[i] ---@type Game.Modules.World.Items.BattleUnit
        if not monster.deadOver then
            allDead = false
            break;
        end
    end
    return allDead
end

function GridWave:Clear()

end

return GridWave