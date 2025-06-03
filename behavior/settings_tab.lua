local _module_0 = {  }local useful_things = 


assert(SMODS.load_file("useful_things.lua"))()local ui = 
assert(SMODS.load_file("behavior/functions/ui.lua"))()local for_each = 

useful_things.for_each;local flatten = 
useful_things.flatten;local config = 

SMODS.current_mod.config

local indent;indent = function(string, indent_count)if indent_count == nil then indent_count = 1 end;return ("    "):rep(indent_count) .. string end
local indent_all;indent_all = function(list_of_strings, indent_count)if indent_count == nil then indent_count = 1 end;local _accum_0 = {  }local _len_0 = 1;for _index_0 = 1, #list_of_strings do local string = list_of_strings[_index_0]_accum_0[_len_0] = indent(string, indent_count)_len_0 = _len_0 + 1 end;return _accum_0 end
local print_and_out;print_and_out = function(o)return 

o end

local ConfigPart;do local _class_0;local _base_0 = { as_config_file = function(self)return 


table.concat(self:_config_file_lines(), "\n")end, as_nodes = function(self)return 

error("Not implemented!")end, _scale = function(self)return 
0.75 ^ #self._path_without_self end, _text_scale = function(self)return 
0.4 * self:_scale()end, _lines_start = function(self)return 
"[\"" .. tostring(self.name) .. "\"] = "end, _lines_end = function(self)return 
","end, _path_with_self = function(self)local _tab_0 = 
{  }local _obj_0 = self._path_without_self;local _idx_0 = 1;for _key_0, _value_0 in pairs(_obj_0) do if _idx_0 == _key_0 then _tab_0[#_tab_0 + 1] = _value_0;_idx_0 = _idx_0 + 1 else _tab_0[_key_0] = _value_0 end end;_tab_0[#_tab_0 + 1] = self.name;return _tab_0 end, _config_file_lines = function(self)return 
error("Not implemented!")end, _ref_value = function(self)return 
self.name end, _ref = function(self)return { ref_table = 
self:_ref_table(), ref_value = self:_ref_value() }end, _ref_table = function(self)local output = 


config;local _list_0 = 
self._path_without_self;for _index_0 = 1, #_list_0 do local step = _list_0[_index_0]
output = output[step]end;return 
output end, update_config_file = function(self)local file = 


io.open(tostring(SMODS.Mods.happy_horse_jamboree.path) .. "config.lua", "w")
io.output(file)
io.write(self:as_config_file())return 
io.close(file)end }if _base_0.__index == nil then _base_0.__index = _base_0 end;_class_0 = setmetatable({ __init = function(self, name)self.name = name;self._path_without_self = {  }end, __base = _base_0, __name = "ConfigPart" }, { __index = _base_0, __call = function(cls, ...)local _self_0 = setmetatable({  }, _base_0)cls.__init(_self_0, ...)return _self_0 end })_base_0.__class = _class_0;ConfigPart = _class_0 end;local _anon_func_0 = function(self)local _accum_0 = 






















{  }local _len_0 = 1;local _list_0 = self.options;for _index_0 = 1, #_list_0 do local option = _list_0[_index_0]_accum_0[_len_0] = option:_config_file_lines()_len_0 = _len_0 + 1 end;return _accum_0 end;local OptionBundle;do local _class_0;local _parent_0 = ConfigPart;local _base_0 = { as_nodes = function(self)return { ui.text({ scale = self:_text_scale() }, self.name), ui.column({ outline = 1.2, outline_colour = G.C.JOKER_GREY, r = 0.1, colour = { 0, 0, 0, 0.2 } }, flatten(for_each(self.options, function(option)return option:as_nodes()end))) }end, _config_file_lines = function(self)local _tab_0 = { tostring(self:_lines_start()) .. "{" }local _obj_0;local _accum_0 = {  }local _len_0 = 1;local _list_0 = (flatten(_anon_func_0(self)))for _index_0 = 1, #_list_0 do local option_line = _list_0[_index_0]_accum_0[_len_0] = indent(option_line)_len_0 = _len_0 + 1 end;_obj_0 = _accum_0;local _idx_0 = 1;for _key_0, _value_0 in 









pairs(_obj_0) do if _idx_0 == _key_0 then _tab_0[#_tab_0 + 1] = _value_0;_idx_0 = _idx_0 + 1 else _tab_0[_key_0] = _value_0 end end
_tab_0[#_tab_0 + 1] = self:_lines_end()return _tab_0 end, _lines_end = function(self)return 


"},"end }for _key_0, _val_0 in pairs(_parent_0.__base) do if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then _base_0[_key_0] = _val_0 end end;if _base_0.__index == nil then _base_0.__index = _base_0 end;setmetatable(_base_0, _parent_0.__base)_class_0 = setmetatable({ __init = function(self, name, options)self.name = name;self.options = options;_class_0.__parent.__init(self, self.name)local _list_0 = self.options;for _index_0 = 1, #_list_0 do local option = _list_0[_index_0]option._path_without_self = self:_path_with_self()end end, __base = _base_0, __name = "OptionBundle", __parent = _parent_0 }, { __index = function(cls, name)local val = rawget(_base_0, name)if val == nil then local parent = rawget(cls, "__parent")if parent then return parent[name]end else return val end end, __call = function(cls, ...)local _self_0 = setmetatable({  }, _base_0)cls.__init(_self_0, ...)return _self_0 end })_base_0.__class = _class_0;if _parent_0.__inherited then _parent_0.__inherited(_parent_0, _class_0)end;OptionBundle = _class_0 end

local ConfigRoot;do local _class_0;local _parent_0 = OptionBundle;local _base_0 = { _path_with_self = function(self)return 

{  }end, _lines_start = function(self)return 
"return "end, _lines_end = function(self)return 
"}"end, as_nodes = function(self)return { 
ui.row(ui.column(flatten(for_each(self.options, function(option)return option:as_nodes()end)))) }end }for _key_0, _val_0 in pairs(_parent_0.__base) do if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then _base_0[_key_0] = _val_0 end end;if _base_0.__index == nil then _base_0.__index = _base_0 end;setmetatable(_base_0, _parent_0.__base)_class_0 = setmetatable({ __init = function(self, options)return _class_0.__parent.__init(self, nil, options)end, __base = _base_0, __name = "ConfigRoot", __parent = _parent_0 }, { __index = function(cls, name)local val = rawget(_base_0, name)if val == nil then local parent = rawget(cls, "__parent")if parent then return parent[name]end else return val end end, __call = function(cls, ...)local _self_0 = setmetatable({  }, _base_0)cls.__init(_self_0, ...)return _self_0 end })_base_0.__class = _class_0;if _parent_0.__inherited then _parent_0.__inherited(_parent_0, _class_0)end;ConfigRoot = _class_0 end

local Option;do local _class_0;local _parent_0 = ConfigPart;local _base_0 = { _config_file_lines = function(self)return { 

tostring(self:_lines_start()) .. " " .. tostring(self.default) .. tostring(self:_lines_end()) }end }for _key_0, _val_0 in pairs(_parent_0.__base) do if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then _base_0[_key_0] = _val_0 end end;if _base_0.__index == nil then _base_0.__index = _base_0 end;setmetatable(_base_0, _parent_0.__base)_class_0 = setmetatable({ __init = function(self, name, default)self.name = name;self.default = default;return _class_0.__parent.__init(self, self.name)end, __base = _base_0, __name = "Option", __parent = _parent_0 }, { __index = function(cls, name)local val = rawget(_base_0, name)if val == nil then local parent = rawget(cls, "__parent")if parent then return parent[name]end else return val end end, __call = function(cls, ...)local _self_0 = setmetatable({  }, _base_0)cls.__init(_self_0, ...)return _self_0 end })_base_0.__class = _class_0;if _parent_0.__inherited then _parent_0.__inherited(_parent_0, _class_0)end;Option = _class_0 end;local _anon_func_1 = function(pairs, self)local _tab_0 = { label = 


self.name, scale = self:_scale(), label_scale = self:_text_scale() }local _obj_0 = self:_ref()local _idx_0 = 1;for _key_0, _value_0 in pairs(_obj_0) do if _idx_0 == _key_0 then _tab_0[#_tab_0 + 1] = _value_0;_idx_0 = _idx_0 + 1 else _tab_0[_key_0] = _value_0 end end;return _tab_0 end;local BooleanOption;do local _class_0;local _parent_0 = Option;local _base_0 = { as_nodes = function(self)return { create_toggle(_anon_func_1(pairs, self)) }end }for _key_0, _val_0 in pairs(_parent_0.__base) do if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then _base_0[_key_0] = _val_0 end end;if _base_0.__index == nil then _base_0.__index = _base_0 end;setmetatable(_base_0, _parent_0.__base)_class_0 = setmetatable({ __init = function(self, ...)return _class_0.__parent.__init(self, ...)end, __base = _base_0, __name = "BooleanOption", __parent = _parent_0 }, { __index = function(cls, name)local val = rawget(_base_0, name)if val == nil then local parent = rawget(cls, "__parent")if parent then return parent[name]end else return val end end, __call = function(cls, ...)local _self_0 = setmetatable({  }, _base_0)cls.__init(_self_0, ...)return _self_0 end })_base_0.__class = _class_0;if _parent_0.__inherited then _parent_0.__inherited(_parent_0, _class_0)end;BooleanOption = _class_0 end;local config_structure = 




ConfigRoot({ BooleanOption("Show Horse Variants In Collection (requires restart)", false), 

OptionBundle("HHJ Aces", { BooleanOption("In Main Menu", true), 
BooleanOption("Everywhere Else", true) }), 
BooleanOption("Debug Mode", false) })_module_0["config_structure"] = config_structure



print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
print(config_structure:as_config_file())
config_structure:update_config_file()

SMODS.current_mod.config_tab = function()return { n = 
G.UIT.ROOT, config = { colour = 

G.C.CLEAR }, nodes = 

config_structure:as_nodes() }end


print(config_structure:as_nodes())return _module_0;