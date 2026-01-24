local useful_things = assert(SMODS.load_file("useful_things.lua"))()local ui = 
assert(SMODS.load_file("behavior/functions/ui.lua"))()return 


SMODS.Joker({ key = "strange_sack", atlas = 
"atlas_jokers", pos = 
atlas_jokers_positions["placeholder"]["yellow"], rarity = 
2, cost = 
5, perishable_compat = 
false, loc_txt = { name = 

"Strange Sack", text = 

useful_things.format_text({ "When consumable area is full", 
"destroys one held consumable,", 
"create a previously destroyed", 
"consumable when Blind is selected" }) }, generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)


SMODS.Joker.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)local items_gui = 

{  }local _list_0 = 
card.ability.extra.contains;for _index_0 = 1, #_list_0 do local item = _list_0[_index_0]


items_gui[#items_gui + 1] = ui.column({ align = "m", colour = 
G.C.GREEN, r = 
0.05, padding = 
0.05, scale = 
0.03 }, { 




ui.text({ colour = G.C.UI.TEXT_LIGHT, scale = 
0.3, shadow = 
true }, " " .. tostring(G.P_CENTERS[item].name) .. " ") })end







desc_nodes[#desc_nodes + 1] = { 

ui.column({ align = "bm", padding = 
0.02, scale = 
0.03 }, items_gui) }end, config = { extra = { contains = 







{  } } }, calculate = function(self, card, context)if 

context.setting_blind then
card_eval_status_text(card, 'extra', nil, nil, nil, { message = "dump" })if #
card.ability.extra.contains > 0 then

SMODS.add_card({ key = card.ability.extra.contains[#card.ability.extra.contains] })

card.ability.extra.contains[#card.ability.extra.contains] = nil end end;if 

context.card_added then return 


G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 
0, blockable = 
true, blocking = 
true, func = function()if 

context.card.area == G.consumeables then
card_eval_status_text(card, 'extra', nil, nil, nil, { message = "get" })if 
G.consumeables.config.card_limit == G.consumeables.config.card_count then local temp_hand = 
{  }local _list_0 = 
G.consumeables.cards;for _index_0 = 1, #_list_0 do local card = _list_0[_index_0]
temp_hand[#temp_hand + 1] = card end
table.sort(temp_hand, function(a, b)return a.sort_id < b.sort_id end)
pseudoshuffle(temp_hand, pseudoseed('hhj_strange_sack'))do local _obj_0 = 
card.ability.extra.contains;_obj_0[#_obj_0 + 1] = temp_hand[1].config.center_key end
SMODS.destroy_cards(temp_hand[1])end end;return 
true end }))end end })

