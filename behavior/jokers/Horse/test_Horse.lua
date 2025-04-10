local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()local _obj_0 = 

G.steamodded_tests.tests

_obj_0[#_obj_0 + 1] = testing.TestBundle("Horse tests", { 
testing.Test("chipschipschips", { testing.create_state_steps(), function()return 
SMODS.add_card({ key = "j_mig_horse_chipschipschips", soulable = false, no_edition = true })end, function()return 
testing.play_hand({ "A" })end, function()return 
testing.assert_hand_scored(11 + 5 + 24)end }), 



testing.Test("chipschipschipsjack on a jack", { testing.create_state_steps(), function()return 
SMODS.add_card({ key = "j_mig_horse_chipschipschipsjack", soulable = false, no_edition = true })end, function()return 
testing.play_hand({ "J" })end, function()return 
testing.assert_hand_scored(10 + 5 + 24)end }), 



testing.Test("chipschipschipsjack not on a jack", { testing.create_state_steps(), function()return 
SMODS.add_card({ key = "j_mig_horse_chipschipschipsjack", soulable = false, no_edition = true })end, function()return 
testing.play_hand({ "T" })end, function()return 
testing.assert_hand_scored(10 + 5)end }) })