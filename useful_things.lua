local _module_0 = {  }local config = 



SMODS.current_mod.config;_module_0["config"] = config


local wrap_method_with_manual_calling;wrap_method_with_manual_calling = function(class_, method_name, do_this)if 
class_ == nil then error("CLASS IS NIL :(")end;if 
class_[method_name] == nil then error("METHOD IS NIL :(")end;local function_wrapped_at = 
debug.getinfo(2)local original_method = 
class_[method_name]
class_[method_name] = function(...)local will_it_let_me_do_this = 
"Wrap defined at " .. tostring(function_wrapped_at.source) .. ":" .. tostring(function_wrapped_at.linedefined) .. "."local args = { 
... }return 
do_this(original_method, args)end end;_module_0["wrap_method_with_manual_calling"] = wrap_method_with_manual_calling;local _anon_func_0 = function(args)local _accum_0 = 











{  }local _len_0 = 1;for _index_0 = 2, #args do local x = args[_index_0]_accum_0[_len_0] = x;_len_0 = _len_0 + 1 end;return _accum_0 end;local wrap_method;wrap_method = function(class_, method_name, before, after)if before == nil then before = (function()return nil end)end;if after == nil then after = (function(self, original_outputs)return original_outputs end)end;local function_wrapped_at = debug.getinfo(2)return wrap_method_with_manual_calling(class_, method_name, function(original_method, args)local will_it_let_me_do_this = "Wrap defined at " .. tostring(function_wrapped_at.source) .. ":" .. tostring(function_wrapped_at.linedefined) .. "."before(unpack(args))local original_outputs = { original_method(unpack(args)) }return 
after(args[1], original_outputs, unpack(_anon_func_0(args)))end)end
_module_0["wrap_method"] = wrap_method;local _anon_func_1 = function(pairs, table)local _accum_0 = 


{  }local _len_0 = 1;for x in pairs(table) do _accum_0[_len_0] = x;_len_0 = _len_0 + 1 end;return _accum_0 end;local table_is_list;table_is_list = function(table)return # (_anon_func_1(pairs, table)) == #table end;_module_0["table_is_list"] = table_is_list

