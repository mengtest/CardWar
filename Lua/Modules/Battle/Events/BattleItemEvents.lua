---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhengnan.
--- DateTime: 2019/5/2 16:38
---

---@class Game.Modules.World.Events.BattleItemEvents
---@field target Game.Modules.World.Items.Avatar
---@field hero Game.Modules.World.Items.Hero
---@field monster Module.World.Items.Monster
---@field callback Handler
local BattleItemEvents = {}

--怪物登场
BattleItemEvents.BattleItemBorn = "BattleItemBorn"

--怪物单位死亡
BattleItemEvents.BattleItemDead = "BattleItemDead"

--怪物单位死亡结束
BattleItemEvents.BattleItemDeadOver = "BattleItemDeadOver"


function BattleItemEvents.Dispatch(event)
    DispatchEvent(BattleItemEvents,event,false, false)
end

---@param item Game.Modules.World.Events.BattleItemEvents
function BattleItemEvents.DispatchItemEvent(type, item)
    local event = {}
    event.type = type
    event.target = item
    DispatchEvent(BattleItemEvents,event,false, false)
end

return BattleItemEvents