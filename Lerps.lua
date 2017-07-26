-- Lerp functions for various property types
-- @author Validark
-- @author Sharksie (NumberSequence Lerp)

local newRect = Rect.new
local newUDim = UDim.new
local newRegion3 = Region3.new
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

return {
	number = Lerp;
	Color3 = Color3Lerp;
	UDim2 = UDim2.new().Lerp;
	CFrame = CFrame.new().Lerp;
	Vector2 = Vector2.new().Lerp;
	Vector3 = Vector3.new().Lerp;

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
