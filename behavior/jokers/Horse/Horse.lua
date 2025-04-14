local required_horse_name_count = 40;local horse_names = { 

"Chestnut", 
"Peanut", 
"Acorn", 
"Gertrude", 
"Slippy", 
"Crazy Horse", 
"Jimmy", 
"Potatoes", 
"Cupcake", 
"Slayer", 
"Lucky", 
"Special Week", 

"Hemmingway", 
"Whiskey", 
"Chipschipschips", 
"Daisy", 
"Orchard", 
"Old Tom", 
"Sunrise", 
"Shepard", 

"Pumpernickel", 

"Sprinkletoes", 

"Old ale", 
"Kettle Sour", 

"Clarence", 
"Spriggan", 

"Angel Face", 
"Casino", 
"Grasshopper", 
"Moscow Mule", 
"Rusty Nail", 


"Apricot", 
"Mulberry", 
"Pecan", 
"Walnut", 
"Hazelnut", 
"Cashew", 
"Butternut", 
"Macadamia", 

"Thimbleberry", 


"Currant", 
"Clementine", 
"Nectarine", 
"Dewberry" }local bonus_types = { 


"chips", 
"luck", 
"money", 
"mult" }


local round;round = function(num, numDecimalPlaces)local mult = 
10 ^ (numDecimalPlaces or 0)return 
math.floor(num * mult + 0.5) / mult end;local index = 

