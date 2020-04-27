---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhengnan.
--- DateTime: 2019/10/31 18:01
--- 行为策略
---

local LuaObject = require("Betel.LuaObject")

---@class Game.Modules.Battle.Behaviors.Strategy.BehaviorStrategyBase:LuaObject
---@field New fun(avatar : Game.Modules.World.Items.Avatar)
---@field battleUnit Game.Modules.World.Items.BattleUnit
---@field aiParam table<string, any> --AI参数
---@field skills table<number, Game.Modules.Battle.Vo.SkillVo>
---@field canUseList table<number, Game.Modules.Battle.Vo.SkillVo>
---@field currSelectedSkill Game.Modules.Battle.Vo.SkillVo 当前被选中的技能
---@field lastTarget Game.Modules.World.Items.Avatar
---@field currTargetAttackNum number 当前目标被攻击的次数
---@field targetStartAttackTime number 当前目标被攻击的时间
local BehaviorStrategyBase = class("Game.Modules.Battle.Behaviors.Strategy.BehaviorStrategyBase",LuaObject)


---@param battleUnit Game.Modules.World.Items.BattleUnit
function BehaviorStrategyBase:Ctor(battleUnit)
    self.battleUnit = battleUnit
    self.skills = battleUnit.battleUnitVo.skills
    self.currTargetAttackNum = 0
    self.aiParam = Tool.String2Map(self.battleUnit.avatarInfo.aiParam)
    self.canUseList = List.New()
end


---@param s1 Game.Modules.Battle.Vo.SkillVo
---@param s2 Game.Modules.Battle.Vo.SkillVo
local function compFunc(s1, s2)
    if s1 ~= nil and s2 ~= nil then
        return s1.skillInfo.priority > s2.skillInfo.priority
    else
        return false
    end
end

---@return Game.Modules.Battle.Vo.SkillVo
function BehaviorStrategyBase:AutoSelectSkill()
    self.canUseList:Clear()
    for i = 1, #self.skills do
        local skill = self.skills[i] ---@type Game.Modules.Battle.Vo.SkillVo
        if skill.isNecessary then --必然触发的技能
            self.canUseList:Clear()
            self.canUseList:Add(skill)
        else
            if skill.skillInfo.skillType == SkillType.Passive then
                -- do nothing
            elseif skill.skillInfo.cd == 0 or skill.startTime == 0 or Time.time - skill.startTime > skill.skillInfo.cd then
                if skill.skillInfo.triggerCondition == SkillTriggerCondition.CD then -- CD
                    self.canUseList:Add(skill)
                elseif skill.skillInfo.triggerCondition == SkillTriggerCondition.FullAnger then -- 满怒气
                    if self.battleUnit.battleUnitVo.curAnger >= self.battleUnit.battleUnitVo.maxAnger then
                        self.canUseList:Add(skill)
                    end
                elseif skill.skillInfo.triggerCondition == SkillTriggerCondition.Prob then -- 触发概率
                    local prob = math.random()
                    if prob <= tonumber(skill.skillInfo.triggerConditionParam) then
                        self.canUseList:Add(skill)
                    end
                end
            end
        end
    end
    if self.canUseList:Size() > 0 then
        self.canUseList:Sort(compFunc)
        self.canUseList[1].isNecessary = false
        self.currSelectedSkill = self.canUseList[1]
        --self.battleUnit:_debug(self.currSelectedSkill.id)
        --这里暂时默认这个技能肯定被触发了,做一些初始操作
        self.currTargetAttackNum = self.currTargetAttackNum + 1
    else
        --self.avatar:_debugError("there is no skill can use!!")
        self.currSelectedSkill = nil
    end
    return self.currSelectedSkill
end

-- 设置必要技能
---@return Game.Modules.Battle.Vo.SkillVo
function BehaviorStrategyBase:SetNecessarySkill(skillName)
    for i = 1, #self.skills do
        if self.skills[i].skillInfo.id == skillName then
            self.skills[i].isNecessary = true
        end
    end
end

---@return Game.Modules.World.Items.Avatar
function BehaviorStrategyBase:AutoSelectTarget()

end

--目标优先规则
---@return Game.Modules.World.Items.Avatar
function BehaviorStrategyBase:FetchTarget()

end

--目标是否需要跟换
---@return Game.Modules.World.Items.Avatar
function BehaviorStrategyBase:CheckTargetNeedChange()

end

return BehaviorStrategyBase