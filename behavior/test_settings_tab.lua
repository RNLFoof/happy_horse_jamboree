local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()local settings_tab = 

assert(SMODS.load_file("behavior\\settings_tab.lua"))()local Test = 

testing.Test;local TestBundle = 
testing.TestBundle;local assert_eq = 
testing.assert_eq;local assert_valid_ui = 
testing.assert_valid_ui;local _obj_0 = 

G.steamodded_tests.tests
_obj_0[#_obj_0 + 1] = TestBundle("settings_tab", { 
Test("as_nodes", { function()
assert_valid_ui(settings_tab.config_structure:as_nodes()[1])return 
true end }), 

Test("actual_values", { function()
assert_valid_ui(SMODS.Mods.happy_horse_jamboree.config_tab)return 
true end }) })