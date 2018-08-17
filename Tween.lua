-- Light-weight, Bezier-friendly Property Tweening
-- @author Validark

local Resources = require(game:GetService("ReplicatedStorage"):WaitForChild("Resources"))
local Lerps = Resources:LoadLibrary("Lerps")
local Table = Resources:LoadLibrary("Table")
local Typer = Resources:LoadLibrary("Typer")
local Enumeration = Resources:LoadLibrary("Enumeration")
local EasingFunctions = Resources:LoadLibrary("EasingFunctions")

local Heartbeat = game:GetService("RunService").Heartbeat

local Completed = Enum.TweenStatus.Completed
local Canceled = Enum.TweenStatus.Canceled
local Linear = EasingFunctions[Enumeration.EasingFunction.Linear.Value]

local Tween = {
	__index = {
		Running = false;
		Duration = 1;
		ElapsedTime = 0;
		EasingFunction = EasingFunctions[Enumeration.EasingFunction.Standard.Value];
		LerpFunction = function(StartValue, EndValue, Alpha) return EndValue end;
	}
}

local OpenTweens = {} -- Will prevent objects from getting garbage collected until Tween finishes

Tween.new = Typer.AssignSignature(Typer.OptionalNumber, Typer.OptionalFunctionOrEnumerationOfTypeEasingFunction, Typer.FunctionOrTableOrUserdata, Typer.Any, function(Duration, EasingFunction, Callback, Arg)
	Duration = Duration or 1
	EasingFunction = EasingFunction or Linear

	local self = setmetatable({
		Duration = Duration;
		Callback = Callback;
		EasingFunction = EasingFunction;
		Arg = Arg;
	}, Tween)

	function self.Interpolator(Step)
		local ElapsedTime = self.ElapsedTime + Step
		self.ElapsedTime = ElapsedTime

		if Duration > ElapsedTime then
			local x = EasingFunction(ElapsedTime, 0, 1, Duration)
			if Arg ~= nil then
				Callback(Arg, x)
			else
				Callback(x)
			end
		else
			if Arg ~= nil then
				Callback(Arg, 1)
			else
				Callback(1)
			end
			self:Stop()
		end
	end

	return self:Resume()
end)

function Tween.__index:Stop(Finished)
	if self.Running then
		self.Connection:Disconnect()
		self.Running = false
		local ObjectTable = OpenTweens[self.Object]
		if ObjectTable then
			ObjectTable[self.Property] = nil -- This is for override checks
		end
	end
	local Callback = self.FinishedCallback
	if Callback == true then
		if Finished then
			self.Object:Destroy()
		end
	elseif Callback then
		if self.CallbackArg ~= nil then
			Callback(self.CallbackArg, Finished and Completed or Canceled)
		else
			Callback(Finished and Completed or Canceled)
		end
	end
	return self
end

function Tween.__index:Resume()
	if self.Duration == 0 then
		self.Object[self.Property] = self.EndValue
	else
		if not self.Running then
			self.Connection = Heartbeat:Connect(self.Interpolator)
			self.Running = true
			local ObjectTable = OpenTweens[self.Object]
			if ObjectTable then
				ObjectTable[self.Property] = self -- This is for override checks
			end
		end
	end
	return self
end

function Tween.__index:Restart()
	self.ElapsedTime = 0
	return self:Resume()
end

function Tween.__index:Wait()
	repeat until not self.Running or not Heartbeat:Wait()
	return self
end

return Table.Lock(Tween, Typer.AssignSignature(5, Typer.OptionalFunctionOrEnumerationOfTypeEasingFunction, Typer.OptionalNumber, Typer.OptionalBoolean, Typer.OptionalFunctionOrTableOrUserdata, Typer.Any, function(_, Object, Property, EndValue, EasingFunction, Duration, Override, Callback, CallbackArg)
	Duration = Duration or 1
	local LerpFunction = Lerps[typeof(EndValue)]
	local StartValue = Object[Property]
	EasingFunction = EasingFunction or Linear

	local self = setmetatable({
		Duration = Duration;
		StartValue = StartValue;
		EndValue = EndValue;
		LerpFunction = LerpFunction;
		Object = Object;
		FinishedCallback = Callback;
		Property = Property;
		EasingFunction = EasingFunction;
		CallbackArg = CallbackArg;
	}, Tween)

	function self.Interpolator(Step)
		local ElapsedTime = self.ElapsedTime + Step
		self.ElapsedTime = ElapsedTime

		if Duration > ElapsedTime then
			Object[Property] = LerpFunction(StartValue, EndValue, EasingFunction(ElapsedTime, 0, 1, Duration))
		else
			self:Stop(true)
			Object[Property] = EndValue
		end
	end

	local ObjectTable = OpenTweens[Object] -- Handle Overriding Interpolations

	if ObjectTable then
		local OpenTween = ObjectTable[Property]
		if OpenTween then
			if Override then
				OpenTween:Stop()
			else
				return self:Stop()
			end
		end
	else
		ObjectTable = {}
		OpenTweens[Object] = ObjectTable
	end

	ObjectTable[Property] = self

	return self:Resume()
end))
