local _optional_config_wrapper;_optional_config_wrapper = function(config_or_nodes, nodes)return nodes ~= nil and { config_or_nodes, nodes } or { {  }, config_or_nodes }end
local _container_node;_container_node = function(node_type, config_or_nodes, nodes)
local config;config, nodes = unpack(_optional_config_wrapper(config_or_nodes, nodes))return { n = 

node_type, config = 
config, nodes = 
nodes }end


local _row_or_column;_row_or_column = function(config, nodes, node_type, opposite_node_type_function, node_type_name, opposite_node_type_name)if 
nodes.n ~= nil then
nodes = { nodes }end;if 

config.align == nil then config.align = "cm"end;if 
config.padding == nil then config.padding = 0.1 end;if 
config.colour == nil then config.colour = G.C.CLEAR end;if 

ui_debugging_enabled then
config.padding = 0.1
config.outline_colour = G.C.RED
config.outline = 0.2;if 
config.debug_name == nil then config.debug_name = "some " .. node_type_name end;if 
config.tooltip == nil then config.tooltip = { title = config.debug_name, text = "" }end end;local ok_uh = #


nodes;for node_index = 
1, ok_uh do local node = 
nodes[node_index]if 
node.n == node_type then
nodes[node_index] = opposite_node_type_function({ debug_name = "automatic correction " .. opposite_node_type_name, padding = 0 }, node)end end;for _, node in 

pairs(nodes) do
assert(node.n ~= node_type)end;return 

_container_node(node_type, config, nodes)end

local row;row = function(config_or_nodes, nodes)return _row_or_column(unpack(_optional_config_wrapper(config_or_nodes, nodes), G.UIT.R, column, "row", "column"))end
local column;column = function(config_or_nodes, nodes)return _row_or_column(unpack(_optional_config_wrapper(config_or_nodes, nodes), G.UIT.C, row, "column", "row"))end
local text;text = function(config_or_nodes, nodes)return _container_node(node_type, config, nodes)end