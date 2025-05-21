assert(SMODS.load_file("libs\\LuaNES\\main.lua"))()local frame_multiplier = 












math.floor(207 / 19 / 2)local keys = { UP = 


"w", LEFT = 
"a", DOWN = 
"s", RIGHT = 
"d", A = 
"o", B = 
"p", SELECT = 
"i", START = 
"return", NOTHING = 
"4" }



local Input;do local _class_0;local _base_0 = { copy = function(self)return 





Input(self.key, self.frames)end }if _base_0.__index == nil then _base_0.__index = _base_0 end;_class_0 = setmetatable({ __init = function(self, key, frames)self.key = key;self.frames = frames end, __base = _base_0, __name = "Input" }, { __index = _base_0, __call = function(cls, ...)local _self_0 = setmetatable({  }, _base_0)cls.__init(_self_0, ...)return _self_0 end })_base_0.__class = _class_0;Input = _class_0 end

local pretend_youre_drawable;pretend_youre_drawable = function(drawable, and_do_this)
prep_draw(drawable, 1)
and_do_this()return 
love.graphics.pop()end

local pretend_youre_a_center;pretend_youre_a_center = function(center, and_do_this)if not 
center.states.visible then return end;if 
center.sprite_pos.x ~= center.sprite_pos_copy.x or center.sprite_pos.y ~= center.sprite_pos_copy.y then
center:set_sprite_pos(center.sprite_pos)end
prep_draw(center, 1)
love.graphics.scale(1 / (center.scale.x / center.VT.w), 1 / (center.scale.y / center.VT.h))
love.graphics.setColor(overlay or G.BRUTE_OVERLAY or G.C.WHITE)
and_do_this()

love.graphics.pop()
add_to_drawhash(center)
center:draw_boundingrect()if 
center.shader_tab then return love.graphics.setShader()end end

local score_to_chips;score_to_chips = function(score)return math.floor(score / 10)end;local pac_man = 


SMODS.Joker({ key = "pac_man", atlas = 




"atlas_single_card", pos = 
atlas_single_card_positions["single_card"], loc_txt = { name = 


"Pac-Man", text = { 

"Play literally Pac-Man for the NES lmao", 
"Control it by scoring cards", 
"{s:0.8,C:inactive}Number cards hold the direction of their suit", 
"{s:0.8,C:inactive}for that number of frames (x" .. tostring(frame_multiplier) .. ")", 
"{s:0.8,C:inactive}Faces and Aces just press their button", 
"{s:0.8,C:inactive}The game doesn't run when no input is given", 
"{C:attention}Score: #1# {}→{C:chips} Chips: #2#" } }, loc_vars = function(self, info_queue, card)return { vars = { 



card.ability.score, 
score_to_chips(card.ability.score) } }end, prepare_yourself = function(self, card)




card.doesnt_save = { nes = spawn_a_nes(), inputs = 
{  }, frames_per_frame = 
1, cover_sprite = 
Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS["hhj_atlas_jokers"], atlas_jokers_positions["pac_man"]) }

card.doesnt_save.cover_sprite.states.hover = card.states.hover
card.doesnt_save.cover_sprite.states.click = card.states.click
card.doesnt_save.cover_sprite.states.drag = card.states.drag
card.doesnt_save.cover_sprite.states.collide.can = false
card.doesnt_save.cover_sprite:set_role({ major = card, role_type = 'Glued', draw_major = card })

card.doesnt_save.nes.load({ SMODS.Mods.happy_horse_jamboree.path .. "libs\\LuaNES\\roms\\Pac-Man.nes" })return 
card.doesnt_save.nes.update()end, load = function(self, card, card_table, other_card)


self:prepare_yourself(card)
card.doesnt_save.frames_per_frame = 30
card.doesnt_save.just_reloaded = true end, set_ability = function(self, card, initial, delay_sprites)

self:prepare_yourself(card)
card.doesnt_save.frames_per_frame = 1
card.ability.score = 0
card.ability.input_history = {  }local _list_0 = { 



Input(keys.START, 1), 
Input(keys.START, 1), 
Input(keys.START, 1), 
Input(keys.START, 1), 
Input(keys.START, 1), 
Input(keys.START, 1), 
Input(keys.START, 1), 
Input(keys.START, 1), 
Input(keys.NOTHING, 60), 
Input(keys.A, 1), 
Input(keys.START, 1), 
Input(keys.NOTHING, 60 * 4.5) }for _index_0 = 
1, #_list_0 do local input = _list_0[_index_0]
self:add_input(card, input)end end, draw = function(self, card, layer)


card.doesnt_save.nes.update_image()local center = 
card.children.center;local _obj_0 = 
G;if _obj_0.debug_size_offset == nil then _obj_0.debug_size_offset = 99.0 end
card.ARGS.send_to_shader.debug_size_offset = G.debug_size_offset
center:draw_shader('hhj_pac_man_screen_summary', nil, card.ARGS.send_to_shader)return 
card.doesnt_save.cover_sprite:draw_shader('dissolve', nil, nil, nil, center)end, update = function(self, card, dt)if 



























card.doesnt_save.just_reloaded and card.ability.input_history then do local _accum_0 = 
{  }local _len_0 = 1;local _list_0 = card.ability.input_history;for _index_0 = 1, #_list_0 do local input = _list_0[_index_0]_accum_0[_len_0] = Input.copy(input)_len_0 = _len_0 + 1 end;card.doesnt_save.inputs = _accum_0 end
card.doesnt_save.just_reloaded = nil end;local cpu = 

card.doesnt_save.nes:get_actual_internal_nes_object().cpu;local ram = 

cpu.ram;if 
ram then
self:process_inputs(card)local score = 

""
local peek_ram;do local _base_0 = card.doesnt_save.nes.get_actual_internal_nes_object().cpu;local _fn_0 = _base_0.peek_ram;peek_ram = _fn_0 and function(...)return _fn_0(_base_0, ...)end end;for address = 
0x0070, 0x0075 do local digit = 
peek_ram(address)if 
digit < 10 then
score = tostring(digit) .. score end end

score = score .. "0"
card.ability.score = tonumber(score)end end, generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)

