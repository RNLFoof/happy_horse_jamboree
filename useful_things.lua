local _module_0 = {  }local wrap_method;wrap_method = function(class_, method_name, before, after)if before == nil then before = (function()return nil end)end;if after == nil then after = (function()return nil end)end;local ref = 
class_[method_name]
class_[method_name] = function(...)
before(...)
ref(...)return 
after(...)end end;_module_0["wrap_method"] = wrap_method

local round;round = function(num, numDecimalPlaces)local mult = 
10 ^ (numDecimalPlaces or 0)return 
math.floor(num * mult + 0.5) / mult end;_module_0["round"] = round;return _module_0;