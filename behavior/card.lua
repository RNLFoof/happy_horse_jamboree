local useful_things = assert(SMODS.load_file("useful_things.lua"))()local _anon_func_0 = function(potential_ace)local _obj_0 = 


potential_ace.base;if _obj_0 ~= nil then return _obj_0.nominal end;return nil end;local _anon_func_1 = function(potential_ace)local _obj_0 = potential_ace.base;if _obj_0 ~= nil then return _obj_0.suit end;return nil end;local update_hhj_ace;update_hhj_ace = function(potential_ace)if not (potential_ace.children.front and _anon_func_0(potential_ace) == 11 and _anon_func_1(potential_ace) == "Spades") then return end;if 

G.STAGE == G.STAGES.MAIN_MENU then if not 
useful_things.config["HHJ Aces"]["In Main Menu"] then return end else if not 

useful_things.config["HHJ Aces"]["Everywhere Else"] then return end end

potential_ace.children.front.atlas = atlas_misc_cards;return 
potential_ace.children.front:set_sprite_pos(atlas_misc_cards_positions["hhj_ace"])end;return 


useful_things.wrap_method(Card, "set_base", nil, function(...)local self,card,initial = 
unpack({ ... })return 
update_hhj_ace(self)end)
