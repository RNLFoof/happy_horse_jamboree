local _module_0 = {  }local useful_things = assert(SMODS.load_file("useful_things.lua"))()local gain_hold_time = 

0.75

local processed_chips;processed_chips = function(chips)return math.floor(chips)end

local aquire_gains;aquire_gains = function(shakedown_joker, gains)if not 
shakedown_joker.doesnt_save then
return end;local _obj_0 = 
shakedown_joker.ability;_obj_0.chips = _obj_0.chips + gains;local _obj_1 = 
shakedown_joker.doesnt_save;_obj_1.gains = _obj_1.gains + gains;local _obj_2 = 
shakedown_joker.doesnt_save;_obj_2.gain_stack_depth = _obj_2.gain_stack_depth + 1


attention_text({ text = "+" .. tostring(gains), scale = 
useful_things.lerp(0.1, 0.75, gains), hold = 
0.4, backdrop_colour = 
G.C.CHIPS, align = 
"cm", major = 
shakedown_joker, offset = { x = 

G.CARD_W * math.random(-5, 5) / 10, y = 
G.CARD_H * math.random(-5, 5) / 10 } })local sound_variant = 




pseudorandom_element({ 1 }, pseudoseed("stolen_sound"))
play_sound("hhj_shakedown" .. tostring(sound_variant), useful_things.random_float(0.5, 1.5), 0.5)return 



G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 
gain_hold_time * G.SETTINGS.GAMESPEED, blockable = 
false, blocking = 
false, func = function()local _obj_3 = 

shakedown_joker.doesnt_save;_obj_3.gain_stack_depth = _obj_3.gain_stack_depth - 1;if 
shakedown_joker.doesnt_save.gain_stack_depth > 0 then return 
true end
shakedown_joker.doesnt_save.gains = 0;return 
true end }))end;_module_0["aquire_gains"] = aquire_gains;local _anon_func_0 = function(card)local _obj_0 = 






































card.doesnt_save;if _obj_0 ~= nil then return _obj_0.gain_stack_depth end;return nil end;local _anon_func_1 = function(card)local _obj_0 = card.doesnt_save;if _obj_0 ~= nil then return _obj_0.gain_stack_depth end;return nil end;SMODS.Joker({ key = "shakedown", atlas = "atlas_jokers", pos = atlas_jokers_positions["placeholder"]["blue"], loc_txt = { name = "Shakedown", text = { "Gains {C:chips}Chips", "when a card is {C:attention}juiced up{},", "{C:inactive,s:0.5}(shaking animation)", "based on intensity", "{C:inactive}(Currently {C:chips}#1# {C:inactive}→ {C:chips}+#2# {C:inactive}Chips)" } }, loc_vars = function(self, info_queue, card)return { vars = { card.ability.chips, processed_chips(card.ability.chips) } }end, prepare_yourself = function(self, card)card.ability.chips = 0;card.doesnt_save = { gains = 0, gain_stack_depth = 0, gain_hold_time = 1 }end, load = function(self, card, card_table, other_card)return self:prepare_yourself(card)end, set_ability = function(self, card, initial, delay_sprites)return self:prepare_yourself(card)end, calculate = function(self, card, context)if context.joker_main and context.cardarea == G.jokers then return { chips = processed_chips(card.ability.chips) }end end, update = function(self, card, dt)if _anon_func_0(card) and _anon_func_1(card) > 0 then return 
print(card.doesnt_save.gains, card.doesnt_save.gain_stack_depth)end end })return _module_0;