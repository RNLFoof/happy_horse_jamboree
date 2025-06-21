local useful_things = assert(SMODS.load_file("useful_things.lua"))()local extra_appearance_rate = 

8


SMODS.Back({ name = "Horse Deck", key = 
"horse", atlas = 
"atlas_decks", pos = 
atlas_decks_positions["horse"], loc_txt = { name = 

"Horse Deck", text = { 

"Cards from", 
"{C:white,B:1,E:1}Happy Horse Jamboree{}", 
"appear {C:attention}#1#x{} as often", 
"{s:0.5,C:inactive}I mostly just wanted a faster way", 
"{s:0.5,C:inactive}to see how this stuff feels to play with" } }, loc_vars = function(self, info_queue, card)return { vars = { 




extra_appearance_rate, colours = { 

SMODS.Gradients.hhj_happy_horse_jamboree } } }end, apply = function(self, back)return 





G.E_MANAGER:add_event(Event({ func = function()
G.GAME.starting_params.hhj_extra_appearance_rate = extra_appearance_rate;return 
true end }))end })local _anon_func_0 = function(G)local _obj_0 = 





G.GAME;if _obj_0 ~= nil then local _obj_1 = _obj_0.starting_params;if _obj_1 ~= nil then return _obj_1.hhj_extra_appearance_rate end;return nil end;return nil end;local _anon_func_1 = function(G, center)local _obj_0 = 


G.P_CENTERS[center]if _obj_0 ~= nil then local _obj_1 = _obj_0.mod;if _obj_1 ~= nil then return _obj_1.id end;return nil end;return nil end;return useful_things.wrap_method(_G, "get_current_pool", nil, function(self, original_outputs)local pool,pool_key = unpack(original_outputs)if _anon_func_0(G) then local add_to_pool = {  }for _index_0 = 1, #pool do local center = pool[_index_0]local _continue_0 = false;repeat if not (_anon_func_1(G, center) == "happy_horse_jamboree") then
_continue_0 = true;break end;for _ = 
1, extra_appearance_rate - 1 do
add_to_pool[#add_to_pool + 1] = center end;_continue_0 = true until true;if not _continue_0 then break end end;local _tab_0 = 
{  }local _idx_0 = 1;for _key_0, _value_0 in pairs(pool) do if _idx_0 == _key_0 then _tab_0[#_tab_0 + 1] = _value_0;_idx_0 = _idx_0 + 1 else _tab_0[_key_0] = _value_0 end end;local _idx_1 = 1;for _key_0, _value_0 in pairs(add_to_pool) do if _idx_1 == _key_0 then _tab_0[#_tab_0 + 1] = _value_0;_idx_1 = _idx_1 + 1 else _tab_0[_key_0] = _value_0 end end;pool = _tab_0 end;return 

pool, pool_key end)
