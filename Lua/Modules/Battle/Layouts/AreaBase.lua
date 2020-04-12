---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhengnan.
--- DateTime: 2020/2/25 10:12
---
---


--刷怪区域数据
---@class AreaBaseInfo
---@field areaId number 分组id
---@field type string 类型 boss , normal

local LuaMonoBehaviour = require("Betel.LuaMonoBehaviour")

---@class Game.Modules.Battle.Layouts.AreaBase : Betel.LuaMonoBehaviour
---@field areaInfo AreaInfo
---@field context WorldContext
---@field waves table<number,Game.Modules.Battle.Layouts.WaveBase>  怪物每波刷新数据
---@field waveQueue table<number,Game.Modules.Battle.Layouts.WaveBase>  怪物每波刷新数据
---@field currWave Game.Modules.Battle.Layouts.WaveBase
---@field isRefreshOver boolean
---@field isBornOver boolean
---@field isActive boolean
local AreaBase = class("Game.Modules.Battle.Layouts.AreaBase",LuaMonoBehaviour)

---@param areaInfo AreaInfo
function AreaBase:Ctor(areaInfo)
    AreaBase.super.Ctor(self)
    self.areaInfo = areaInfo
end

function AreaBase:Active()

end

function AreaBase:IsAllDead()

end

function AreaBase:IsAllDeadOver()

end

--获取刷新区域的最近点
function AreaBase:GetWaveAreaPoint(src, radius)
end

function AreaBase:Dispose()

end
return AreaBase