---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhengnan.
--- DateTime: 2019/5/6 11:56
---

local Widget = require("Game.Modules.Common.Components.Widget")

---@class Game.Modules.Common.Components.AttachCamera : Game.Modules.Common.Components.Widget
---@field New fun(camera:UnityEngine.Camera) : Game.Modules.Common.Components.AttachCamera
---@field camera UnityEngine.Camera
---@field attachCam Framework.AttachCamera
---@field target UnityEngine.GameObject
---@field orgTarget UnityEngine.GameObject
local AttachCamera = class("Game.Modules.Common.Components.AttachCamera", Widget)

---@param camera UnityEngine.Camera
function AttachCamera:Ctor(camera, radius, angle, offset)
    AttachCamera.super.Ctor(self,camera.gameObject)
    self.camera = camera
    offset = offset or Vector3.zero
    self.orgFieldOfView = self.camera.fieldOfView
    self.attachCam = camera.gameObject:AddComponent(typeof(Framework.AttachCamera))
    self.attachCam:Init(camera)
    self.attachCam.offset = offset
    self:SetZoomLevel(radius, angle)
end

function AttachCamera:SetZoomLevel(radius, angle)
    self.attachCam.radius = radius
    self.attachCam.angle = angle
end

function AttachCamera:Reset()
    self.attachCam:Reset()
end

function AttachCamera:TempAttach(newTarget)
    self.orgTarget = self.target
    self.attachCam:Attach(newTarget)
end

function AttachCamera:ResetOrgTarget()
    if self.orgTarget then
        self.attachCam:Attach(self.orgTarget)
        self.orgTarget = nil
    end
end

function AttachCamera:Attach(target)
    self.target = target
    self.attachCam:Attach(target)
end

function AttachCamera:AttachPos(pos, attachCallback, smooth)
    if smooth ~= nil then
        self.attachCam.isSmooth = smooth
    end
    self.attachCam:AttachPos(pos,attachCallback)
end

function AttachCamera:StartAttach()
    self.attachCam.isAttaching = true
end

function AttachCamera:StopAttach()
    self.attachCam.isAttaching = false
end

function AttachCamera:SetSmooth(isSmooth)
    self.attachCam.isSmooth = isSmooth
end

function AttachCamera:AttachImmediately()

end

--镜头拉近
function AttachCamera:MoveZoomIn(duration, zoom, callback, onlyZoom)

end

--镜头复位
function AttachCamera:MoveZoomOut(duration, callback, onlyZoom)

end

function AttachCamera:FovZoomIn(duration, overCallback, addFov)
    addFov = addFov or 5
    local sequence = self:CreateSequence()
    self.camera:DOPause()
    sequence:Append(self.camera:DOFieldOfView(self.orgFieldOfView + addFov, duration))
    if overCallback then
        sequence:AppendCallback(overCallback)
    end
    return sequence
end

function AttachCamera:FovZoomOut(duration, overCallback)
    local sequence = self:CreateSequence()
    sequence:Append(self.camera:DOFieldOfView(self.orgFieldOfView, duration))
    if overCallback then
        sequence:AppendCallback(overCallback)
    end
    return sequence
end

---@param shake string
function AttachCamera:Shake(shake)
    --相机抖动
    if not StringUtil.IsEmpty(shake)  then
        self:ShakeCamera(CameraShakeConfig.Get(shake))
    end
end

---@param shake ShakeCamera
function AttachCamera:ShakeCamera(shake)
    if not shake or self.noShake == true then
        return
    end
    shake.vibrato = shake.vibrato or 50
    shake.randomness = shake.randomness or 3
    local strength = shake.strengthVector3
    if strength == Vector3.zero or strength == nil then
        shake.strength = shake.strength or 0.5
        strength = Vector3.New(0, shake.strength, 0)
    end
    self.attachCam:ShakeCamera(shake.delay, shake.duration, strength, shake.vibrato,shake.randomness)
end

function AttachCamera:ShakeCameraStop()
    self.attachCam:ShakeCameraStop()
end

function AttachCamera:OnFullViewIsShow(event)
end

function AttachCamera:CampVisualAngel(enable, attachCallback)

end

function AttachCamera:Dispose()
    self.attachCam:Dispose()
    Destroy(self.attachCam)
end

return AttachCamera