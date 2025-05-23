local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()local useful_things = 
assert(SMODS.load_file("useful_things.lua"))()local _obj_0 = 

G.steamodded_tests.tests

_obj_0[#_obj_0 + 1] = testing.TestBundle("horses", { 
testing.Test("chipschipschips", { testing.create_state_steps(), function()return 
testing.play_hand({ "A" }, { centers = "j_hhj_horse_chipschipschips" })end, function()return 
testing.assert_hand_scored(11 + 5 + 24)end }), 



testing.Test("chipschipschipsjack on a jack", { testing.create_state_steps(), function()return 
testing.play_hand({ "J" }, { centers = "j_hhj_horse_chipschipschipsjack" })end, function()return 
testing.assert_hand_scored(10 + 5 + 24)end }), 



testing.Test("chipschipschipsjack not on a jack", { testing.create_state_steps(), function()return 
testing.play_hand({ "T" }, { centers = "j_hhj_horse_chipschipschipsjack" })end, function()return 
testing.assert_hand_scored(10 + 5)end }), 



testing.Test("multmultmult", { testing.create_state_steps(), function()return 
testing.play_hand({ "A" }, { centers = "j_hhj_horse_multmultmult" })end, function()return 
testing.assert_hand_scored((11 + 5) * (1 + (4 * 3)))end }), 



testing.Test("moneymoneymoney", { testing.create_state_steps(), function()return 
testing.play_hand({ "A" }, { centers = { 
"j_hhj_horse_moneymoneymoney", 
"j_hhj_horse_moneymoneymoney", 
"j_hhj_horse_moneymoneymoney", 

"j_hhj_horse_moneymoneymoney", 
"j_hhj_horse_moneymoneymoney", 
"j_hhj_horse_moneymoneymoney" } })end, function()return 

testing.assert_dollars_gt(4)end, function()return 
testing.assert_dollars_lt(4 + (3 * 6))end }), 



testing.Test("moneymoneymoney with Oops! All 6s", { testing.create_state_steps(), function()return 
testing.play_hand({ "A" }, { centers = { 
"j_hhj_horse_moneymoneymoney", 
"j_hhj_horse_moneymoneymoney", 
"j_hhj_horse_moneymoneymoney", 

"j_hhj_horse_moneymoneymoney", 
"j_hhj_horse_moneymoneymoney", 
"j_hhj_horse_moneymoneymoney", 

"j_oops" } })end, function()return 

testing.assert_dollars(4 + (3 * 6))end }), 



testing.Test("judgement_test_for_the_next_test", (function()local _tab_0 = {  }local _obj_1 = testing.create_state_steps()local _idx_0 = 1;for _key_0, _value_0 in pairs(_obj_1) do if _idx_0 == _key_0 then _tab_0[#_tab_0 + 1] = _value_0;_idx_0 = _idx_0 + 1 else _tab_0[_key_0] = _value_0 end end
_tab_0[#_tab_0 + 1] = function()return 
useful_things.pool_filter_context((function(center)return center.key == "j_hhj_horse_base"end), nil, function()
G.P_JOKER_RARITY_POOLS[1] = { G.P_CENTERS["j_joker"] }
G.P_JOKER_RARITY_POOLS[2] = { G.P_CENTERS["j_joker"] }
G.P_JOKER_RARITY_POOLS[3] = { G.P_CENTERS["j_joker"] }local judgement = 
SMODS.create_card({ set = "Tarot", key = "c_judgement" })return 
judgement:use_consumeable(judgement.area)end)end

_tab_0[#_tab_0 + 1] = function()return true end;return _tab_0 end)()), 



testing.Test("judgement_spawning_base_horse", (function()local _tab_0 = {  }local _obj_1 = testing.create_state_steps()local _idx_0 = 1;for _key_0, _value_0 in pairs(_obj_1) do if _idx_0 == _key_0 then _tab_0[#_tab_0 + 1] = _value_0;_idx_0 = _idx_0 + 1 else _tab_0[_key_0] = _value_0 end end
_tab_0[#_tab_0 + 1] = function()return 
useful_things.pool_filter_context((function(center)return center.key == "j_hhj_horse_base"end), nil, function()
G.P_JOKER_RARITY_POOLS[1] = { G.P_CENTERS["j_hhj_horse_base"], G.P_CENTERS["j_hhj_horse_chipschipschips"] }
G.P_JOKER_RARITY_POOLS[2] = { G.P_CENTERS["j_hhj_horse_base"], G.P_CENTERS["j_hhj_horse_chipschipschips"] }
G.P_JOKER_RARITY_POOLS[3] = { G.P_CENTERS["j_hhj_horse_base"], G.P_CENTERS["j_hhj_horse_chipschipschips"] }local judgement = 
SMODS.create_card({ set = "Tarot", key = "c_judgement" })return 
judgement:use_consumeable(judgement.area)end)end

_tab_0[#_tab_0 + 1] = function()return true end;return _tab_0 end)()) })