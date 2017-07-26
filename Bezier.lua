-- Used for interpolation curves
-- @author Validark
-- @original Quenty

return {
	new = function(n, r, a, w)
		--- Generates a Bezier interpolation curve from 4 coordinates
		-- @returns function Bezier curve that when called with a number [0-1] will return a position
		-- @resources http://greweb.me/bezier-easing-editor/example/, http://cubic-bezier.com/
		
		if n and r and a and w then
			local l, z = 3*a, 3*n
			w, r = 3*w, 3*r
			a, n = 6*(a - 2*n), 1 - w + r
			local m, e, q = 1 - l + z, l - 2*z, w - 2*r
			local o = 3*m
	
			return function(t, b, c, d)
				-- @param number t [0, 1]
				-- @optional parmeters (see other easing functions)
	
				t = (c or 1) * t / (d or 1) + (b or 0)
				local f = t
				for _ = 1, 4 do
					local y = f*(a + o*f) + z
					if y == 0 then
						break
					else
						f = f - (((m*f + e)*f + z)*f - t) / y
					end			
				end
				return ((n*f + q)*f + r)*f
			end
		else
			error("[Bezier] - Need 4 numbers to construct a Bezier curve")
		end
	end
}
