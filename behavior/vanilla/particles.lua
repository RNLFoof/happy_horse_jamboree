local _module_0 = {  }local useful_things = assert(SMODS.load_file("useful_things.lua"))()

local init_after;init_after = function(self, X, Y, W, H, config)if config == nil then config = {  }end;local default_hhj_config = { update_initially_until = 

function()end, update_initially_until_out_of_starting_range = 
false, starting_range = { min_x = -

G.CARD_W / 2, max_x = 
G.CARD_W / 2, min_y = -
G.CARD_H / 2, max_y = 
G.CARD_H / 2 }, gravity_intensity = 

0, gravity_direction = 
270 }if 




config.hhj_config == nil then config.hhj_config = {  }end;local _obj_0 = 
config.hhj_config;if _obj_0.starting_range == nil then _obj_0.starting_range = {  }end;do local _tab_0 = 

{  }local _obj_1 = default_hhj_config.starting_range;local _idx_0 = 1;for _key_0, _value_0 in pairs(_obj_1) do if _idx_0 == _key_0 then _tab_0[#_tab_0 + 1] = _value_0;_idx_0 = _idx_0 + 1 else _tab_0[_key_0] = _value_0 end end;local _obj_2;do local _tab_1 = {  }local _obj_3 = config.hhj_config.starting_range;local _idx_1 = 1;for _key_0, _value_0 in pairs(_obj_3) do if _idx_1 == _key_0 then _tab_1[#_tab_1 + 1] = _value_0;_idx_1 = _idx_1 + 1 else _tab_1[_key_0] = _value_0 end end;_obj_2 = _tab_1 end;local _idx_1 = 1;for _key_0, _value_0 in pairs(_obj_2) do if _idx_1 == _key_0 then _tab_0[#_tab_0 + 1] = _value_0;_idx_1 = _idx_1 + 1 else _tab_0[_key_0] = _value_0 end end;config.hhj_config.starting_range = _tab_0 end;do local _tab_0 = 
{  }local _idx_0 = 1;for _key_0, _value_0 in pairs(default_hhj_config) do if _idx_0 == _key_0 then _tab_0[#_tab_0 + 1] = _value_0;_idx_0 = _idx_0 + 1 else _tab_0[_key_0] = _value_0 end end;local _obj_1;do local _tab_1 = {  }local _obj_2 = config.hhj_config;local _idx_1 = 1;for _key_0, _value_0 in pairs(_obj_2) do if _idx_1 == _key_0 then _tab_1[#_tab_1 + 1] = _value_0;_idx_1 = _idx_1 + 1 else _tab_1[_key_0] = _value_0 end end;_obj_1 = _tab_1 end;local _idx_1 = 1;for _key_0, _value_0 in pairs(_obj_1) do if _idx_1 == _key_0 then _tab_0[#_tab_0 + 1] = _value_0;_idx_1 = _idx_1 + 1 else _tab_0[_key_0] = _value_0 end end;config.hhj_config = _tab_0 end



self.hhj_config = config.hhj_config end;_module_0["init_after"] = init_after
useful_things.wrap_method(Particles, "init", nil, init_after)


useful_things.wrap_method(Particles, "move", nil, function(self, dt)if 
self.timer_type ~= 'REAL' then dt = dt * G.SPEEDFACTOR end;if 

self.hhj_config.gravity_intensity ~= 0 then local _list_0 = 
self.particles;for _index_0 = 1, #_list_0 do local particle = _list_0[_index_0]if 
particle.hhj == nil then particle.hhj = {  }end;local _obj_0 = 
particle.hhj;if _obj_0.gravity_speed == nil then _obj_0.gravity_speed = 0 end;local _obj_1 = 
particle.hhj;_obj_1.gravity_speed = _obj_1.gravity_speed + (self.hhj_config.gravity_intensity * dt)local _obj_2 = 
particle.offset;_obj_2.x = _obj_2.x + (math.sin(self.hhj_config.gravity_direction) * particle.hhj.gravity_speed * dt)local _obj_3 = 
particle.offset;_obj_3.y = _obj_3.y + (math.cos(self.hhj_config.gravity_direction) * particle.hhj.gravity_speed * dt)end end end)return 
_module_0;