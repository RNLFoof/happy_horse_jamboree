local psychostasia_enabled;psychostasia_enabled = function()return 
G.GAME.starting_params.hhj_psychostasia end

local overburdened;overburdened = function()return 
psychostasia_enabled() and #G.jokers.cards > G.jokers.config.card_limit end

local big_guy;big_guy = function(card)return 
psychostasia_enabled() and card.config.center.rarity and card.config.center.rarity >= 3 end

local force_notch_bar_update;force_notch_bar_update = function(cardArea)if 
cardArea == G.jokers and G.jokers.children.area_uibox then
G.jokers.children.area_uibox.definition.nodes[2].nodes[6] = nil end end


local alert_too_heavy;alert_too_heavy = function(card, area)
G.CONTROLLER.locks.no_space = true

attention_text({ scale = 0.9, text = "Too heavy!", hold = 0.9, align = 'cm', cover = 
area, cover_padding = 0.1, cover_colour = adjust_alpha(G.C.BLACK, 0.7) })

card:juice_up(0.3, 0.2)for i = 
1, #area.cards do
area.cards[i]:juice_up(0.15)end


G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 
0.06 * G.SETTINGS.GAMESPEED, blockable = 
false, blocking = 
false, func = function()

play_sound('tarot2', 0.76, 0.4)return 
true end }))


play_sound('tarot2', 1, 0.4)return 



G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 
0.5 * G.SETTINGS.GAMESPEED, blockable = 
false, blocking = 
false, func = function()

G.CONTROLLER.locks.no_space = nil;return 
true end }))end;local ref = 



G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)if 
G.GAME.starting_params.hhj_psychostasia and card.ability.set == 'Joker' and #G.jokers.cards + card.config.center.rarity > G.jokers.config.card_limit then
alert_too_heavy(card, G.jokers)return 
false end;return 
ref(card)end;local ref = 

Card.init
Card.init = function(self, X, Y, W, H, card, center, params)local output = 
ref(self, X, Y, W, H, card, center, params)



G.E_MANAGER:add_event(Event({ func = function()if 
G.GAME.starting_params.hhj_psychostasia then if 
self.ability and self.ability.set == 'Joker' then local new_scale = 
self.config.center.rarity * 0.5;if not 
big_guy(self) then
self.T.w = self.T.w * new_scale
self.T.h = self.T.h * new_scale else

self.T.h = G.CARD_W * new_scale
self.T.w = self.T.h * G.CARD_W / G.CARD_H end
self.VT.w = self.T.w
self.VT.h = self.T.h end end;return 
true end }))return 

output end

ref = Card.add_to_deck
Card.add_to_deck = function(self)if 
G.GAME.starting_params.hhj_psychostasia then if not 
self.added_to_deck then if 
self.ability and self.ability.set == 'Joker' then if not 
G.OVERLAY_MENU then
G.jokers.config.card_limit = G.jokers.config.card_limit - (self.config.center.rarity - 1)end end end end
ref(self)return 

force_notch_bar_update(self)end

ref = Card.remove_from_deck
Card.remove_from_deck = function(self)if 
psychostasia_enabled() then if 

self.added_to_deck then if 
self.ability and self.ability.set == 'Joker' then if not 
G.OVERLAY_MENU then
G.jokers.config.card_limit = G.jokers.config.card_limit + (self.config.center.rarity - 1)end end end end

ref(self)return 
force_notch_bar_update(self)end



ref = CardArea.draw
CardArea.draw = function(self)local notch_side = 
0.25;local notch_padding = 
0.025 / 2;local notch_emboss = 
0.1;local notch_inactive_emboss_ratio = 
0.5;local notch_r = 
0.05;local danger_color = 
G.C.HHJ_OVERBURDENED

local it
local it;if (
G.GAME.starting_params.hhj_psychostasia and self.children and self.children.area_uibox and self.children.area_uibox.definition.nodes and self.children.area_uibox.definition.nodes[2] and self.children.area_uibox.definition.nodes[2].nodes) then local it_goes_in_here = 







self.children.area_uibox.definition.nodes[2]
it = it_goes_in_here.nodes[6]end;if 

self == G.jokers and it_goes_in_here and self.children.area_uibox then if not 
it then local the_actual_bar = 
{  }local effective_card_limit = 





get_effective_card_limit()local filled_notch_count = 


0;for _, card in 
ipairs(self.cards) do for _ = 
1, rarity_or_default(card.config.center.rarity) do

the_actual_bar[#the_actual_bar + 1] = { n = G.UIT.C, config = { minh = 

notch_side + notch_padding }, nodes = { { n = 




G.UIT.R, config = { align = 

"cm", minw = ((
notch_side * rarity_or_default(card.config.center.rarity) + notch_padding * (rarity_or_default(card.config.center.rarity) - 1)) / rarity_or_default(card.config.center.rarity)), minh = 





notch_side, colour = 
filled_notch_count < effective_card_limit and G.C.RARITY[card.config.center.rarity] or danger_color, emboss = 
notch_emboss, r = 
notch_r } } } }




filled_notch_count = filled_notch_count + 1 end

the_actual_bar[#the_actual_bar + 1] = { n = G.UIT.B, config = { w = 

notch_padding, h = 
notch_padding } }end;for _ = #





self.cards + 1, self.config.card_limit do

the_actual_bar[#the_actual_bar + 1] = { n = G.UIT.C, config = { minh = notch_side + notch_padding, mninw = notch_side + notch_emboss }, nodes = { { n = 



G.UIT.R, nodes = { { n = G.UIT.C, config = { minw = notch_side, minh = notch_side + notch_emboss, align = "bm" }, nodes = { { n = 






G.UIT.R, config = { minw = 

notch_side, minh = 
notch_side + notch_padding, colour = 
G.C.UI.BACKGROUND_INACTIVE, emboss = 
notch_emboss * notch_inactive_emboss_ratio, r = 
1 } } } } } } } }







