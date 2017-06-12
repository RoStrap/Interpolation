-- Used for interpolation curves
-- @author Quenty
-- @optimizer Narrev

local Bezier = {}

function Bezier.new(n, r, a, w)
	if not (n and r and a and w) then
		error("[Bezier] - Need 4 numbers to construct a Bezier Factory")
	end
	
	local l, z = 3*a, 3*n
	w, r = 3*w, 3*r
	a, n = 6*(a - 2*n), 1 - w + r
	local m, b, q = 1 - l + z, l - 2*z, w - 2*r
	local o = 3*m

	return function(x)
		-- @param number x [0, 1]
		
		local d = x
		for _ = 1, 4 do
			local y = d*(a + o*d) + z
			if y == 0 then
				break
			else
				d = d - (((m*d + b)*d + z)*d - x) / y
			end			
		end
		return ((n*d + q)*d + r)*d
	end
end

return Bezier
