-- @author Validark
-- @readme https://github.com/RoStrap/Tween

local RunService = game:GetService("RunService")
local Easing = require(game:GetService("ReplicatedStorage"):WaitForChild("Resources")).LoadLibrary("Easing")
local Lerps do
	-- Lerp functions for various property types
	-- @author Validark
	-- @author Sharksie (NumberSequence Lerp)
	
	local newRect = Rect.new
	local newUDim = UDim.new
	local newRegion3 = Region3.new
	local newVector3 = Vector3.new
	local newNumberRange = NumberRange.new
	local newColorSequence = ColorSequence.new
	local newNumberSequence = NumberSequence.new
	local newPhysicalProperties = PhysicalProperties.new
	local newNumberSequenceKeypoint = NumberSequenceKeypoint.new
	
	local function Lerp(start, finish, alpha)
		return start + alpha * (finish - start)
	end
	
	local Color3Lerp = Color3.new().Lerp;
	
	local function sortByTime(a, b)
		return a.Time < b.Time
	end
	
	local insert = table.insert
	local sort = table.sort
	
	Lerps = {
		number = Lerp;
		Color3 = Color3Lerp;
		UDim2 = UDim2.new().Lerp;
		CFrame = CFrame.new().Lerp;
		Vector2 = Vector2.new().Lerp;
		Vector3 = newVector3().Lerp;
	
		UDim = function(start, finish, alpha)
			return newUDim(Lerp(start.Scale, finish.Scale, alpha), Lerp(start.Offset, finish.Offset, alpha))
		end;
	
		Rect = function(start, finish, alpha)
			return newRect(
				Lerp(start.Min.X, finish.Min.X, alpha), Lerp(start.Min.Y, finish.Min.Y, alpha),
				Lerp(start.Max.X, finish.Max.X, alpha), Lerp(start.Max.Y, finish.Max.Y, alpha)
			)
		end;
	
		PhysicalProperties = function(start, finish, alpha)
			return newPhysicalProperties(
				Lerp(start.Density, finish.Density, alpha),
				Lerp(start.Friction, finish.Friction, alpha),
				Lerp(start.Elasticity, finish.Elasticity, alpha),
				Lerp(start.FrictionWeight, finish.FrictionWeight, alpha),
				Lerp(start.ElasticityWeight, finish.ElasticityWeight, alpha)
			)
		end;
	
		NumberRange = function(start, finish, alpha)
			return newNumberRange(Lerp(start.Min, finish.Min, alpha), Lerp(start.Max, finish.Max, alpha))
		end;
	
		ColorSequence = function(start, finish, alpha)
			return newColorSequence(Color3Lerp(start[1], finish[1], alpha), Color3Lerp(start[2], finish[2], alpha))
		end;
	
		Region3 = function(start, finish, alpha) -- @author Sharksie
			local imin = Lerp(start.CFrame * (-start.Size*0.5), finish.CFrame * (-finish.Size*0.5), alpha)
			local imax = Lerp(start.CFrame * ( start.Size*0.5), finish.CFrame * ( finish.Size*0.5), alpha)
	
			local iminx = imin.x
			local imaxx = imax.x
			local iminy = imin.y
			local imaxy = imax.y
			local iminz = imin.z
			local imaxz = imax.z
	
			return newRegion3(
				newVector3(iminx < imaxx and iminx or imaxx, iminy < imaxy and iminy or imaxy, iminz < imaxz and iminz or imaxz),
				newVector3(iminx > imaxx and iminx or imaxx, iminy > imaxy and iminy or imaxy, iminz > imaxz and iminz or imaxz)
			)
		end;
	
		NumberSequence = function(start, finish, alpha) -- @author Sharksie
			--[[
				For each point on each line, find the values of the other sequence at that point in time through interpolation
					then interpolate between the known value and the learned value
					then use that value to create a new keypoint at the time
					then build a new sequence using all the keypoints generated
			--]]
	
			local keypoints = {}
			local addedTimes = {}
	
			for i, ap in next, start.Keypoints do
				local closestAbove, closestBelow
	
				for i, bp in next, finish.Keypoints do
					if bp.Time == ap.Time then
						closestAbove, closestBelow = bp, bp
						break
					elseif bp.Time < ap.Time and (closestBelow == nil or bp.Time > closestBelow.Time) then
						closestBelow = bp
					elseif bp.Time > ap.Time and (closestAbove == nil or bp.Time < closestAbove.Time) then
						closestAbove = bp
					end
				end
	
				local bValue, bEnvelope
				if closestAbove == closestBelow then
					bValue, bEnvelope = closestAbove.Value, closestAbove.Envelope
				else
					local p = (ap.Time - closestBelow.Time)/(closestAbove.Time - closestBelow.Time)
					bValue = (closestAbove.Value - closestBelow.Value)*p + closestBelow.Value
					bEnvelope = (closestAbove.Envelope - closestBelow.Envelope)*p + closestBelow.Envelope
				end
				local interValue = (bValue - ap.Value)*alpha + ap.Value
				local interEnvelope = (bEnvelope - ap.Envelope)*alpha + ap.Envelope
				local interp = newNumberSequenceKeypoint(ap.Time, interValue, interEnvelope)
	
				insert(keypoints, interp)
	
				addedTimes[ap.Time] = true
			end
	
			for i, bp in next, finish.Keypoints do
				if not addedTimes[bp.Time] then
					local closestAbove, closestBelow
	
					for i, ap in next, start.Keypoints do
						if ap.Time == bp.Time then
							closestAbove, closestBelow = ap, ap
							break
						elseif ap.Time < bp.Time and (closestBelow == nil or ap.Time > closestBelow.Time) then
							closestBelow = ap
						elseif ap.Time > bp.Time and (closestAbove == nil or ap.Time < closestAbove.Time) then
							closestAbove = ap
						end
					end
	
					local aValue, aEnvelope
					if closestAbove == closestBelow then
						aValue, aEnvelope = closestAbove.Value, closestAbove.Envelope
					else
						local p = (bp.Time - closestBelow.Time)/(closestAbove.Time - closestBelow.Time)
						aValue = (closestAbove.Value - closestBelow.Value)*p + closestBelow.Value
						aEnvelope = (closestAbove.Envelope - closestBelow.Envelope)*p + closestBelow.Envelope
					end
					local interValue = (bp.Value - aValue)*alpha + aValue
					local interEnvelope = (bp.Envelope - aEnvelope)*alpha + aEnvelope
					local interp = newNumberSequenceKeypoint(bp.Time, interValue, interEnvelope)
	
					insert(keypoints, interp)
				end
			end
	
			sort(keypoints, sortByTime)
	
			return newNumberSequence(keypoints)
		end;
	}
end

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
	
	if type(EasingStyle) == "number" then
		Duration, Override, Callback, PropertyType = EasingStyle, Duration, Override, Callback
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
