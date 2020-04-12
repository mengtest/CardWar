---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhengnan.
--- DateTime: 2020/2/25 10:12
---
---


--刷怪区域数据
---@class WaveBaseInfo
---@field areaId number 分组id
---@field type string 类型 boss , normal

local LuaMonoBehaviour = require("Betel.LuaMonoBehaviour")

---@class Game.Modules.Battle.Layouts.WaveBase : Betel.LuaMonoBehaviour
---@field waveInfo WaveBaseInfo
---@field context WorldContext
---@field isActive boolean
---@field itemList List | table<number, Game.Modules.World.Items.BattleItem>
local WaveBase = class("Game.Modules.Battle.Layouts.WaveBase",LuaMonoBehaviour)

---@param waveInfo WaveBaseInfo
function WaveBase:Ctor(waveInfo)
    WaveBase.super.Ctor(self)
    self.waveInfo = waveInfo
end

function WaveBase:Active()

end

function WaveBase:IsAllDead()

end

return WaveBase