SMODS.Joker.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)local nes_width = 




card.doesnt_save.nes.image:getWidth()local nes_height = 
card.doesnt_save.nes.image:getHeight()local ref_sizes = { red = { pixels = { w = 




214, h = 
200 }, stated = { w = 

240 / 100, h = 
224 / 100 } }, window = { pixels = { w = 


2048, h = 
1152 } }, nes = { pixels = { w = 


nes_width, h = 
nes_height } } }local red_stated_to_pixels_ratio = 

ref_sizes.red.pixels.w / ref_sizes.red.stated.w;local window_width,window_height = 
love.graphics.getDimensions()local window_scale = 
math.min(window_width / ref_sizes.window.pixels.w, window_height / ref_sizes.window.pixels.h)local request_this_size = { w = 




ref_sizes.red.stated.w * (ref_sizes.nes.pixels.w / ref_sizes.red.pixels.w) / window_scale, h = 
ref_sizes.red.stated.h * (ref_sizes.nes.pixels.h / ref_sizes.red.pixels.h) / window_scale }if 


card.children.h_popup then local pac_man_container = 
card.children.h_popup:get_UIE_by_ID("pac_man_container")
card.ability.screen_x = card.children.h_popup.T.x
card.ability.screen_y = card.children.h_popup.T.y end;local wait_can_i_just = 

Moveable()
wait_can_i_just.draw = function(self)
prep_draw(self, 1)local screen_x,screen_y = 
love.graphics.transformPoint(0, 0)
love.graphics.origin()local pixel_x,pixel_y = 
love.graphics.inverseTransformPoint(math.floor(screen_x + 0.5), math.floor(screen_y + 0.5))
love.graphics.setColor(1, 1, 1)
love.graphics.draw(card.doesnt_save.nes.image, pixel_x, pixel_y)return 
love.graphics.pop()end

desc_nodes[#desc_nodes + 1] = { { n = 
G.UIT.C, config = { id = 

"pac_man_container", minw = 
request_this_size.w, minh = 
request_this_size.h }, nodes = { { n = 


G.UIT.O, config = { object = 

wait_can_i_just } } } } }end, calculate = function(self, card, context)if 






context.joker_main and context.cardarea == G.jokers then return { chips = 

score_to_chips(card.ability.score) }elseif 

context.individual and context.cardarea == G.play then if 
context.other_card.ability.effect == 'Stone Card' then
return end;local input_to_add = 
nil;local card_id = 
context.other_card:get_id()if 

14 == card_id then
input_to_add = Input(keys.A, 1)elseif 
13 == card_id then
input_to_add = Input(keys.START, 1)elseif 
12 == card_id then
input_to_add = Input(keys.SELECT, 1)elseif 
11 == card_id then
input_to_add = Input(keys.B, 1)else local _exp_0 = 

context.other_card.base.suit;if 
"Spades" == _exp_0 then
input_to_add = Input(keys.UP, card_id * frame_multiplier)elseif 
"Hearts" == _exp_0 then
input_to_add = Input(keys.DOWN, card_id * frame_multiplier)elseif 
"Diamonds" == _exp_0 then
input_to_add = Input(keys.LEFT, card_id * frame_multiplier)elseif 
"Clubs" == _exp_0 then
input_to_add = Input(keys.RIGHT, card_id * frame_multiplier)else

input_to_add = nil end end;if 
input_to_add then return 

G.E_MANAGER:add_event(Event({ func = function()
self:add_input(card, input_to_add)return 
true end }))end end end, add_input = function(self, card, input)do local _obj_0 = 



card.doesnt_save.inputs;_obj_0[#_obj_0 + 1] = input end;local _obj_0 = 
card.ability.input_history;_obj_0[#_obj_0 + 1] = input:copy()end, process_inputs = function(self, card)for _ = 


1, card.doesnt_save.frames_per_frame do local input = 
card.doesnt_save.inputs[1]if 
input then if 
input.frames == 0 then
card.doesnt_save.nes.keyreleased(input.key)do local _accum_0 = 
{  }local _len_0 = 1;local _list_0 = card.doesnt_save.inputs;for _index_0 = 2, #_list_0 do local x = _list_0[_index_0]_accum_0[_len_0] = x;_len_0 = _len_0 + 1 end;card.doesnt_save.inputs = _accum_0 end
self:process_inputs(card)else

card.doesnt_save.nes.keypressed(input.key)
input.frames = input.frames - 1
card.doesnt_save.nes.update()end else

card.doesnt_save.frames_per_frame = 1 end end end })