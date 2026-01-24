return 
SMODS.Joker({ key = "win_delayer", atlas = 
"atlas_jokers", pos = 
atlas_jokers_positions["placeholder"]["orange"], rarity = 
1, cost = 
4, perishable_compat = 
true, loc_txt = { name = 

"Carrot on a Stick", text = { 

"Keeps the required round score out of your reach until the last hand" } }, config = { extra = { blind_started_at = 



300 } }, calculate = function(self, card, context)if 

context.setting_blind then
card.ability.extra.blind_started_at = G.GAME.blind.chips elseif 

context.press_play and G.GAME.current_round.hands_left == 1 and card.ability.extra.blind_started_at < G.GAME.blind.chips then

print("new event")return 

G.E_MANAGER:add_event(Event({ trigger = "immediate", func = function()


G.E_MANAGER:add_event(Event({ trigger = "ease", blockable = 
false, blocking = 
false, ref_table = 
G.GAME.blind, ref_value = 
'chips', ease_to = 
card.ability.extra.blind_started_at, delay = 
0.75, func = function(t)

G.GAME.blind.chip_text = format_ui_value(t)return 
t end }))

card_eval_status_text(card, 'extra', nil, nil, nil, { message = "ok thats enough" })return 
true end }))end end, update = function(self, card, dt)if 















G.GAME.current_round.hands_left >= 1 and G.GAME.blind.chips < G.GAME.chips then
print("Update")
G.GAME.blind.chips = G.GAME.chips + 1
G.GAME.blind.chip_text = format_ui_value(G.GAME.blind.chips)end end })


