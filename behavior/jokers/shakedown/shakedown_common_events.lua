local useful_things = assert(SMODS.load_file("useful_things.lua"))()








local stalk_juice_card_until;stalk_juice_card_until = function(card, eval_func, delay, mid_chain)if (not 
mid_chain) and card.ability.hhj_in_juice_card_until then
return end;return 


G.E_MANAGER:add_event(Event({ trigger = "after", delay = 
delay or 0.1, blocking = 
false, blockable = 
false, timer = 
"REAL", func = function()if not 

eval_func(card) then
card.ability.hhj_in_juice_card_until = nil else

card.ability.hhj_in_juice_card_until = true
stalk_juice_card_until(card, eval_func, delay, true)end;return 
true end }))end;return 






























useful_things.wrap_function("juice_card_until", function(card, eval_func, first, delay)return 
stalk_juice_card_until(card, eval_func, delay, false)end)
