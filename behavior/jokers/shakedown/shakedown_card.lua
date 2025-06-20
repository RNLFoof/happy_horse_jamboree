local useful_things = assert(SMODS.load_file("useful_things.lua"))()
local adjust_add;adjust_add = function(rot_amount)return rot_amount * 2 end;return 

useful_things.wrap_method(Card, "juice_up", nil, function(self, original_output, scale, rot_amount)if 
G.SETTINGS.paused then
return end;if 
self.ability.hhj_in_juice_card_until then
return end;local _list_0 = 

SMODS.find_card("j_hhj_shakedown", false)for _index_0 = 1, #_list_0 do local joker = _list_0[_index_0]

rot_amount = math.abs(rot_amount and rot_amount or 0.16)
scale = scale and scale * 0.4 or 0.11;local add = 

adjust_add(rot_amount)local add_unrounded = 
add
add = useful_things.round(add, 3)local adding_cutoff = 

adjust_add(math.max(0.03))if 



add <= adding_cutoff or add_unrounded <= adding_cutoff then
return end;local args = 

{  }local draw_layer = -
1;local attach_to = 

UIBox({ T = { 0, 0, 0, 0 }, config = { major = 

self, draw_layer = 
draw_layer, align = 
"cm" }, definition = { n = 


G.UIT.ROOT, config = { major = 
self, draw_layer = 
draw_layer, align = 
'cm', minw = (args.cover and args.cover.T.w or 0.001) + (args.cover_padding or 0), minh = (args.cover and args.cover.T.h or 0.001) + (args.cover_padding or 0), padding = 0.03, r = 0.1, emboss = args.emboss, colour = G.C.CLEAR }, nodes = {  } } })local scale_variance = 



0.2

self.childParts2 = Particles(G.CARD_W / 2, G.CARD_H / 2, 0, 0, { timer_type = 'TOTAL', timer = 
0.01, scale = 
0.2, speed = 
3, pulse_max = 
math.max(add * 10, 1), max = 
0, align = 
"cm", lifespan = 
5, colours = { 
G.C.CHIPS }, fill = 
true, attach = 
attach_to, draw_layer = 
draw_layer, hhj_config = { gravity_intensity = 

2, update_initially_until_out_of_starting_range = 
true, fixed_scale = { min = 
0.2 * (1 - scale_variance), max = 0.2 * (1 + scale_variance) }, min_speed = 
2 } })



G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 
50, blocking = 
false, blockable = 
false, func = function()

attach_to:remove()return 
true end }))local _obj_0 = 


joker.ability;_obj_0.chips = _obj_0.chips + add


attention_text({ text = "+" .. tostring(add), scale = 
useful_things.lerp(0.1, 0.75, add), hold = 
0.4, backdrop_colour = 
G.C.CHIPS, align = 
"cm", major = 
joker, offset = { x = 

G.CARD_W * math.random(-5, 5) / 10, y = 
G.CARD_H * math.random(-5, 5) / 10 } })local sound_variant = 



