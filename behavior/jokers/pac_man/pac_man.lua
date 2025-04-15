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
card.ability.nes.update()end end end;local pac_man = 



SMODS.Joker({ key = "pac_man", atlas = 
"atlas_jokers", loc_txt = { name = 

"Pac-Man", text = { 

"Play literally Pac-Man for the NES lmao", 
"Control it by scoring cards", 
"{s:0.8,C:inactive}Number cards hold the direction of their suit", 
"{s:0.8,C:inactive}for that number of frames", 
"{s:0.8,C:inactive}Faces and aces just press their button", 
"{s:0.8,C:inactive}Game doesn't run when no input is given" } }, pos = 

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
Input(keys.NOTHING, 60), 
Input(keys.NOTHING, 60), 
Input(keys.NOTHING, 60), 
Input(keys.NOTHING, 60), 
Input(keys.NOTHING, 30) }end, draw = function(self, card, layer)return 


card.ability.nes.draw()end, update = function(self, card, dt)return 

process_inputs(card)end, generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)

SMODS.Joker.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
print(card.ability.nes)
print(card.ability.nes.image)
desc_nodes[#desc_nodes + 1] = { { n = 
G.UIT.C, config = { minw = 

240 / 100, minh = 
224 / 100 } } }return 


print(desc_nodes)end })