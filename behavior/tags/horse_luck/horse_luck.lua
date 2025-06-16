return 
SMODS.Tag({ key = "horse_luck", loc_txt = { name = 

"HORSE LUCK TAG", text = { 

"Shop has a {C:attention}horse{} :)" } }, atlas = 

"hhj_atlas_tags", pos = 
atlas_tags_positions["horse_luck"], no_collection = 
true, in_pool = function(self, args)return 
false end, apply = function(self, tag, context)if not (

context.type == "store_joker_create") then
return end;local card = 

SMODS.create_card({ set = "Joker", area = 
context.area, key = 
"j_hhj_horse_base", key_append = 
'horse_luck' })
create_shop_card_ui(card, 'Joker', context.area)
card.states.visible = false
tag:yep("HORSE LUCK", G.C.GREEN, function()
card:start_materialize()
card.ability.couponed = true;return 
true end)

tag.triggered = true;return 
card end })