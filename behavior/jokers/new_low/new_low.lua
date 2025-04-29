local new_low = 
SMODS.Joker({ key = "new_low", atlas = 
"atlas_jokers", pos = 
atlas_jokers_positions["placeholder"]["red"], rarity = 
2, cost = 
6, loc_txt = { name = 

"New Low", text = { 

"Enables the poker hand {C:attention}Low Card{}.", 
"Consists of exactly one {C:attention}2{},", 
"starts with {C:mult}0{} Mult and {C:chips}0{} Chips." } }, loc_vars = function(self, info_queue, card)


info_queue[#info_queue + 1] = G.P_CENTERS.c_mig_haumea;return 
{  }end, calculate = function(self, card, context)return 

nil end })