the_actual_bar[#the_actual_bar + 1] = { n = G.UIT.B, config = { w = 
notch_padding, h = notch_padding } }end;if 



overburdened() then
the_actual_bar[#the_actual_bar + 1] = { n = G.UIT.B, config = { w = 0.1 / 2, h = 0.1 } }
the_actual_bar[#the_actual_bar + 1] = { n = G.UIT.T, config = { text = "Overburdened! Jokers won't activate!", scale = 0.3, colour = danger_color } }end

it_goes_in_here.nodes[6] = { n = G.UIT.C, config = { colour = G.C.CLEAR }, nodes = { { n = 
G.UIT.R, config = { colour = G.C.CLEAR, minw = notch_side * 1 + notch_padding * 9, minh = notch_side + notch_padding, align = "cm" }, nodes = 
the_actual_bar } } }

self.children.area_uibox = UIBox({ definition = self.children.area_uibox.definition, config = self.children.area_uibox.config })end end;return 

ref(self)end







local rarity_or_default;rarity_or_default = function(rarity)if 
type(rarity) == "number" then return rarity else return 2 end end

local get_effective_card_count;get_effective_card_count = function()local effective_card_count = 
0;for _, card in 
ipairs(G.jokers.cards) do
effective_card_count = effective_card_count + rarity_or_default(card.config.center.rarity)end;return 
effective_card_count end

local get_effective_card_limit;get_effective_card_limit = function()return 
get_effective_card_count() + (G.jokers.config.card_limit - #G.jokers.cards)end

ref = CardArea.align_cards
CardArea.align_cards = function(self)
ref(self)if not 

psychostasia_enabled() then
return end
assert(G.GAME.starting_params.hhj_psychostasia)if 



self.config.type == 'joker' and #self.cards > 0 and self.cards[1].config.center.rarity then local psychostasia_k = 
0;local ecc = 
get_effective_card_count()local previous_psychostasia_k = 
0;for k, card in 

ipairs(self.cards) do
psychostasia_k = psychostasia_k + card.config.center.rarity;local width_of_this_card = 


card.config.center.rarity * 0.5 * self.card_w;if not 
card.states.drag.is then
card.T.r = 0.1 * (-ecc / 2 - 0.5 + psychostasia_k) / (ecc) + (G.SETTINGS.reduced_motion and 0 or 1) * 0.02 * math.sin(2 * G.TIMERS.REAL + card.T.x)if 

ecc > 2 or (ecc > 1 and self == G.consumeables) or (ecc > 1 and self.config.spread) then local _obj_0 = 

card.T;_obj_0.x = _obj_0.x + ((self.T.w - self.card_w * 0.5) * ((previous_psychostasia_k) / (ecc - 1)) + 0.5 * (width_of_this_card - card.T.w))end;local highlight_height = 







G.HIGHLIGHT_H / 2;if not 
card.highlighted then highlight_height = 0 end;local _obj_0 = 
card.T;_obj_0.y = _obj_0.y + (self.T.h / 2 - card.T.h / 2 - highlight_height + (G.SETTINGS.reduced_motion and 0 or 1) * 0.03 * math.sin(0.666 * G.TIMERS.REAL + card.T.x))local _obj_1 = 
card.T;_obj_1.x = _obj_1.x + (card.shadow_parrallax.x / 30)end

previous_psychostasia_k = psychostasia_k end


table.sort(self.cards, function(a, b)return a.T.x + a.T.w / 2 < b.T.x + b.T.w / 2 end)local positions = 
""for _, card in 
ipairs(self.cards) do positions = positions .. (card.ability and card.ability.name or 'idk')end;if 
positions ~= self.hhj_previousJokerPositions then
force_notch_bar_update(G.jokers)end
self.hhj_previousJokerPositions = positions end;for k, card in 


ipairs(self.cards) do if 



big_guy(card) and ((math.abs(card.T.r) % math.pi * 2) < math.pi / 4) then
card.T.r = card.T.r + math.pi / 2
card.VT.r = card.T.r end end end



ref = Card.calculate_joker
Card.calculate_joker = function(self, context)local output = 
ref(self, context)if 


self.ability.set == "Joker" and overburdened() then if 
output then



G.E_MANAGER:add_event(Event({ trigger = 'before', delay = 
0.4, func = function()



attention_text({ text = "Overburdened!", scale = 
0.6, hold = 
0.65 - 0.2, backdrop_colour = 
G.C.HHJ_OVERBURDENED, align = 
"bm", major = 
self, offset = { x = 
0, y = 0.05 * self.T.h } })

play_sound("cancel", 0.8 + 1 * 0.2, 1)
self:juice_up(0.6, 0.1)local _obj_0 = 
G.ROOM;_obj_0.jiggle = _obj_0.jiggle + 0.7;return 
true end }))end;return 


nil end;return 
output end;local ref = 


Game.update
Game.update = function(self, dt)
ref(self, dt)if not 
G.C.HHJ_OVERBURDENED then
self.C.HHJ_OVERBURDENED = { 1, 1, 1, 1 }local dif = 
1 / 8
G.C.HHJ_OVERBURDENED[1] = (1 - dif) + dif * (1 + math.sin(self.TIMERS.REAL * 3))
G.C.HHJ_OVERBURDENED[2] = (1 - 3 * dif) + dif * (1 + math.sin(self.TIMERS.REAL * 4.5))
G.C.HHJ_OVERBURDENED[3] = (1 - 5 * dif)end end