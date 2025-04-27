local useful_things = assert(SMODS.load_file("useful_things.lua"))()return 

useful_things.wrap_method(Card, "juice_up", nil, function(self, scale, rot_amount)if 
self.config.center.key == "j_mig_shakedown" then
return end;local _list_0 = 
SMODS.find_card("j_mig_shakedown", false)for _index_0 = 1, #_list_0 do local joker = _list_0[_index_0]

rot_amount = math.abs(rot_amount and rot_amount or 0.16)
scale = scale and scale * 0.4 or 0.11;local add = 

scale * rot_amount;local add_unrounded = 
add
add = useful_things.round(add, 3)

print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
print(rot_amount, scale, add_unrounded, add)local args = 



{  }local draw_layer = -
99;local attach_to = 

UIBox({ T = { 0, 0, 0, 0 }, config = { major = 

self, draw_layer = 
draw_layer, align = 
"cm" }, definition = { n = 


G.UIT.ROOT, config = { major = 
self, align = 
"cm", draw_layer = 
draw_layer, align = 
'cm', minw = (args.cover and args.cover.T.w or 0.001) + (args.cover_padding or 0), minh = (args.cover and args.cover.T.h or 0.001) + (args.cover_padding or 0), padding = 0.03, r = 0.1, emboss = args.emboss, colour = G.C.CLEAR }, nodes = {  } } })




self.childParts2 = Particles(G.CARD_W / 2, G.CARD_H / 2, 0, 0, { timer_type = 'TOTAL', timer = 
0.01, scale = 
0.2, speed = 
5, pulse_max = 
math.max(add * 10, 1), max = 
0, align = 
"cm", attach = 

self, colours = { 
G.C.CHIPS }, fill = 
true, attach = 
attach_to, draw_layer = 
draw_layer })



G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 
5, func = function()

attach_to:remove()return 
true end }))if 



add < 0.001 or add_unrounded < 0.001 then
return end;local _obj_0 = 

joker.ability;_obj_0.chips = _obj_0.chips + add


attention_text({ text = "+" .. tostring(add), scale = (
add * 10) ^ 0.5, hold = 
0.4, backdrop_colour = 
G.C.CHIPS, align = 
"cm", major = 
joker, offset = { x = 

G.CARD_W * math.random(-5, 5) / 10, y = 
G.CARD_H * math.random(-5, 5) / 10 } })end end)




