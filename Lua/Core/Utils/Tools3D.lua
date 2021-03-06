---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zheng.
--- DateTime: 2019/5/26 22:30
---

local Tools3D = {}


---@param go UnityEngine.GameObject
---@param componentType table | userdata
---@param includeInactive boolean
function Tools3D.GetComponents(go, componentType, includeInactive)
    includeInactive = includeInactive or true
    local components = go:GetComponentsInChildren(componentType, includeInactive)
    return components
end

return Tools3D