0;for bonus_1_index, bonus_1 in 
ipairs(bonus_types) do for bonus_2_index, bonus_2 in 
ipairs((function()local _accum_0 = {  }local _len_0 = 1;for _index_0 = bonus_1_index, #bonus_types do local _ = bonus_types[_index_0]_accum_0[_len_0] = _;_len_0 = _len_0 + 1 end;return _accum_0 end)()) do for _, bonus_3 in 
ipairs((function()local _accum_0 = {  }local _len_0 = 1;for _index_0 = bonus_1_index + bonus_2_index - 1, #bonus_types do local _ = bonus_types[_index_0]_accum_0[_len_0] = _;_len_0 = _len_0 + 1 end;return _accum_0 end)()) do for _, jack in 
ipairs({ false, true }) do
index = index + 1;local bonuses_as_list = { 
bonus_1, bonus_2, bonus_3 }local bonuses_for_this_horse = { chips = 

round(8 / 1 * # (function()local _accum_0 = {  }local _len_0 = 1;for _index_0 = 1, #bonuses_as_list do local bonus = bonuses_as_list[_index_0]if bonus == "chips" then _accum_0[_len_0] = bonus;_len_0 = _len_0 + 1 end end;return _accum_0 end)()), mult = 
round(4 / 1 * # (function()local _accum_0 = {  }local _len_0 = 1;for _index_0 = 1, #bonuses_as_list do local bonus = bonuses_as_list[_index_0]if bonus == "mult" then _accum_0[_len_0] = bonus;_len_0 = _len_0 + 1 end end;return _accum_0 end)()), money = 
round(1 / 1 * # (function()local _accum_0 = {  }local _len_0 = 1;for _index_0 = 1, #bonuses_as_list do local bonus = bonuses_as_list[_index_0]if bonus == "money" then _accum_0[_len_0] = bonus;_len_0 = _len_0 + 1 end end;return _accum_0 end)()), luck = 
round(1 / 1 * # (function()local _accum_0 = {  }local _len_0 = 1;for _index_0 = 1, #bonuses_as_list do local bonus = bonuses_as_list[_index_0]if bonus == "luck" then _accum_0[_len_0] = bonus;_len_0 = _len_0 + 1 end end;return _accum_0 end)()) }local horse_ability_description = { 



jack and "Per {C:attention}Jack{} scored:" or "Each {C:blue}Hand{} played:" }local scale = 

"s:0.75"if 
bonuses_for_this_horse.chips > 0 then horse_ability_description[#horse_ability_description + 1] = "{" .. tostring(scale) .. ",C:chips}+" .. tostring(bonuses_for_this_horse.chips) .. "{" .. tostring(scale) .. "} chips"end;if 
bonuses_for_this_horse.mult > 0 then horse_ability_description[#horse_ability_description + 1] = "{" .. tostring(scale) .. ",C:mult}+" .. tostring(bonuses_for_this_horse.mult) .. "{" .. tostring(scale) .. "} Mult"end;if 
bonuses_for_this_horse.money > 0 then horse_ability_description[#horse_ability_description + 1] = "{" .. tostring(scale) .. ",C:attention}" .. tostring(bonuses_for_this_horse.money) .. "{" .. tostring(scale) .. ",C:green} #1#/2{" .. tostring(scale) .. "} chance" .. tostring(bonuses_for_this_horse.money > 1 and 's' or '') .. " for {" .. tostring(scale) .. ",C:money}$1{}"end;if 
bonuses_for_this_horse.luck > 0 then horse_ability_description[#horse_ability_description + 1] = "{" .. tostring(scale) .. ",C:green}HORSE LUCK X" .. tostring(bonuses_for_this_horse.luck) .. "{" .. tostring(scale) .. "}"end

scale = "s:0.5"local _list_0 = { 

"{" .. tostring(scale) .. ",C:inactive}Additional {C:attention," .. tostring(scale) .. "}Horses{" .. tostring(scale) .. ",C:inactive} may appear, are {C:dark_edition," .. tostring(scale) .. "}negative{" .. tostring(scale) .. "},", 
"{" .. tostring(scale) .. ",C:inactive}and have varied abilities" }for _index_0 = 





1, #_list_0 do local line = _list_0[_index_0]
horse_ability_description[#horse_ability_description + 1] = line end

local horse_name;if 
index <= #horse_names then
horse_name = horse_names[index]else

horse_name = "Unnamed Horse (" .. tostring(index) .. ")"end
print("Added horse", index, bonus_types)local jackstr = 

jack and "jack" or ""local key = 
bonus_1 .. bonus_2 .. bonus_3 .. jackstr;local horse_joker = 


SMODS.Joker({ key = "mig_horse_" .. key, atlas = 
"atlas_horses", pos = 
atlas_horses_positions[key], rarity = 
1, cost = 
1, config = { is_horse = 

true, key = 
key, bonuses = 
bonuses_for_this_horse, jack = 
jack }, loc_txt = { name = 


horse_name, text = 
horse_ability_description }, loc_vars = function(self, info_queue, card)if 


bonuses_for_this_horse.luck > 0 then

info_queue[#info_queue + 1] = { key = "horse_luck", set = 
"Other", vars = { 
G.GAME and G.GAME.probabilities.normal or 1 } }

info_queue[#info_queue + 1] = G.P_TAGS.tag_mig_horse_luck end;return { vars = { 


G.GAME and G.GAME.probabilities.normal or 1 } }end, discovered = 



true, in_pool = function(self, args)return 
true, { allow_duplicates = true }end, calculate = function(self, card, context)local horse = 

card.ability;if (((
horse.jack == false) and context.joker_main and context.cardarea == G.jokers) or ((horse.jack == true) and context.individual and context.cardarea == G.play and context.other_card:get_id() == 11)) then local money_earned = 








0;for _ = 
1, horse.bonuses.money do if 
pseudorandom('horse_money') < G.GAME.probabilities.normal / 2 then
money_earned = money_earned + 1 end end;for _ = 

1, horse.bonuses.luck do if 
pseudorandom('horse_luck') < G.GAME.probabilities.normal / 20 then

G.E_MANAGER:add_event(Event({ func = function()
add_tag(Tag('tag_mig_horse_luck'))
play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)return 
true end }))

card_eval_status_text(card, 'extra', nil, nil, nil, { message = "HORSE LUCK", colour = G.C.GREEN })end end;local output = { chips = 



horse.bonuses.chips, mult = 
horse.bonuses.mult, dollars = 
money_earned }for key, value in 







pairs(output) do
output[key] = value ~= 0 and value or nil end;return 
output end end })end end end end;local ref = 







Card.set_edition;local _anon_func_0 = function(self)local _obj_0 = 





self.config.center;if _obj_0 ~= nil then local _obj_1 = _obj_0.config;if _obj_1 ~= nil then return _obj_1.is_horse end;return nil end;return nil end;local wrapper;wrapper = function(self, edition, immediate, silent)ref(self, edition, immediate, silent)if _anon_func_0(self) ~= nil then local horse_joker = 
self.config.center;local the_sprite_is_in_here = 
self.children.center



local change_pos_to;if (
edition ~= nil and (edition == "e_negative" or edition.negative)) then
change_pos_to = atlas_horses_positions[horse_joker.config.key .. "neg"]else


change_pos_to = atlas_horses_positions[horse_joker.config.key]end




change_pos_to = atlas_horses_positions[horse_joker.config.key .. "neg"]if 
horse_joker.pos ~= change_pos_to then
horse_joker.pos = change_pos_to;return 

the_sprite_is_in_here:set_sprite_pos(horse_joker.pos)end end end;do function 









Card:set_edition(edition, immediate, silent)wrapper(self, edition, immediate, silent)end end;return 





nil