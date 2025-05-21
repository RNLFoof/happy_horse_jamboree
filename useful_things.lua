local _module_0 = {  }local _anon_func_0 = function(args)local _accum_0 = 














{  }local _len_0 = 1;for _index_0 = 2, #args do local x = args[_index_0]_accum_0[_len_0] = x;_len_0 = _len_0 + 1 end;return _accum_0 end;local wrap_method;wrap_method = function(class_, method_name, before, after)if before == nil then before = (function()return nil end)end;if after == nil then after = (function(self, original_outputs)return original_outputs end)end;if class_ == nil then error("CLASS IS NIL :(")end;if class_[method_name] == nil then error("METHOD IS NIL :(")end;local ref = class_[method_name]class_[method_name] = function(...)before(...)local original_outputs = { ref(...) }local args = { ... }return 
after(args[1], original_outputs, unpack(_anon_func_0(args)))end end;_module_0["wrap_method"] = wrap_method

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

local field_replace_context;field_replace_context = function(object, field_name, value, do_this)local original_value = 
object[field_name]
object[field_name] = value;local output = 
do_this()
object[field_name] = original_value;return 
output end;_module_0["field_replace_context"] = field_replace_context

local field_operation_context;field_operation_context = function(object, field_name, operation, do_this)return 
field_replace_context(object, field_name, operation(object[field_name]), do_this)end;_module_0["field_operation_context"] = field_operation_context

local field_addition_context;field_addition_context = function(object, field_name, the_guy_you_add_idk, do_this)return 
field_operation_context(object, field_name, (function(x)return x + the_guy_you_add_idk end), do_this)end;_module_0["field_addition_context"] = field_addition_context

local field_multiplication_context;field_multiplication_context = function(object, field_name, multiplier, do_this)return 
field_operation_context(object, field_name, (function(x)return x * multiplier end), do_this)end;_module_0["field_multiplication_context"] = field_multiplication_context

wrap_method(_G, "get_current_pool", nil, function(self, original_outputs, args)local pool,pool_key = 
unpack(original_outputs)local unavalibilities = 

0
local its_unavaliable;its_unavaliable = function()
unavalibilities = unavalibilities + 1;return 
"UNAVAILABLE"end;if 
G.hhj_pool_filter then local _accum_0 = 
{  }local _len_0 = 1;for _index_0 = 1, #pool do local item = pool[_index_0]_accum_0[_len_0] = (item ~= "UNAVAILABLE" and G.hhj_pool_filter(G.P_CENTERS[item])) and item or its_unavaliable()_len_0 = _len_0 + 1 end;pool = _accum_0 end;if 













unavalibilities >= #pool then if 
hhj_pool_fallback then return 
hhj_pool_fallback end
error("The filter resulted in no valid centers, and a fallback wasn't provided :(")end;return 

pool, pool_key end)





local create_card_filtered;create_card_filtered = function(kwargs)if kwargs == nil then kwargs = {  }end;return 
field_replace_context(G, "hhj_pool_filter", kwargs.filter, function()return 
field_replace_context(G, "hhj_pool_fallback", kwargs.fallback, function()return 
SMODS.create_card(kwargs)end)end)end






























_module_0["create_card_filtered"] = create_card_filtered;return _module_0;