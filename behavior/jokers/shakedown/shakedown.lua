return 
SMODS.Joker({ key = "shakedown", atlas = 
"atlas_jokers", pos = 
atlas_jokers_positions["New Low"], loc_txt = { name = 

"Shakedown", text = { 

"Gains {C:chips}Chips", 
"when a card is \"Juiced Up\",", 
"based on intensity", 
"{C:inactive}(Currently {C:chips}+#1# {C:inactive}Chips)" } }, loc_vars = function(self, info_queue, card)return { vars = { 



card.ability.chips } }end, set_ability = function(self, card, initial, delay_sprites)


card.ability.chips = 0 end })