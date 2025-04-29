local processed_chips;processed_chips = function(chips)return math.floor(chips)end;return 


SMODS.Joker({ key = "shakedown", atlas = 
"atlas_jokers", pos = 
atlas_jokers_positions["placeholder"]["blue"], loc_txt = { name = 

"Shakedown", text = { 

"Gains {C:chips}Chips", 
"when a card is {C:attention}juiced up{},", 
"{C:inactive,s:0.5}(shaking animation)", 
"based on intensity", 
"{C:inactive}(Currently {C:chips}+#1# {C:inactive}-> {C:chips}+#2# {C:inactive}Chips)" } }, loc_vars = function(self, info_queue, card)return { vars = { 



card.ability.chips, 
processed_chips(card.ability.chips) } }end, set_ability = function(self, card, initial, delay_sprites)


card.ability.chips = 0 end, calculate = function(self, card, context)if 


context.joker_main and context.cardarea == G.jokers then return { chips = 

processed_chips(card.ability.chips) }end end })
