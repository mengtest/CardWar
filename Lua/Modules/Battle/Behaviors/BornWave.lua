---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zheng.
--- DateTime: 2019/5/21 22:48
---

local Monster = require("Game.Modules.Battle.Items.Monster")
local BaseBehavior = require('Game.Modules.Common.Behavior.BaseBehavior')

---@class Game.Modules.Battle.Behaviors.BornWave : Game.Modules.Common.Behavior.BaseBehavior
---@field waveInfo WaveInfo
---@field areaInfo AreaInfo
---@field points table<number, UnityEngine.Vector3>
---@field monsterList table<number, Game.Modules.Battle.Items.Monster>
---@field isActive boolean 激活后,该区域所有怪物可以攻击主角
local BornWave = class("Game.Modules.Battle.Behaviors.BornArea",BaseBehavior)

---@param areaInfo AreaInfo
---@param waveInfo WaveInfo
---@param points table<number, UnityEngine.Vector3>
function BornWave:Ctor(areaInfo, waveInfo, points)
    BornWave.super.Ctor(self)
    self.areaInfo = areaInfo
    self.waveInfo = waveInfo
    self.points = points
    self.monsterList = {}
    AddEventListener(Event.Update, self.Update, self)
end

function BornWave:Update()

end

function BornWave:Refresh()
    self:DoRefresh()
end

function BornWave:Active()
    self:ForEach(Handler.New(self.Wakeup , self))
end

function BornWave:Visible(visible)
    self:ForEach(Handler.New(self.VisibleMonster, self, visible))
end

function BornWave:DoRefresh()
    local count = 1
    for i = 1, #self.waveInfo.borns do
        local bornInfo = self.waveInfo.borns[i]
        local num = math.random(bornInfo.minNum, bornInfo.maxNum)
        for n = 1, num do
            local monster = Monster.New(AvatarConfig.Clone(bornInfo.avatarName))
            table.insert(self.monsterList, monster)
            --self.monsterList[count] = monster
            monster.transform.position = self.points[count]
            monster:UpdateNode()
            monster.soonNode = monster.node
            monster:SetBehaviorEnable(true)
            count = count + 1
        end
    end
end

---@param func Handler
function BornWave:ForEach(func)
    for i = 1, #self.monsterList do
        func:Execute(self.monsterList[i])
    end
end


---@param monster Game.Modules.Battle.Items.Monster
function BornWave:Wakeup(monster)
    monster.isWakeup = true
end

---@param monster Game.Modules.Battle.Items.Monster
function BornWave:ActiveMonster(monster)
    monster:SetBehaviorEnable(true)
end


---@param monster Game.Modules.Battle.Items.Monster
function BornWave:VisibleMonster(visible, monster)
    monster:SetRenderObjVisible(visible)
end

---@param monster Game.Modules.Battle.Items.Monster
function BornWave:DisposeMonster(monster)
    monster:Dispose()
end

function BornWave:Clear()
    self.isActive = false
    self:ForEach(Handler.New(self.DisposeMonster, self))
end

function BornWave:Dispose()
    BornWave.super.Dispose(self)
end

return BornWave