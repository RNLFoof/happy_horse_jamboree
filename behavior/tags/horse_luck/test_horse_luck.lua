local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()local TestBundle = 
testing.TestBundle;local Test = 
testing.Test;local _obj_0 = 

G.steamodded_tests.tests
_obj_0[#_obj_0 + 1] = TestBundle("horse_luck", { 
Test("no_reload_exploit", { function()return false end }) })