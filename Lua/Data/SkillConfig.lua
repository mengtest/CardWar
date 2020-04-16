---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhengnan.
--- DateTime: 2019/5/6 17:35
---


---@class SkillInfo
---@field id string
---@field name string
---@field type number
---@field performance string

local SkillConfig = {}

---@return SkillInfo
function SkillConfig.Get(name)
    if SkillConfig.data == nil then
        SkillConfig.data = require("Game.Data.Excel.Skill")
    end
    local info = SkillConfig.data.Get(name) ---@type SkillInfo
    if info == nil then
        logError(string.format("There is not skill info named %s!", name))
    end
    return info
end

return SkillConfig