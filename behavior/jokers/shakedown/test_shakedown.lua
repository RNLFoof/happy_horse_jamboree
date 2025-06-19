local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()local TestBundle = 
testing.TestBundle;local Test = 
testing.Test;local _obj_0 = 

G.steamodded_tests.tests
_obj_0[#_obj_0 + 1] = TestBundle("shakedown", { 
Test("no_trading_card_abuse", { function()return testing.new_run()end, function()return 
testing.add_centers({ "j_trading", "j_hhj_shakedown" })end, function()return 
testing.new_round()end, function()return 
delay(3)end, function()

assert(SMODS.find_card("j_trading")[1].ability.hhj_in_juice_card_until)return 
testing.assert_eq(SMODS.find_card("j_hhj_shakedown")[0].ability.chips, 0)end, 
testing.discard_something_steps(), function()return 
delay(3)end, function()return 

testing.assert_eq(SMODS.find_card("j_trading")[1].ability.hhj_in_juice_card_until, nil)end }) })