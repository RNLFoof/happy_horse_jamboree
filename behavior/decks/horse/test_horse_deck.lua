local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()local useful_things = 
assert(SMODS.load_file("useful_things.lua"))()
assert(SMODS.load_file("libs\\steamodded_test\\test_main.lua"))()local TestBundle = 

testing.TestBundle;local Test = 
testing.Test;local _obj_0 = 

G.steamodded_tests.tests
_obj_0[#_obj_0 + 1] = TestBundle("horse_deck", { 
TestBundle("multiplier", { 
Test("basic", { testing.create_state_steps({ back = "b_hhj_horse" }), function()local pool = 

get_current_pool("Joker")
testing.assert_eq(useful_things.count(pool, "j_joker"), 1)return 
testing.assert_eq(useful_things.count(pool, "j_hhj_shakedown"), 8)end }), 

Test("exceptions", { testing.create_state_steps({ back = "b_hhj_horse" }), function()local pool = 

get_current_pool("Joker")return 
testing.assert_eq(useful_things.count(pool, "j_hhj_horse_base"), 1)end }) }) })