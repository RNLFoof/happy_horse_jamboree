local _module_0 = {  }
local _optional_config_wrapper;_optional_config_wrapper = function(config_or_additional_args, ...)return (...) ~= nil and { config_or_additional_args, ... } or { {  }, config_or_additional_args }end;_module_0["_optional_config_wrapper"] = _optional_config_wrapper
local _container_node;_container_node = function(node_type, config_or_nodes, nodes)
local config;config, nodes = unpack(_optional_config_wrapper(config_or_nodes, nodes))if #
nodes == 0 then
nodes = nil end;return { n = 

node_type, config = 
config, nodes = 
nodes }end


local _row_or_column;_row_or_column = function(config, nodes, node_type, opposite_node_type_function, node_type_name, opposite_node_type_name)if 
nodes == nil then nodes = {  }end;if 
nodes.n ~= nil then
nodes = { nodes }end;if 

config.align == nil then config.align = "cm"end;if 
config.padding == nil then config.padding = 0.1 end;if 
config.colour == nil then config.colour = G.C.CLEAR end;if 

SMODS.Mods.happy_horse_jamboree.config["Debug Mode"] then
config.padding = 0.1
config.outline_colour = node_type_name == "column" and G.C.RED or G.C.BLUE
config.outline = 0.2;if 
config.debug_name == nil then config.debug_name = "some " .. node_type_name end;if 
config.tooltip == nil then config.tooltip = { title = config.debug_name, text = { "(contains " .. tostring(#nodes) .. " nodes)" } }end end;local ok_uh = #


nodes;for node_index = 
1, ok_uh do local node = 
nodes[node_index]if 
node.n == node_type then
nodes[node_index] = opposite_node_type_function({ debug_name = "automatic correction " .. opposite_node_type_name, padding = 0 }, node)end end;for _, node in 

pairs(nodes) do
assert(node.n ~= node_type)end;return 

_container_node(node_type, config, nodes)end

local row;row = function(config_or_nodes, nodes)
local config;config, nodes = unpack(_optional_config_wrapper(config_or_nodes, nodes))return 
_row_or_column(config, nodes, G.UIT.R, column, "row", "column")end;_module_0["row"] = row
local column;column = function(config_or_nodes, nodes)
local config;config, nodes = unpack(_optional_config_wrapper(config_or_nodes, nodes))return 
_row_or_column(config, nodes, G.UIT.C, row, "column", "row")end;_module_0["column"] = column

local text;text = function(config_or_text, text)
local config;config, text = unpack(_optional_config_wrapper(config_or_text, text))do local _tab_0 = { scale = 

1, text = 
text, colour = 
G.C.WHITE }local _idx_0 = 
1;for _key_0, _value_0 in pairs(config) do if _idx_0 == _key_0 then _tab_0[#_tab_0 + 1] = _value_0;_idx_0 = _idx_0 + 1 else _tab_0[_key_0] = _value_0 end end;config = _tab_0 end;local output = 


row({ n = G.UIT.T, config = 
config })return 

output end;_module_0["text"] = text;return _module_0;