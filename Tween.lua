-- @author Validark
-- @readme https://github.com/RoStrap/Tween

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local require = require(ReplicatedStorage:WaitForChild("Resources")).LoadLibrary
local Easing = require("Easing")
local Lerps = require("Lerps")

local Heartbeat = RunService.Heartbeat

local Completed = Enum.TweenStatus.Completed
local Canceled = Enum.TweenStatus.Canceled

local function StopTween(self, Finished)
	if self.Running then
		self.Connection:Disconnect()
		self.Running = false
		local ObjectTable = self.ObjectTable
		if ObjectTable then
			ObjectTable[self.Property] = nil -- This is for override checks
		end
	end
	local Callback = self.Callback
	if Callback then
		Callback(Finished and Completed or Canceled)
	end
	return self
end

local function ResumeTween(self)
	if not self.Running then
		self.Connection = Heartbeat:Connect(self.Interpolator)
		self.Running = true
		local ObjectTable = self.ObjectTable
		if ObjectTable then
			ObjectTable[self.Property] = self -- This is for override checks
		end
		return self
	end
end

local function RestartTween(self)
	return ResumeTween(self:ResetElapsedTime())
end

local function WaitTween(self)
	repeat until not self.Running or not Heartbeat:Wait()
	return self
end

local TweenObject = {
	Running = false;
	Wait = WaitTween;
	Stop = StopTween;
	Resume = ResumeTween;
	Restart = RestartTween;
}
TweenObject.__index = TweenObject

local Tweens = {}
local Tween = {
	OpenTweens = Tweens;
	EasingFunctions = Easing;
}

function Tween:__call(Object, Property, EndValue, EasingDirection, EasingStyle, Duration, Override, Callback, PropertyType)
	-- @param Object object OR Table object OR Void Function receiver(String propertyName, Variant value),
	-- @param String Property,
	-- @param Variant EndValue
	-- @param Number time
	-- @param String EasingName

	Duration = Duration or 1

	local EasingFunction = typeof(EasingDirection)

	if typeof(EasingStyle) == "EnumItem" then
		EasingStyle = EasingStyle.Name
	end

	if EasingFunction == "EnumItem" then
		EasingDirection = EasingDirection.Name
	end

	if EasingFunction == "function" then
		EasingFunction = EasingDirection
	else
		EasingFunction = Easing[EasingDirection and EasingDirection .. EasingStyle or EasingStyle] or Easing[EasingStyle]
	end

	local StartValue = Object[Property]
	local Lerp = Lerps[PropertyType or typeof(EndValue)]
	local ElapsedTime, Connection = 0
	local self = setmetatable({Callback = Callback; Property = Property}, TweenObject)
	local ObjectTable = Tweens[Object]

	if ObjectTable then
		local OpenTween = ObjectTable[Property]
		if OpenTween then
			if Override then
				StopTween(OpenTween)
			else
				return StopTween(self) -- warn("Could not Tween", tostring(Object) .. "." .. Property, "to", EndValue))
			end
		end
	else
		ObjectTable = {}
		Tweens[Object] = ObjectTable
	end

	function self:ResetElapsedTime()
		ElapsedTime = 0
		return self
	end

	function self.Interpolator(Step)
		ElapsedTime = ElapsedTime + Step
		if Duration > ElapsedTime then
			Object[Property] = Lerp(StartValue, EndValue, EasingFunction(ElapsedTime, 0, 1, Duration))
		else
			StopTween(self, true)
			Object[Property] = EndValue
		end
	end

	ObjectTable[Property] = self
	self.ObjectTable = ObjectTable

	return ResumeTween(self)
end

function Tween.new(Duration, EasingFunction, Callback)
	Duration = Duration or 1

	if type(EasingFunction) == "string" then
		EasingFunction = Easing[EasingFunction]
	end

	local ElapsedTime = 0
	local self = setmetatable({}, TweenObject)

	function self:ResetElapsedTime()
		ElapsedTime = 0
		return self
	end

	function self.Interpolator(Step)
		ElapsedTime = ElapsedTime + Step
		if Duration > ElapsedTime then
			Callback(EasingFunction(ElapsedTime, 0, 1, Duration))
		else
			Callback(1)
			StopTween(self)
		end
	end

	return ResumeTween(self)
end

return setmetatable(Tween, Tween)