local flatten;flatten = function(list)local output = 
{  }for _index_0 = 
1, #list do local item = list[_index_0]if 
type(item) == "table" and table_is_list(item) then local _tab_0 = 
{  }local _idx_0 = 1;for _key_0, _value_0 in pairs(output) do if _idx_0 == _key_0 then _tab_0[#_tab_0 + 1] = _value_0;_idx_0 = _idx_0 + 1 else _tab_0[_key_0] = _value_0 end end;local _obj_0 = flatten(item)local _idx_1 = 1;for _key_0, _value_0 in pairs(_obj_0) do if _idx_1 == _key_0 then _tab_0[#_tab_0 + 1] = _value_0;_idx_1 = _idx_1 + 1 else _tab_0[_key_0] = _value_0 end end;output = _tab_0 else

output[#output + 1] = item end end;return 
output end;_module_0["flatten"] = flatten

local for_each;for_each = function(list, callable)local _accum_0 = {  }local _len_0 = 1;for _index_0 = 1, #list do local item = list[_index_0]_accum_0[_len_0] = callable(item)_len_0 = _len_0 + 1 end;return _accum_0 end;_module_0["for_each"] = for_each

local _traverse_default_key_not_found;_traverse_default_key_not_found = function(object, path, output_thus_far, step_index)local entire_path = 
"ORIGINAL_OBJECT"local path_until_error = 
"uhhhhhhhhhhhhh you probably shouldn't be seeing this :]"for internal_step_index, step in 
ipairs(path) do if 
type(step) == "number" then
entire_path = entire_path + "[" .. tostring(step) .. "]"else

entire_path = entire_path + "." .. tostring(step)end;if 
internal_step_index < step_index then
path_until_error = entire_path end end;return 
error("Unable to follow the path of " .. tostring(entire_path) .. ": " .. tostring(path_until_error) .. " is " .. tostring(SMODS.inspect(output_thus_far)), 3)end

local traverse;traverse = function(object, path, on_key_not_found)if on_key_not_found == nil then on_key_not_found = _traverse_default_key_not_found end;local output = 
object;for step_index, step in 
ipairs(path) do if 
output[step] == nil then return 
on_key_not_found(object, path, output, step_index)end
output = output[step]end;return 
output end;_module_0["traverse"] = traverse

local traverse_allowing_final_nil;traverse_allowing_final_nil = function(object, path)return 
traverse(object, path, function(object, path, output_thus_far, step_index)if 
step_index == #path then return 
nil else return 

_traverse_default_key_not_found(object, path, output_thus_far, step_index)end end)end
_module_0["traverse_allowing_final_nil"] = traverse_allowing_final_nil

local traverse_blindly;traverse_blindly = function(object, path)return traverse(object, path, function()return nil end)end;_module_0["traverse_blindly"] = traverse_blindly

local round;round = function(num, numDecimalPlaces)local mult = 
10 ^ (numDecimalPlaces or 0)return 
math.floor(num * mult + 0.5) / mult end;_module_0["round"] = round

local lerp;lerp = function(some_value, some_other_value, how_far)return 

some_value + (some_other_value - some_value) * how_far end;_module_0["lerp"] = lerp

local random_float;random_float = function(min, max)
assert(min <= max)return 
lerp(min, max, math.random())end;_module_0["random_float"] = random_float

local normalize;normalize = function(min, mid, max)
assert(min <= mid and mid <= max)local delta = 
max - min;local adjusted_mid = 
mid - min;return 
adjusted_mid / delta end;_module_0["normalize"] = normalize

local field_replace_context_halves;field_replace_context_halves = function(object, field_name, value)local original_value = 
object[field_name]
local start_context;start_context = function()object[field_name] = value end
local end_context;end_context = function()object[field_name] = original_value end;return 
start_context, end_context end

local field_replace_context_manual_end;field_replace_context_manual_end = function(object, field_name, value)local start_context,end_context = 
field_replace_context_halves(object, field_name, value)
start_context()return 
end_context end;_module_0["field_replace_context_manual_end"] = field_replace_context_manual_end

local multi_field_replace_context_manual_end;multi_field_replace_context_manual_end = function(list_of_object_field_values)
local endings;do local _accum_0 = {  }local _len_0 = 1;for _index_0 = 1, #list_of_object_field_values do local object_field_value = list_of_object_field_values[_index_0]_accum_0[_len_0] = field_replace_context_manual_end(unpack(object_field_value))_len_0 = _len_0 + 1 end;endings = _accum_0 end;return function()local _accum_0 = 
{  }local _len_0 = 1;for _index_0 = 1, #endings do local ending = endings[_index_0]_accum_0[_len_0] = ending()_len_0 = _len_0 + 1 end;return _accum_0 end end;_module_0["multi_field_replace_context_manual_end"] = multi_field_replace_context_manual_end

local safely_do_this_and_end;safely_do_this_and_end = function(do_this, end_context)local output = 
nil;local result,error_message = 
pcall(function()output = do_this()end)
end_context()if not 
result then
error(error_message)end;return 
output end

local field_replace_context;field_replace_context = function(object, field_name, value, do_this)if do_this == nil then do_this = function()end end;local end_context = 
field_replace_context_manual_end(object, field_name, value)return 
safely_do_this_and_end(do_this, end_context)end;_module_0["field_replace_context"] = field_replace_context

local multi_field_replace_context;multi_field_replace_context = function(list_of_object_field_values, do_this)if do_this == nil then do_this = function()end end;local end_context = 
multi_field_replace_context_manual_end(list_of_object_field_values)return 
safely_do_this_and_end(do_this, end_context)end







_module_0["multi_field_replace_context"] = multi_field_replace_context

local field_operation_context;field_operation_context = function(object, field_name, operation, do_this)if do_this == nil then do_this = function()end end;return 
field_replace_context(object, field_name, operation(object[field_name]), do_this)end;_module_0["field_operation_context"] = field_operation_context

local field_addition_context;field_addition_context = function(object, field_name, the_guy_you_add_idk, do_this)if do_this == nil then do_this = function()end end;return 
field_operation_context(object, field_name, (function(x)return x + the_guy_you_add_idk end), do_this)end;_module_0["field_addition_context"] = field_addition_context

local field_multiplication_context;field_multiplication_context = function(object, field_name, multiplier, do_this)if do_this == nil then do_this = function()end end;return 
field_operation_context(object, field_name, (function(x)return x * multiplier end), do_this)end;_module_0["field_multiplication_context"] = field_multiplication_context

local pool_filter_context_manual_end;pool_filter_context_manual_end = function(filter, fallback, do_this)if do_this == nil then do_this = function()end end;return 


safely_do_this_and_end(multi_field_replace_context_manual_end({ { G, "hhj_pool_filter", filter }, { 
G, "hhj_pool_fallback", fallback } }), 

do_this)end;_module_0["pool_filter_context_manual_end"] = pool_filter_context_manual_end

local pool_filter_context;pool_filter_context = function(filter, fallback, do_this)if do_this == nil then do_this = function()end end;return 
field_replace_context(G, "hhj_pool_filter", filter, function()return 
field_replace_context(G, "hhj_pool_fallback", fallback, function()return 
do_this()end)end)end

_module_0["pool_filter_context"] = pool_filter_context

local filtered_pool;filtered_pool = function(pool, filter, fallback)if filter == nil then filter = nil end;if fallback == nil then fallback = nil end;local original_pool = 
pool;if not 
filter then return 
original_pool end;local unavalibilities = 
0
local its_unavaliable;its_unavaliable = function()
unavalibilities = unavalibilities + 1;return 
"UNAVAILABLE"end

local new_pool;do local _accum_0 = {  }local _len_0 = 1;for _index_0 = 1, #original_pool do local item = original_pool[_index_0]_accum_0[_len_0] = (item ~= "UNAVAILABLE" and filter(G.P_CENTERS[item])) and item or its_unavaliable()_len_0 = _len_0 + 1 end;new_pool = _accum_0 end;if 













unavalibilities >= #new_pool then if 
fallback == "UNFILTERED" then return 
original_pool else if 
fallback then return { 
fallback }else local filter_info = 

debug.getinfo(filter)
error("The filter(defined at " .. tostring(filter_info.source) .. ") resulted in no valid centers, and a fallback wasn't provided :(")end end end;return 

new_pool end;_module_0["filtered_pool"] = filtered_pool

wrap_method(_G, "get_current_pool", nil, function(self, original_outputs, args)local pool,pool_key = 
unpack(original_outputs)
pool = filtered_pool(pool, G.hhj_pool_filter, G.hhj_pool_fallback)return 
pool, pool_key end)





local create_card_filtered;create_card_filtered = function(kwargs)if kwargs == nil then kwargs = {  }end;return 
pool_filter_context(kwargs.filter, kwargs.fallback, function()return 
SMODS.create_card(kwargs)end)end





























_module_0["create_card_filtered"] = create_card_filtered

local pseudorandom_center_key;pseudorandom_center_key = function(pool, pool_key)if pool_key == nil then pool_key = ""end;local center = 

pseudorandom_element(pool, pseudoseed(pool_key))local it = 
1;while 
center == 'UNAVAILABLE' do
it = it + 1
center = pseudorandom_element(pool, pseudoseed(pool_key .. '_resample' .. it))end;return 
center end;_module_0["pseudorandom_center_key"] = pseudorandom_center_key

local pseudorandom_center;pseudorandom_center = function(pool, pool_key)if pool_key == nil then pool_key = ""end;return G.P_CENTERS[pseudorandom_center_key(pool, pool_key)]end;_module_0["pseudorandom_center"] = pseudorandom_center;return _module_0;