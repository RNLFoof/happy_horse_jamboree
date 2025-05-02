local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()
local _obj_0 = G.steamodded_tests.tests
_obj_0[#_obj_0 + 1] = testing.TestBundle("horses", {
	testing.Test("chipschipschips", {
		testing.create_state_steps(),
		function()
			return testing.play_hand({
				"A"
			}, {
				centers = "j_mig_horse_chipschipschips"
			})
		end,
		function()
			return testing.assert_hand_scored(11 + 5 + 24)
		end
	}),
	testing.Test("chipschipschipsjack on a jack", {
		testing.create_state_steps(),
		function()
			return testing.play_hand({
				"J"
			}, {
				centers = "j_mig_horse_chipschipschipsjack"
			})
		end,
		function()
			return testing.assert_hand_scored(10 + 5 + 24)
		end
	}),
	testing.Test("chipschipschipsjack not on a jack", {
		testing.create_state_steps(),
		function()
			return testing.play_hand({
				"T"
			}, {
				centers = "j_mig_horse_chipschipschipsjack"
			})
		end,
		function()
			return testing.assert_hand_scored(10 + 5)
		end
	}),
	testing.Test("multmultmult", {
		testing.create_state_steps(),
		function()
			return testing.play_hand({
				"A"
			}, {
				centers = "j_mig_horse_multmultmult"
			})
		end,
		function()
			return testing.assert_hand_scored((11 + 5) * (1 + (4 * 3)))
		end
	}),
	testing.Test("moneymoneymoney", {
		testing.create_state_steps(),
		function()
			return testing.play_hand({
				"A"
			}, {
				centers = {
					"j_mig_horse_moneymoneymoney",
					"j_mig_horse_moneymoneymoney",
					"j_mig_horse_moneymoneymoney",
					"j_mig_horse_moneymoneymoney",
					"j_mig_horse_moneymoneymoney",
					"j_mig_horse_moneymoneymoney"
				}
			})
		end,
		function()
			return testing.assert_dollars_gt(4)
		end,
		function()
			return testing.assert_dollars_lt(4 + (3 * 6))
		end
	}),
	testing.Test("moneymoneymoney with Oops! All 6s", {
		testing.create_state_steps(),
		function()
			return testing.play_hand({
				"A"
			}, {
				centers = {
					"j_mig_horse_moneymoneymoney",
					"j_mig_horse_moneymoneymoney",
					"j_mig_horse_moneymoneymoney",
					"j_mig_horse_moneymoneymoney",
					"j_mig_horse_moneymoneymoney",
					"j_mig_horse_moneymoneymoney",
					"j_oops"
				}
			})
		end,
		function()
			return testing.assert_dollars(4 + (3 * 6))
		end
	})
})
