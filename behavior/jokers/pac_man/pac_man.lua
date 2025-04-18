assert(SMODS.load_file("libs\\LuaNES\\main.lua"))()local keys = { UP = 


"w", LEFT = 
"a", DOWN = 
"s", RIGHT = 
"d", A = 
"o", B = 
"p", SELECT = 
"i", START = 
"return", NOTHING = 
"4" }



local Input;do local _class_0;local _base_0 = {  }if _base_0.__index == nil then _base_0.__index = _base_0 end


_class_0 = setmetatable({ __init = function(self, key, frames)self.key = key;self.frames = frames end, __base = _base_0, __name = "Input" }, { __index = _base_0, __call = function(cls, ...)local _self_0 = setmetatable({  }, _base_0)cls.__init(_self_0, ...)return _self_0 end })_base_0.__class = _class_0;Input = _class_0 end

local process_inputs;process_inputs = function(card)local input = 
card.ability.inputs[1]if 
input then if 
input.frames == 0 then
card.ability.nes.keyreleased(input.key)
print("release ", input.key)do local _accum_0 = 
{  }local _len_0 = 1;local _list_0 = card.ability.inputs;for _index_0 = 2, #_list_0 do local x = _list_0[_index_0]_accum_0[_len_0] = x;_len_0 = _len_0 + 1 end;card.ability.inputs = _accum_0 end;return 
process_inputs(card)else

card.ability.nes.keypressed(input.key)
print("press ", input.key)
input.frames = input.frames - 1;return 
card.ability.nes.update()end end end

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

local field_replace_context;field_replace_context = function(object, field_name, value, do_this)local original_value = 
object[field_name]
object[field_name] = value
do_this()
object[field_name] = original_value end


local field_operation_context;field_operation_context = function(object, field_name, operation, do_this)return 
field_replace_context(object, field_name, operation(object[field_name]), do_this)end

local field_addition_context;field_addition_context = function(object, field_name, the_guy_you_add_idk, do_this)return 
field_operation_context(object, field_name, (function(x)return x + the_guy_you_add_idk end), do_this)end

local field_multiplication_context;field_multiplication_context = function(object, field_name, multiplier, do_this)return 
field_operation_context(object, field_name, (function(x)return x * multiplier end), do_this)end;local pac_man = 


SMODS.Joker({ key = "pac_man", atlas = 
"atlas_jokers", loc_txt = { name = 

"Pac-Man", text = { 

"Play literally Pac-Man for the NES lmao", 
"Control it by scoring cards", 
"{s:0.8,C:inactive}Number cards hold the direction of their suit", 
"{s:0.8,C:inactive}for that number of frames", 
"{s:0.8,C:inactive}Faces and Aces just press their button", 
"{s:0.8,C:inactive}The game doesn't run when no input is given", 
"{C:chips}Score/Chips: #1#" } }, loc_vars = function(self, info_queue, card)return { vars = { 



card.ability.score } }end, pos = 

atlas_jokers_positions["pac_man"], set_ability = function(self, card, initial, delay_sprites)

card.ability.nes = spawn_a_nes()

card.ability.nes.load({ "Mods\\balatro-unknown-mod\\libs\\LuaNES\\roms\\Pac-Man.nes" })
card.ability.nes.update()


card.ability.inputs = { Input(keys.START, 1), 
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
Input(keys.NOTHING, 60 * 4.5) }

card.ability.score = 0 end, draw = function(self, card, layer)

card.ability.nes.update_image()local center = 










card.children.center;local screen_dims = { x = 


10, y = 
10, w = 
51, h = 
46 }local screen_size_multiplier_x = 

256 / screen_dims.w;local screen_size_multiplier_y = 
240 / screen_dims.h;local multiply_your_pixels_by_this_for_movement = 
G.CARD_W / 71;return 
field_multiplication_context(center.scale, "x", screen_size_multiplier_x, function()return 
field_multiplication_context(center.scale, "y", screen_size_multiplier_y, function()return 
field_addition_context(center.VT, "x", (screen_dims.x - 1) * multiply_your_pixels_by_this_for_movement, function()return 
field_addition_context(center.VT, "y", (screen_dims.y) * multiply_your_pixels_by_this_for_movement, function()return 
pretend_youre_a_center(center, function()return 
love.graphics.draw(spawned_nes.image, 0, 0)end)end)end)end)end)end, update = function(self, card, dt)








process_inputs(card)local score = 
""
local peek_ram;do local _base_0 = card.ability.nes.get_actual_internal_nes_object().cpu;local _fn_0 = _base_0.peek_ram;peek_ram = _fn_0 and function(...)return _fn_0(_base_0, ...)end end;for address = 
0x0070, 0x0075 do
score = tostring(peek_ram(address)) .. score end
score = score .. "0"
card.ability.score = tonumber(score)return 
print(score, card.ability.score)end, generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)

SMODS.Joker.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)local nes_width = 




spawned_nes.image:getWidth()local nes_height = 
spawned_nes.image:getHeight()local ref_sizes = { red = { pixels = { w = 




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










love.graphics.draw(spawned_nes.image, pixel_x, pixel_y)return 
love.graphics.pop()end

desc_nodes[#desc_nodes + 1] = { { n = 
G.UIT.C, config = { id = 

"pac_man_container", minw = 
request_this_size.w, minh = 
request_this_size.h }, nodes = { { n = 



G.UIT.O, config = { object = 

wait_can_i_just } } } } }end })