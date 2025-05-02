local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()local particles = 
assert(SMODS.load_file("behavior\\vanilla\\particles.lua"))()local _obj_0 = 

G.steamodded_tests.tests

_obj_0[#_obj_0 + 1] = testing.TestBundle("particles", { 
testing.Test("init_after taking from both the provided and default config", { function()local dummy = 
{  }

particles.init_after(dummy, 0, 0, 0, 0, { hhj_config = { gravity_intensity = 
7, fake_option_that_wont_be_overwritten = 
6 } })


testing.assert_ne(dummy.hhj_config.fake_option_that_wont_be_overwritten, nil)
testing.assert_eq(dummy.hhj_config.gravity_intensity, 7)return 
testing.assert_eq(dummy.hhj_config.gravity_direction, 270)end }), 



testing.Test("init_after on subconfig", { function()local dummy = 
{  }

particles.init_after(dummy, 0, 0, 0, 0, { hhj_config = { starting_range = { min_x = 

69 } } })



testing.assert_eq(dummy.hhj_config.starting_range.min_x, 69)return 
testing.assert_eq(dummy.hhj_config.starting_range.max_x, G.CARD_W / 2)end }) })