-- Assembled by Narrev, but built by many intelligent people
-- @readme https://github.com/NevermoreFramework/Tween/blob/master/README.md

local Easing do
	--[[
		Disclaimer for Robert Penner's Easing Equations license:

		TERMS OF USE - EASING EQUATIONS

		Open source under the BSD License.

		Copyright © 2001 Robert Penner
		All rights reserved.

		Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

		* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
		* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
		* Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.

		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
		IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
		OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	]]

	-- For all easing functions:
	-- t = elapsed time
	-- b = beginning value
	-- c = change in value same as: ending - beginning
	-- d = duration (total time)

	-- Where applicable
	-- a = amplitude
	-- p = period

	local sin, cos, pi, abs, asin = math.sin, math.cos, math.pi, math.abs, math.asin
	local _2pi = 2 * pi
	local _halfpi = 0.5 * pi
	local SoftSpringpi = -3.2*pi
	local Springpi = 2*SoftSpringpi

	local function Linear(t, b, c, d)
		return c * t / d + b
	end

	local function Smooth(t, b, c, d)
		t = t / d
		return c * t * t * (3 - 2*t) + b
	end

	local function Smoother(t, b, c, d)
		t = t / d
		return c*t*t*t * (t * (6*t - 15) + 10) + b
	end

	-- Arceusinator's Easing Functions
	local function RevBack(t, b, c, d)
		t = 1 - t / d
		return c*(1 - (sin(t*_halfpi) + (sin(t*pi) * (cos(t*pi) + 1)*0.5))) + b
	end

	local function RidiculousWiggle(t, b, c, d)
		t = t / d
		return c*sin(sin(t*pi)*_halfpi) + b
	end

	-- YellowTide's Easing Functions
	local function Spring(t, b, c, d)
		t = t / d
		return (1 + (-2.72^(-6.9*t) * cos(Springpi*t))) * c + b
	end

	local function SoftSpring(t, b, c, d)
		t = t / d
		return (1 + (-2.72^(-7.5*t) * cos(SoftSpringpi*t))) * c + b
	end
	-- End of YellowTide's functions

	local function InQuad(t, b, c, d)
		t = t / d
		return c * t * t + b
	end

	local function OutQuad(t, b, c, d)
		t = t / d
		return -c * t * (t - 2) + b
	end

	local function InOutQuad(t, b, c, d)
		t = t / d * 2
		return t < 1 and c * 0.5 * t * t + b or -c * 0.5 * ((t - 1) * (t - 3) - 1) + b
	end

	local function OutInQuad(t, b, c, d)
		if t < d * 0.5 then
			t = 2 * t / d
			return -0.5 * c * t * (t - 2) + b
		else
			t, c = ((t * 2) - d) / d, 0.5 * c
			return c * t * t + b + c
		end
	end

	local function InCubic(t, b, c, d)
		t = t / d
		return c * t * t * t + b
	end

	local function OutCubic(t, b, c, d)
		t = t / d - 1
		return c * (t * t * t + 1) + b
	end

	local function InOutCubic(t, b, c, d)
		t = t / d * 2
		if t < 1 then
			return c * 0.5 * t * t * t + b
		else
			t = t - 2
			return c * 0.5 * (t * t * t + 2) + b
		end
	end

	local function OutInCubic(t, b, c, d)
		if t < d * 0.5 then
			t = t * 2 / d - 1
			return c * 0.5 * (t * t * t + 1) + b
		else
			t, c = ((t * 2) - d) / d, c * 0.5
			return c * t * t * t + b + c
		end
	end

	local function InQuart(t, b, c, d)
		t = t / d
		return c * t * t * t * t + b
	end

	local function OutQuart(t, b, c, d)
		t = t / d - 1
		return -c * (t * t * t * t - 1) + b
	end

	local function InOutQuart(t, b, c, d)
		t = t / d * 2
		if t < 1 then
			return c * 0.5 * t * t * t * t + b
		else
			t = t - 2
			return -c * 0.5 * (t * t * t * t - 2) + b
		end
	end

	local function OutInQuart(t, b, c, d)
		if t < d * 0.5 then
			t, c = t * 2 / d - 1, c * 0.5
			return -c * (t * t * t * t - 1) + b
		else
			t, c = ((t * 2) - d) / d, c * 0.5
			return c * t * t * t * t + b + c
		end
	end

	local function InQuint(t, b, c, d)
		t = t / d
		return c * t * t * t * t * t + b
	end

	local function OutQuint(t, b, c, d)
		t = t / d - 1
		return c * (t * t * t * t * t + 1) + b
	end

	local function InOutQuint(t, b, c, d)
		t = t / d * 2
		if t < 1 then
			return c * 0.5 * t * t * t * t * t + b
		else
			t = t - 2
			return c * 0.5 * (t * t * t * t * t + 2) + b
		end
	end

	local function OutInQuint(t, b, c, d)
		if t < d * 0.5 then
			t = t * 2 / d - 1
			return c * 0.5 * (t * t * t * t * t + 1) + b
		else
			t, c = ((t * 2) - d) / d, c * 0.5
			return c * t * t * t * t * t + b + c
		end
	end

	local function InSine(t, b, c, d)
		return -c * cos(t / d * _halfpi) + c + b
	end

	local function OutSine(t, b, c, d)
		return c * sin(t / d * _halfpi) + b
	end

	local function InOutSine(t, b, c, d)
		return -c * 0.5 * (cos(pi * t / d) - 1) + b
	end

	local function OutInSine(t, b, c, d)
		c = c * 0.5
		return t < d * 0.5 and c * sin(t * 2 / d * _halfpi) + b or -c * cos(((t * 2) - d) / d * _halfpi) + 2 * c + b
	end

	local function InExpo(t, b, c, d)
		return t == 0 and b or c * 2 ^ (10 * (t / d - 1)) + b - c * 0.001
	end

	local function OutExpo(t, b, c, d)
		return t == d and b + c or c * 1.001 * (1 - 2 ^ (-10 * t / d)) + b
	end

	local function InOutExpo(t, b, c, d)
		t = t / d * 2
		return t == 0 and b or t == 2 and b + c or t < 1 and c * 0.5 * 2 ^ (10 * (t - 1)) + b - c * 0.0005 or c * 0.5 * 1.0005 * (2 - 2 ^ (-10 * (t - 1))) + b
	end

	local function OutInExpo(t, b, c, d)
		c = c * 0.5
		return t < d * 0.5 and (t * 2 == d and b + c or c * 1.001 * (1 - 2 ^ (-20 * t / d)) + b) or t * 2 - d == 0 and b + c or c * 2 ^ (10 * ((t * 2 - d) / d - 1)) + b + c - c * 0.001
	end

	local function InCirc(t, b, c, d)
		t = t / d
		return -c * ((1 - t * t) ^ 0.5 - 1) + b
	end

	local function OutCirc(t, b, c, d)
		t = t / d - 1
		return c * (1 - t * t) ^ 0.5 + b
	end

	local function InOutCirc(t, b, c, d)
		t = t / d * 2
		if t < 1 then
			return -c * 0.5 * ((1 - t * t) ^ 0.5 - 1) + b
		else
			t = t - 2
			return c * 0.5 * ((1 - t * t) ^ 0.5 + 1) + b
		end
	end

	local function OutInCirc(t, b, c, d)
		c = c * 0.5
		if t < d * 0.5 then
			t = t * 2 / d - 1
			return c * (1 - t * t) ^ 0.5 + b
		else
			t = (t * 2 - d) / d
			return -c * ((1 - t * t) ^ 0.5 - 1) + b + c
		end
	end

	local function InElastic(t, b, c, d, a, p)
		t = t / d - 1
		p = p or d * 0.3
		return t == -1 and b or t == 0 and b + c or not a or a < abs(c) and -(c * 2 ^ (10 * t) * sin((t * d - p * .25) * _2pi / p)) + b or -(a * 2 ^ (10 * t) * sin((t * d - p / _2pi * asin(c/a)) * _2pi / p)) + b
	end

	local function OutElastic(t, b, c, d, a, p)
		t = t / d
		p = p or d * 0.3
		return t == 0 and b or t == 1 and b + c or not a or a < abs(c) and c * 2 ^ (-10 * t) * sin((t * d - p * .25) * _2pi / p) + c + b or a * 2 ^ (-10 * t) * sin((t * d - p / _2pi * asin(c / a)) * _2pi / p) + c + b
	end

	local function InOutElastic(t, b, c, d, a, p)
		if t == 0 then
			return b
		end

		t = t / d * 2 - 1

		if t == 1 then
			return b + c
		end

		p = p or d * .45
		a = a or 0

		local s

		if not a or a < abs(c) then
			a = c
			s = p * .25
		else
			s = p / _2pi * asin(c / a)
		end

		if t < 1 then
			return -0.5 * a * 2 ^ (10 * t) * sin((t * d - s) * _2pi / p) + b
		else
			return a * 2 ^ (-10 * t) * sin((t * d - s) * _2pi / p ) * 0.5 + c + b
		end
	end

	local function OutInElastic(t, b, c, d, a, p)
		if t < d * 0.5 then
			return OutElastic(t * 2, b, c * 0.5, d, a, p)
		else
			return InElastic(t * 2 - d, b + c * 0.5, c * 0.5, d, a, p)
		end
	end

	local function InBack(t, b, c, d, s)
		s = s or 1.70158
		t = t / d
		return c * t * t * ((s + 1) * t - s) + b
	end

	local function OutBack(t, b, c, d, s)
		s = s or 1.70158
		t = t / d - 1
		return c * (t * t * ((s + 1) * t + s) + 1) + b
	end

	local function InOutBack(t, b, c, d, s)
		s = (s or 1.70158) * 1.525
		t = t / d * 2
		if t < 1 then
			return c * 0.5 * (t * t * ((s + 1) * t - s)) + b
		else
			t = t - 2
			return c * 0.5 * (t * t * ((s + 1) * t + s) + 2) + b
		end
	end

	local function OutInBack(t, b, c, d, s)
		c = c * 0.5
		s = s or 1.70158
		if t < d * 0.5 then
			t = (t * 2) / d - 1
			return c * (t * t * ((s + 1) * t + s) + 1) + b
		else
			t = ((t * 2) - d) / d
			return c * t * t * ((s + 1) * t - s) + b + c
		end
	end

	local function OutBounce(t, b, c, d)
		t = t / d
		if t < 1 / 2.75 then
			return c * (7.5625 * t * t) + b
		elseif t < 2 / 2.75 then
			t = t - (1.5 / 2.75)
			return c * (7.5625 * t * t + 0.75) + b
		elseif t < 2.5 / 2.75 then
			t = t - (2.25 / 2.75)
			return c * (7.5625 * t * t + 0.9375) + b
		else
			t = t - (2.625 / 2.75)
			return c * (7.5625 * t * t + 0.984375) + b
		end
	end

	local function InBounce(t, b, c, d)
		return c - OutBounce(d - t, 0, c, d) + b
	end

	local function InOutBounce(t, b, c, d)
		if t < d * 0.5 then
			return InBounce(t * 2, 0, c, d) * 0.5 + b
		else
			return OutBounce(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b
		end
	end

	local function OutInBounce(t, b, c, d)
		if t < d * 0.5 then
			return OutBounce(t * 2, b, c * 0.5, d)
		else
			return InBounce(t * 2 - d, b + c * 0.5, c * 0.5, d)
		end
	end

	Easing = {
		Linear = Linear; Spring = Spring; SoftSpring = SoftSpring; RevBack = RevBack; RidiculousWiggle = RidiculousWiggle; Smooth = Smooth; Smoother = Smoother;

		InQuad    = InQuad;    OutQuad    = OutQuad;    InOutQuad    = InOutQuad;    OutInQuad    = OutInQuad;
		InCubic   = InCubic;   OutCubic   = OutCubic;   InOutCubic   = InOutCubic;   OutInCubic   = OutInCubic;
		InQuart   = InQuart;   OutQuart   = OutQuart;   InOutQuart   = InOutQuart;   OutInQuart   = OutInQuart;
		InQuint   = InQuint;   OutQuint   = OutQuint;   InOutQuint   = InOutQuint;   OutInQuint   = OutInQuint;
		InSine    = InSine;    OutSine    = OutSine;    InOutSine    = InOutSine;    OutInSine    = OutInSine;
		InExpo    = InExpo;    OutExpo    = OutExpo;    InOutExpo    = InOutExpo;    OutInExpo    = OutInExpo;
		InCirc    = InCirc;    OutCirc    = OutCirc;    InOutCirc    = InOutCirc;    OutInCirc    = OutInCirc;
		InElastic = InElastic; OutElastic = OutElastic; InOutElastic = InOutElastic; OutInElastic = OutInElastic;
		InBack    = InBack;    OutBack    = OutBack;    InOutBack    = InOutBack;    OutInBack    = OutInBack;
		InBounce  = InBounce;  OutBounce  = OutBounce;  InOutBounce  = InOutBounce;  OutInBounce  = OutInBounce;
	}
end

local typeof = typeof
local setmetatable = setmetatable

local Lerps do
	local function Lerp(start, finish, alpha)
		return start + alpha * (finish - start)
	end

	local newRect = Rect.new
	local newUDim = UDim.new
	local newUDim2 = UDim2.new
	local newCFrame = CFrame.new
	local newColor3 = Color3.new
	local newVector2 = Vector2.new
	local newVector3 = Vector3.new
	local newRegion3 = Region3.new
	local newNumberRange = NumberRange.new
	local newColorSequence = ColorSequence.new
	local newNumberSequence = NumberSequence.new
	local newPhysicalProperties = PhysicalProperties.new
	local newNumberSequenceKeypoint = NumberSequenceKeypoint.new
	local Color3Lerp = newColor3().Lerp;

	local sortByTime = function(a, b)
		return a.Time < b.Time
	end

	local insert = table.insert
	local sort = table.sort

	Lerps = {
		number = Lerp;
		Color3 = Color3Lerp;
		UDim2 = newUDim2().Lerp;
		CFrame = newCFrame().Lerp;
		Vector2 = newVector2().Lerp;
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

local RunService = game:GetService("RunService")
local Heartbeat = RunService.Heartbeat
local Connect = Heartbeat.Connect
local Wait = Heartbeat.Wait

local Disconnect do
	local Connection = Connect(Heartbeat, function() end)
	Disconnect = Connection.Disconnect
	Disconnect(Connection)
end

local Completed, Canceled = Enum.TweenStatus.Completed, Enum.TweenStatus.Canceled

local function StopTween(self, Finished)
	if self.Running then
		Disconnect(self.Connection)
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
		self.Connection = Connect(Heartbeat, self.Interpolator)
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
	repeat until not self.Running or not Wait(Heartbeat)
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

local Tweens = {EasingFunctions = Easing}
local Tween = {OpenTweens = Tweens}
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
		if Duration > ElapsedTime then
			ElapsedTime = ElapsedTime + Step
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
		if Duration > ElapsedTime then
			ElapsedTime = ElapsedTime + Step
			Callback(EasingFunction(ElapsedTime, 0, 1, Duration))
		else
			Callback(1)
			StopTween(self)
		end
	end

	return ResumeTween(self)
end

return setmetatable(Tween, Tween)
