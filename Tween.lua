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
	local softspringpi = -3.2*pi
	local springpi = 2*softspringpi

	local function linear(t, b, c, d)
		return c * t / d + b
	end

	local function smooth(t, b, c, d)
		t = t / d
		return c * t * t * (3 - 2*t) + b
	end

	local function smoother(t, b, c, d)
		t = t / d
		return c*t*t*t * (t * (6*t - 15) + 10) + b
	end

	-- Arceusinator's Easing Functions
	local function revBack(t, b, c, d)
		t = 1 - t / d
		return c*(1 - (sin(t*_halfpi) + (sin(t*pi) * (cos(t*pi) + 1)*0.5))) + b
	end

	local function ridiculousWiggle(t, b, c, d)
		t = t / d
		return c*sin(sin(t*pi)*_halfpi) + b
	end

	-- YellowTide's Easing Functions
	local function spring(t, b, c, d)
		t = t / d
		return (1 + (-2.72^(-6.9*t) * cos(springpi*t))) * c + b
	end

	local function softSpring(t, b, c, d)
		t = t / d
		return (1 + (-2.72^(-7.5*t) * cos(softspringpi*t))) * c + b
	end
	-- End of YellowTide's functions

	local function inQuad(t, b, c, d)
		t = t / d
		return c * t * t + b
	end

	local function outQuad(t, b, c, d)
		t = t / d
		return -c * t * (t - 2) + b
	end

	local function inOutQuad(t, b, c, d)
		t = t / d * 2
		return t < 1 and c * 0.5 * t * t + b or -c * 0.5 * ((t - 1) * (t - 3) - 1) + b
	end

	local function outInQuad(t, b, c, d)
		if t < d * 0.5 then
			t = 2 * t / d
			return -0.5 * c * t * (t - 2) + b
		else
			t, c = ((t * 2) - d) / d, 0.5 * c
			return c * t * t + b + c
		end
	end

	local function inCubic(t, b, c, d)
		t = t / d
		return c * t * t * t + b
	end

	local function outCubic(t, b, c, d)
		t = t / d - 1
		return c * (t * t * t + 1) + b
	end

	local function inOutCubic(t, b, c, d)
		t = t / d * 2
		if t < 1 then
			return c * 0.5 * t * t * t + b
		else
			t = t - 2
			return c * 0.5 * (t * t * t + 2) + b
		end
	end

	local function outInCubic(t, b, c, d)
		if t < d * 0.5 then
			t = t * 2 / d - 1
			return c * 0.5 * (t * t * t + 1) + b
		else
			t, c = ((t * 2) - d) / d, c * 0.5
			return c * t * t * t + b + c
		end
	end

	local function inQuart(t, b, c, d)
		t = t / d
		return c * t * t * t * t + b
	end

	local function outQuart(t, b, c, d)
		t = t / d - 1
		return -c * (t * t * t * t - 1) + b
	end

	local function inOutQuart(t, b, c, d)
		t = t / d * 2
		if t < 1 then
			return c * 0.5 * t * t * t * t + b
		else
			t = t - 2
			return -c * 0.5 * (t * t * t * t - 2) + b
		end
	end

	local function outInQuart(t, b, c, d)
		if t < d * 0.5 then
			t, c = t * 2 / d - 1, c * 0.5
			return -c * (t * t * t * t - 1) + b
		else
			t, c = ((t * 2) - d) / d, c * 0.5
			return c * t * t * t * t + b + c
		end
	end

	local function inQuint(t, b, c, d)
		t = t / d
		return c * t * t * t * t * t + b
	end

	local function outQuint(t, b, c, d)
		t = t / d - 1
		return c * (t * t * t * t * t + 1) + b
	end

	local function inOutQuint(t, b, c, d)
		t = t / d * 2
		if t < 1 then
			return c * 0.5 * t * t * t * t * t + b
		else
			t = t - 2
			return c * 0.5 * (t * t * t * t * t + 2) + b
		end
	end

	local function outInQuint(t, b, c, d)
		if t < d * 0.5 then
			t = t * 2 / d - 1
			return c * 0.5 * (t * t * t * t * t + 1) + b
		else
			t, c = ((t * 2) - d) / d, c * 0.5
			return c * t * t * t * t * t + b + c
		end
	end

	local function inSine(t, b, c, d)
		return -c * cos(t / d * _halfpi) + c + b
	end

	local function outSine(t, b, c, d)
		return c * sin(t / d * _halfpi) + b
	end

	local function inOutSine(t, b, c, d)
		return -c * 0.5 * (cos(pi * t / d) - 1) + b
	end

	local function outInSine(t, b, c, d)
		c = c * 0.5
		return t < d * 0.5 and c * sin(t * 2 / d * _halfpi) + b or -c * cos(((t * 2) - d) / d * _halfpi) + 2 * c + b
	end

	local function inExpo(t, b, c, d)
		return t == 0 and b or c * 2 ^ (10 * (t / d - 1)) + b - c * 0.001
	end

	local function outExpo(t, b, c, d)
		return t == d and b + c or c * 1.001 * (1 - 2 ^ (-10 * t / d)) + b
	end

	local function inOutExpo(t, b, c, d)
		t = t / d * 2
		return t == 0 and b or t == 2 and b + c or t < 1 and c * 0.5 * 2 ^ (10 * (t - 1)) + b - c * 0.0005 or c * 0.5 * 1.0005 * (2 - 2 ^ (-10 * (t - 1))) + b
	end

	local function outInExpo(t, b, c, d)
		c = c * 0.5
		return t < d * 0.5 and (t * 2 == d and b + c or c * 1.001 * (1 - 2 ^ (-20 * t / d)) + b) or t * 2 - d == 0 and b + c or c * 2 ^ (10 * ((t * 2 - d) / d - 1)) + b + c - c * 0.001
	end

	local function inCirc(t, b, c, d)
		t = t / d
		return -c * ((1 - t * t) ^ 0.5 - 1) + b
	end

	local function outCirc(t, b, c, d)
		t = t / d - 1
		return c * (1 - t * t) ^ 0.5 + b
	end

	local function inOutCirc(t, b, c, d)
		t = t / d * 2
		if t < 1 then
			return -c * 0.5 * ((1 - t * t) ^ 0.5 - 1) + b
		else
			t = t - 2
			return c * 0.5 * ((1 - t * t) ^ 0.5 + 1) + b
		end
	end

	local function outInCirc(t, b, c, d)
		c = c * 0.5
		if t < d * 0.5 then
			t = t * 2 / d - 1
			return c * (1 - t * t) ^ 0.5 + b
		else
			t = (t * 2 - d) / d
			return -c * ((1 - t * t) ^ 0.5 - 1) + b + c
		end
	end

	local function inElastic(t, b, c, d, a, p)
		t = t / d - 1
		p = p or d * 0.3
		return t == -1 and b or t == 0 and b + c or not a or a < abs(c) and -(c * 2 ^ (10 * t) * sin((t * d - p * .25) * _2pi / p)) + b or -(a * 2 ^ (10 * t) * sin((t * d - p / _2pi * asin(c/a)) * _2pi / p)) + b
	end

	local function outElastic(t, b, c, d, a, p)
		t = t / d
		p = p or d * 0.3
		return t == 0 and b or t == 1 and b + c or not a or a < abs(c) and c * 2 ^ (-10 * t) * sin((t * d - p * .25) * _2pi / p) + c + b or a * 2 ^ (-10 * t) * sin((t * d - p / _2pi * asin(c / a)) * _2pi / p) + c + b
	end

	local function inOutElastic(t, b, c, d, a, p)
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

	local function outInElastic(t, b, c, d, a, p)
		if t < d * 0.5 then
			return outElastic(t * 2, b, c * 0.5, d, a, p)
		else
			return inElastic(t * 2 - d, b + c * 0.5, c * 0.5, d, a, p)
		end
	end

	local function inBack(t, b, c, d, s)
		s = s or 1.70158
		t = t / d
		return c * t * t * ((s + 1) * t - s) + b
	end

	local function outBack(t, b, c, d, s)
		s = s or 1.70158
		t = t / d - 1
		return c * (t * t * ((s + 1) * t + s) + 1) + b
	end

	local function inOutBack(t, b, c, d, s)
		s = (s or 1.70158) * 1.525
		t = t / d * 2
		if t < 1 then
			return c * 0.5 * (t * t * ((s + 1) * t - s)) + b
		else
			t = t - 2
			return c * 0.5 * (t * t * ((s + 1) * t + s) + 2) + b
		end
	end

	local function outInBack(t, b, c, d, s)
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

	local function outBounce(t, b, c, d)
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

	local function inBounce(t, b, c, d)
		return c - outBounce(d - t, 0, c, d) + b
	end

	local function inOutBounce(t, b, c, d)
		if t < d * 0.5 then
			return inBounce(t * 2, 0, c, d) * 0.5 + b
		else
			return outBounce(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b
		end
	end

	local function outInBounce(t, b, c, d)
		if t < d * 0.5 then
			return outBounce(t * 2, b, c * 0.5, d)
		else
			return inBounce(t * 2 - d, b + c * 0.5, c * 0.5, d)
		end
	end

	Easing = {
		Linear = linear; Spring = spring; SoftSpring = softSpring; RevBack = revBack; RidiculousWiggle = ridiculousWiggle; Smooth = smooth; Smoother = smoother;

		InQuad    = inQuad;    OutQuad    = outQuad;    InOutQuad    = inOutQuad;    OutInQuad    = outInQuad;
		InCubic   = inCubic;   OutCubic   = outCubic;   InOutCubic   = inOutCubic;   OutInCubic   = outInCubic;
		InQuart   = inQuart;   OutQuart   = outQuart;   InOutQuart   = inOutQuart;   OutInQuart   = outInQuart;
		InQuint   = inQuint;   OutQuint   = outQuint;   InOutQuint   = inOutQuint;   OutInQuint   = outInQuint;
		InSine    = inSine;    OutSine    = outSine;    InOutSine    = inOutSine;    OutInSine    = outInSine;
		InExpo    = inExpo;    OutExpo    = outExpo;    InOutExpo    = inOutExpo;    OutInExpo    = outInExpo;
		InCirc    = inCirc;    OutCirc    = outCirc;    InOutCirc    = inOutCirc;    OutInCirc    = outInCirc;
		InElastic = inElastic; OutElastic = outElastic; InOutElastic = inOutElastic; OutInElastic = outInElastic;
		InBack    = inBack;    OutBack    = outBack;    InOutBack    = inOutBack;    OutInBack    = outInBack;
		InBounce  = inBounce;  OutBounce  = outBounce;  InOutBounce  = inOutBounce;  OutInBounce  = outInBounce;
	}
end

local typeof = typeof
local setmetatable = setmetatable
if not typeof then -- @author Tomarty
	local type = type
	local pcall = pcall
	local dump = string.dump
	local sub = string.sub
	local lookup = setmetatable({}, {
		__index = function(self, result)
			local rtype = sub(result, 48, -2)
			if rtype == "Object" then
				rtype = "Instance"
			end
			self[result] = rtype
			return rtype
		end
	})

	function typeof(val)
		local rtype = type(val)
		if rtype == "userdata" then
			local _, result = pcall(dump, val)
			return lookup[result]
		else
			return rtype
		end
	end
end

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

local NumTweens = 0
local Tweens = {}
local ElapsedTime = 0

Connect(Heartbeat, function(Step)
	ElapsedTime = ElapsedTime + Step
	for a = 1, NumTweens do
		local CurrentTween = Tweens[a]
		local EndTime = CurrentTween.EndTime
		CurrentTween:Interpolate(EndTime > ElapsedTime and ElapsedTime or EndTime)
	end
end)
local remove = table.remove

local function StopTween(self)
	if self.Running then
		for a = 1, NumTweens do
			local OpenTween = Tweens[a]
			if OpenTween == self then
				remove(Tweens, a)
				NumTweens = NumTweens - 1
			end
		end
		self.Running = false
		self.Callback(Canceled)
	end

	return self
end

local function ResumeTween(self)
	if not self.Running then
		self.Running = true
		NumTweens = NumTweens + 1
		Tweens[NumTweens] = self
		return self
	end
end

local function WaitTween(self)
	repeat until not self.Running or not Wait(Heartbeat)
	return self
end

local TweenObject = {
	Running = true;
	Object = false;
	Property = false;
	Wait = WaitTween;
	Stop = StopTween;
	Resume = ResumeTween;
}
TweenObject.__index = TweenObject

local Tween = {EasingFunctions = Easing}
local function Empty() end
function Tween:__call(Object, Property, EndValue, EasingDirection, EasingStyle, Duration, Override, Callback, PropertyType)
	-- @param Object object OR Table object OR Void Function receiver(String propertyName, Variant value),
	-- @param String Property,
	-- @param Variant EndValue
	-- @param Number time
	-- @param String EasingName

	Duration = Duration or 1
	Callback = Callback or Empty
	local StartTime = ElapsedTime
	local EndTime = StartTime + Duration

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
	local AlphaFunction = Lerps[PropertyType or typeof(EndValue)]
	local self = setmetatable({Object = Object; Property = Property; Callback = Callback; EndTime = EndTime}, TweenObject)

	for a = 1, NumTweens do
		local OpenTween = Tweens[a]
		if OpenTween.Object == Object and OpenTween.Property == Property then
			if Override then
				StopTween(OpenTween)
			else
				return StopTween(self) -- warn("Could not Tween", tostring(Object) .. "." .. Property, "to", EndValue))
			end
		end
	end

	function self:Interpolate(ElapsedTime)
		if ElapsedTime == EndTime then
			Object[Property] = EndValue
			self.Running = false
			Callback(Completed)
		else
			Object[Property] = AlphaFunction(StartValue, EndValue, EasingFunction(ElapsedTime - StartTime, 0, 1, Duration))
		end
	end

	self.Running = true
	NumTweens = NumTweens + 1
	Tweens[NumTweens] = self

	return self
end

function Tween.new(Duration, EasingFunction, Callback)
	Duration = Duration or 1

	if type(EasingFunction) == "string" then
		EasingFunction = Easing[EasingFunction]
	end

	local StartTime = ElapsedTime
	local EndTime = StartTime + Duration
	local self = setmetatable({EndTime = EndTime}, TweenObject)

	function self:Interpolate(ElapsedTime)
		if ElapsedTime == EndTime then
			self.Running = false
			Callback(1)
		else
			Callback(EasingFunction(ElapsedTime - StartTime, 0, 1, Duration))
		end
	end

	NumTweens = NumTweens + 1
	Tweens[NumTweens] = self

	return self
end

return setmetatable(Tween, Tween)
