local useful_things = assert(SMODS.load_file("useful_things.lua"))()local extra_appearance_rate = 

15 / 16


SMODS.Back({ name = "Horse Deck", key = 
"horse", atlas = 
"atlas_decks", pos = 
atlas_decks_positions["horse"], loc_txt = { name = 

"Horse Deck", text = { 

"Cards from", 
"{C:white,B:1,E:1}Happy Horse Jamboree{}", 
"appear significantly more often", 
"{s:0.5,C:inactive}I mostly just wanted a faster way", 
"{s:0.5,C:inactive}to see how this stuff feels to play with" } }, loc_vars = function(self, info_queue, card)return { vars = { colours = { 





SMODS.Gradients.hhj_happy_horse_jamboree } } }end, apply = function(self, back)return 





G.E_MANAGER:add_event(Event({ func = function()
G.GAME.starting_params.hhj_extra_appearance_rate = extra_appearance_rate;return 
true end }))end })local _anon_func_0 = function(G)local _obj_0 = 






G.GAME;if _obj_0 ~= nil then local _obj_1 = _obj_0.starting_params;if _obj_1 ~= nil then return _obj_1.hhj_extra_appearance_rate end;return nil end;return nil end;local _anon_func_1 = function(center)local _obj_0 = 



center.mod;if _obj_0 ~= nil then return _obj_0.id end;return nil end;return useful_things.wrap_method(_G, "get_current_pool", nil, function(self, original_outputs)local pool,pool_key = unpack(original_outputs)if (_anon_func_0(G) and pseudorandom(pseudoseed("horse_deck")) <= G.GAME.starting_params.hhj_extra_appearance_rate) then pool = useful_things.filtered_pool(pool, (function(center)return _anon_func_1(center) == "happy_horse_jamboree"end), "UNFILTERED")end;return 


pool, pool_key end)
