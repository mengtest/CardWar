---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhengnan.
--- DateTime: 2018/6/12 10:37
---

local IocContext = require("Betel.Ioc.IocContext")
local MediatorContext = class("MediatorContext",IocContext)

function MediatorContext:Ctor(binder)
    self.binder = binder
end

function MediatorContext:GetMediator(viewName)
    local mdrClass = self.binder.typeDict[viewName]
    if mdrClass == nil then
        logError("View:{0} mediator has not register",viewName)
    end
    return mdrClass
end

function MediatorContext:Launch()
    --TODO
	self.binder:Bind(require("Game.Modules.Battle.View.BattleEditorMdr")):To(ViewConfig.BattleEditor.name)
	self.binder:Bind(require("Game.Modules.Battle.View.BattleInfoMdr")):To(ViewConfig.BattleInfo.name)
	self.binder:Bind(require("Game.Modules.Battle.View.BattleMdr")):To(ViewConfig.Battle.name)
	self.binder:Bind(require("Game.Modules.Joystick.View.JoystickMdr")):To(ViewConfig.Joystick.name)
	self.binder:Bind(require("Game.Modules.Loading.View.LoadingMdr")):To(ViewConfig.Loading.name)
	self.binder:Bind(require("Game.Modules.Lobby.View.NavigationMdr")):To(ViewConfig.Navigation.name)
	self.binder:Bind(require("Game.Modules.Login.View.LoginMdr")):To(ViewConfig.Login.name)
	self.binder:Bind(require("Game.Modules.Login.View.LoginSceneMdr")):To(ViewConfig.LoginScene.name)
	self.binder:Bind(require("Game.Modules.Login.View.NoticeMdr")):To(ViewConfig.Notice.name)
	self.binder:Bind(require("Game.Modules.Login.View.RoleCreateMdr")):To(ViewConfig.RoleCreate.name)
	self.binder:Bind(require("Game.Modules.Login.View.RoleSelectMdr")):To(ViewConfig.RoleSelect.name)
	self.binder:Bind(require("Game.Modules.Login.View.ServerListMdr")):To(ViewConfig.ServerList.name)
	self.binder:Bind(require("Game.Modules.Player.View.PlayerInfoMdr")):To(ViewConfig.PlayerInfo.name)
	self.binder:Bind(require("Game.Modules.Role.View.RoleInfoMdr")):To(ViewConfig.RoleInfo.name)
	self.binder:Bind(require("Game.Modules.World.View.WorldMdr")):To(ViewConfig.World.name)
    --TODO
end

return MediatorContext
