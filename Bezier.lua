-- Used for interpolation curves
-- @author Quenty
-- @optimizer Narrev

local Bezier = {}

function Bezier.new(n, r, a, w)
	assert(n and r and a and w, "[BezierFactory] - Need 4 numbers to construct a Bezier Factory")

	local l, z = 3*a, 3*n
	w, r = 3*w, 3*r
	a, n = 6*(a - 2*n), 1 - w + r
	local m, b, q = 1 - l + z, l - 2*z, w - 2*r
	local o = 3*m

	return function(x)
		-- @param number x [0, 1]
		local d = x
		for _ = 1, 4 do
			y = o*d*d + a*d + z
			if y == 0 then break end
			d = d - (((m*d + b)*d + z)*d - x) / y
		end
		return ((n*d + q)*d + r)*d
	end
end

return Bezier
