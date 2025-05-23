local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()local useful_things = 
assert(SMODS.load_file("useful_things.lua"))()local _obj_0 = 

G.steamodded_tests.tests

_obj_0[#_obj_0 + 1] = testing.TestBundle("useful_things", { 
testing.Test("wrap_method", { function()local buildup = 
{  }local obj = { fun = function()


buildup[#buildup + 1] = "middle"end }

useful_things.wrap_method(obj, "fun", (function()buildup[#buildup + 1] = "before"end), (function()buildup[#buildup + 1] = "after"end))
obj.fun()return 
testing.assert_eq(table.concat(buildup, "_"), "before_middle_after")end }), 



testing.Test("lerp", { function()
testing.assert_eq(useful_things.lerp(0, 1, 0), 0)
testing.assert_eq(useful_things.lerp(0, 1, 1), 1)
testing.assert_eq(useful_things.lerp(0, 8, 1), 8)
testing.assert_eq(useful_things.lerp(0, 8, 0.5), 4)return 
testing.assert_eq(useful_things.lerp(4, 8, 0.5), 6)end }), 



testing.Test("normalize", { function()
testing.assert_eq(useful_things.normalize(0, 0, 1), 0)
testing.assert_eq(useful_things.normalize(0, 1, 1), 1)
testing.assert_eq(useful_things.normalize(0, 0.5, 1), 0.5)
testing.assert_eq(useful_things.normalize(0, 2, 4), 0.5)
testing.assert_eq(useful_things.normalize(1, 3, 5), 0.5)
testing.assert_eq(useful_things.normalize(1, 1, 5), 0)return 
testing.assert_eq(useful_things.normalize(1, 5, 5), 1)end }), 



testing.Test("field_replace_context", { function()local object = { 
"a" }
testing.assert_eq(object[1], "a")
useful_things.field_replace_context(object, 1, "b", function()return 
testing.assert_eq(object[1], "b")end)return 

testing.assert_eq(object[1], "a")end }), 



testing.Test("field_replace_context_with_error", { function()local object = { 
"a" }
testing.assert_eq(object[1], "a")local original_error_message = 
":)"local response,error_message = 
pcall(function()return 
useful_things.field_replace_context(object, 1, "b", function()
testing.assert_eq(object[1], "b")return 
error(original_error_message)end)end)


testing.assert_eq(response, false)
assert(error_message:endswith(original_error_message))return 
testing.assert_eq(object[1], "a")end }), 



testing.Test("multi_field_replace_context", { function()local object = { 
"a", "b", "c" }
testing.assert_eq(object[1], "a")
testing.assert_eq(object[2], "b")
testing.assert_eq(object[3], "c")

useful_things.multi_field_replace_context({ { object, 1, "d" }, { 
object, 2, "e" }, { 
object, 3, "f" } }, function()

testing.assert_eq(object[1], "d")
testing.assert_eq(object[2], "e")return 
testing.assert_eq(object[3], "f")end)

testing.assert_eq(object[1], "a")
testing.assert_eq(object[2], "b")return 
testing.assert_eq(object[3], "c")end }), 



testing.Test("judgement_after_filtering", (function()local _tab_0 = {  }local _obj_1 = testing.create_state_steps()local _idx_0 = 1;for _key_0, _value_0 in pairs(_obj_1) do if _idx_0 == _key_0 then _tab_0[#_tab_0 + 1] = _value_0;_idx_0 = _idx_0 + 1 else _tab_0[_key_0] = _value_0 end end
_tab_0[#_tab_0 + 1] = function()local judgement = 
SMODS.create_card({ set = "Tarot", key = "c_judgement" })
judgement:use_consumeable(judgement.area)return 
true end;return _tab_0 end)()) })