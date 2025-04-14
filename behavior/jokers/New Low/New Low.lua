local new_low = 
SMODS.Joker({ key = "new_low", atlas = 
"atlas_jokers", pos = 
atlas_jokers_positions["New Low"], rarity = 
2, cost = 
6, loc_txt = { name = 

"New Low", text = { 

"Lets you play {C:attention}Low Card{}." } }, loc_vars = function(self, info_queue, card)return 



{  }end, calculate = function(self, card, context)return 

nil end })