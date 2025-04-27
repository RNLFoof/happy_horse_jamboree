-- [yue]: ./behavior/tests.yue
local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))() -- 1
local useful_things = assert(SMODS.load_file("useful_things.lua"))() -- 2
local _obj_0 = G.steamodded_tests.tests -- 4
_obj_0[#_obj_0 + 1] = testing.TestBundle("misc", { -- 6
	testing.Test("wrap_method", { -- 7
		function() -- 7
			local buildup = { } -- 8
			local obj = { -- 10
				fun = function() -- 10
					buildup[#buildup + 1] = "middle" -- 11
				end -- 10
			} -- 9
			useful_things.wrap_method(obj, "fun", (function() -- 13
				buildup[#buildup + 1] = "before" -- 13
			end), (function() -- 13
				buildup[#buildup + 1] = "after" -- 13
			end)) -- 13
			obj.fun() -- 14
			return testing.assert_eq(table.concat(buildup, "_"), "before_middle_after") -- 15
		end -- 7
	}) -- 6
}) -- 4
