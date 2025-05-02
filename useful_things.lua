local _module_0 = { }
local wrap_method
wrap_method = function(class_, method_name, before, after)
	if before == nil then
		before = (function()
			return nil
		end)
	end
	if after == nil then
		after = (function()
			return nil
		end)
	end
	local ref = class_[method_name]
	class_[method_name] = function(...)
		before(...)
		ref(...)
		return after(...)
	end
end
_module_0["wrap_method"] = wrap_method
local round
round = function(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end
_module_0["round"] = round
local lerp
lerp = function(some_value, some_other_value, how_far)
	return some_value + (some_other_value - some_value) * how_far
end
_module_0["lerp"] = lerp
local random_float
random_float = function(min, max)
	assert(min <= max)
	return lerp(min, max, math.random())
end
_module_0["random_float"] = random_float
local normalize
normalize = function(min, mid, max)
	assert(min <= mid and mid <= max)
	local delta = max - min
	local adjusted_mid = mid - min
	return adjusted_mid / delta
end
_module_0["normalize"] = normalize
return _module_0
