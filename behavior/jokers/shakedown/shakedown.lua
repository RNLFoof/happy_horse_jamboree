local _module_0 = {  }local useful_things = assert(SMODS.load_file("useful_things.lua"))()local gain_climb_time = 

1 / 8;local gain_hold_time = 
1 + 1 / 4

local reset_gain_display;reset_gain_display = function(shakedown_joker)
shakedown_joker.doesnt_save.display_gains = 0
shakedown_joker.doesnt_save.goal_gains = 0
shakedown_joker.doesnt_save.gain_stack_depth = 0 end

local processed_chips;processed_chips = function(chips)return math.floor(chips)end

local aquire_gains;aquire_gains = function(shakedown_joker, gains)if not 
shakedown_joker.doesnt_save then
return end;local _obj_0 = 
shakedown_joker.ability;_obj_0.chips = _obj_0.chips + gains;local _obj_1 = 
shakedown_joker.doesnt_save;_obj_1.goal_gains = _obj_1.goal_gains + gains;local _obj_2 = 
shakedown_joker.doesnt_save;_obj_2.gain_stack_depth = _obj_2.gain_stack_depth + 1


attention_text({ text = "+" .. tostring(gains), scale = 
useful_things.lerp(0.1, 0.75, gains), hold = 
0.4, backdrop_colour = 
G.C.CHIPS, align = 
"cm", major = 
shakedown_joker, offset = { x = 

G.CARD_W * math.random(-5, 5) / 10, y = 
G.CARD_H * math.random(-5, 5) / 10 } })






G.E_MANAGER:add_event(Event({ trigger = 'ease', delay = 
gain_climb_time * G.SETTINGS.GAMESPEED, blockable = 
false, blocking = 
false, ref_table = 
shakedown_joker.doesnt_save, ref_value = 
"display_gains", ease_to = 
shakedown_joker.doesnt_save.goal_gains }))return 


G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 
gain_hold_time * G.SETTINGS.GAMESPEED, blockable = 
false, blocking = 
false, func = function()local _obj_3 = 

shakedown_joker.doesnt_save;_obj_3.gain_stack_depth = _obj_3.gain_stack_depth - 1;if 
shakedown_joker.doesnt_save.gain_stack_depth > 0 then return 
true end
reset_gain_display(shakedown_joker)local sound_variant = 


pseudorandom_element({ 1 }, pseudoseed("stolen_sound"))
play_sound("hhj_shakedown" .. tostring(sound_variant))return 

true end }))end








_module_0["aquire_gains"] = aquire_gains;local _anon_func_0 = function(card)local _obj_0 = 








































card.doesnt_save;if _obj_0 ~= nil then return _obj_0.gain_stack_depth end;return nil end;local _anon_func_1 = function(card)local _obj_0 = card.doesnt_save;if _obj_0 ~= nil then return _obj_0.gain_stack_depth end;return nil end;SMODS.Joker({ key = "shakedown", atlas = "atlas_jokers", pos = atlas_jokers_positions["placeholder"]["blue"], loc_txt = { name = "Shakedown", text = { "Gains {C:chips}Chips", "when a card is {C:attention}juiced up{},", "{C:inactive,s:0.5}(shaking animation)", "based on intensity", "{C:inactive}(Currently {C:chips}#1# {C:inactive}→ {C:chips}+#2# {C:inactive}Chips)" } }, loc_vars = function(self, info_queue, card)return { vars = { card.ability.chips, processed_chips(card.ability.chips) } }end, prepare_yourself = function(self, card)card.ability.chips = 0;card.doesnt_save = {  }return reset_gain_display(card)end, load = function(self, card, card_table, other_card)return self:prepare_yourself(card)end, set_ability = function(self, card, initial, delay_sprites)return self:prepare_yourself(card)end, calculate = function(self, card, context)if context.joker_main and context.cardarea == G.jokers then return { chips = processed_chips(card.ability.chips) }end end, update = function(self, card, dt)if card.children.hhj_shakedown_tally then card.children.hhj_shakedown_tally:remove()card.children.hhj_shakedown_tally = nil end;if _anon_func_0(card) and _anon_func_1(card) > 0 then local ui_definition = 


create_popup_UIBox_tooltip({ text = { 
string.format("+%.2f", card.doesnt_save.display_gains) } })




ui_definition.config.colour = G.C.UI.BACKGROUND_INACTIVE


card.children.hhj_shakedown_tally = UIBox({ definition = ui_definition, config = { align = 
"bm", offset = { x = 0, y = -0.1 }, parent = card } })end end })return 





_module_0;