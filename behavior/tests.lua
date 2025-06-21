local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()local useful_things = 
assert(SMODS.load_file("useful_things.lua"))()
assert(SMODS.load_file("libs\\steamodded_test\\test_main.lua"))()local TestBundle = 

testing.TestBundle;local Test = 
testing.Test;local _obj_0 = 

G.steamodded_tests.tests
_obj_0[#_obj_0 + 1] = TestBundle("useful_things", { 
Test("filter", { function()return 

testing.assert_eq(useful_things.filter({ 1, 2, 3, 4, 5 }, (function(item)return 
item >= 3 end)), { 

3, 4, 5 })end }), 



Test("length", { function()return testing.assert_eq(useful_things.length({ 1, 2, 3, 4, 5 }), 5)end }), 


Test("count", { function()return testing.assert_eq(useful_things.count({ 1, 2, 2, 3, 3, 3 }, 3), 3)end }), 


Test("unique_entries", { function()return testing.assert_eq(useful_things.unique_entries({ 1, 2, 2, 3, 3, 3 }), { 1, 2, 3 })end }), 


Test("same_contents", { function()return assert(useful_things.same_contents({ 1, 2, 3 }, { 3, 2, 1 }))end }), 


TestBundle("wrap_method", { 
TestBundle("manual_calling", { 
Test("basic", { function()local buildup = 
{  }local obj = { fun = function(self, n)


buildup[#buildup + 1] = tostring(n)end }

useful_things.wrap_method_with_manual_calling(obj, "fun", function(original_method, args)return 
original_method(unpack(args))end)

obj:fun(2)return 
testing.assert_eq(table.concat(buildup, "_"), "2")end }), 


Test("nil_in_middle", { function()local buildup = 
{  }local obj = { fun = function(self, ...)local args = 


useful_things.pack(...)for i = 
1, args.n do
buildup[#buildup + 1] = tostring(args[i])end end }

useful_things.wrap_method_with_manual_calling(obj, "fun", function(original_method, args)return 
original_method(useful_things.nilproof_unpack(args))end)




















obj:fun(1, 2, nil, 4)return 
testing.assert_eq(table.concat(buildup, "_"), "1_2_nil_4")end }) }), 


Test("argless", { function()local buildup = 
{  }local obj = { fun = function()


buildup[#buildup + 1] = "middle"end }

useful_things.wrap_method(obj, "fun", (function()buildup[#buildup + 1] = "before"end), (function()buildup[#buildup + 1] = "after"end))
obj.fun()return 
testing.assert_eq(table.concat(buildup, "_"), "before_middle_after")end }), 


Test("with_args", { function()local buildup = 
{  }local obj = { fun = function(self, nn)


buildup[#buildup + 1] = tostring(nn * 2)end }

useful_things.wrap_method(obj, "fun", (function(self, n)buildup[#buildup + 1] = tostring(n * 1)end), (function(self, original_output, nnn)buildup[#buildup + 1] = tostring(nnn * 3)end))
obj:fun(2)return 
testing.assert_eq(table.concat(buildup, "_"), "2_4_6")end }), 


Test("nil_in_middle", { function()local buildup = 
{  }local obj = { fun = function(self, ...)local args = { 


... }for i = 
1, 4 do
buildup[#buildup + 1] = tostring(args[i])end end }

useful_things.wrap_method(obj, "fun")
obj:fun(1, 2, nil, 4)return 
testing.assert_eq(table.concat(buildup, "_"), "1_2_nil_4")end }) }), 


TestBundle("flatten", { 
Test("strings", { function()
testing.assert_eq(table.concat({ "a", "b" }), "ab")
testing.assert_eq(table.concat(useful_things.flatten({ "a", "b" })), "ab")
testing.assert_eq(table.concat(useful_things.flatten({ "a", { "b" } })), "ab")
testing.assert_eq(table.concat(useful_things.flatten({ "a", { "b", "c" } })), "abc")return 
testing.assert_eq(table.concat(useful_things.flatten({ "a", { "b", { "c" } } })), "abc")end }), 


Test("dicts", { function()local test_on = 
useful_things.flatten({ "a", { ["b"] = "c" } })
testing.assert_eq(test_on[1], "a")return 
testing.assert_eq(test_on[2]["b"], "c")end }) }), 


Test("table_is_list", { function()
assert(useful_things.table_is_list({ "q", "w", "e" }))return 
assert(not useful_things.table_is_list({ ["q"] = "q", ["w"] = "w", ["e"] = "e" }))end }), 


Test("lerp", { function()
testing.assert_eq(useful_things.lerp(0, 1, 0), 0)
testing.assert_eq(useful_things.lerp(0, 1, 1), 1)
testing.assert_eq(useful_things.lerp(0, 8, 1), 8)
testing.assert_eq(useful_things.lerp(0, 8, 0.5), 4)return 
testing.assert_eq(useful_things.lerp(4, 8, 0.5), 6)end }), 


Test("normalize", { function()
testing.assert_eq(useful_things.normalize(0, 0, 1), 0)
testing.assert_eq(useful_things.normalize(0, 1, 1), 1)
testing.assert_eq(useful_things.normalize(0, 0.5, 1), 0.5)
testing.assert_eq(useful_things.normalize(0, 2, 4), 0.5)
testing.assert_eq(useful_things.normalize(1, 3, 5), 0.5)
testing.assert_eq(useful_things.normalize(1, 1, 5), 0)return 
testing.assert_eq(useful_things.normalize(1, 5, 5), 1)end }), 


Test("field_replace_context", { function()local object = { 
"a" }
testing.assert_eq(object[1], "a")
useful_things.field_replace_context(object, 1, "b", function()return 
testing.assert_eq(object[1], "b")end)return 

testing.assert_eq(object[1], "a")end }), 


Test("field_replace_context_with_error", { function()local object = { 
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


Test("multi_field_replace_context", { function()local object = { 
"a", "b", "c" }
testing.assert_eq(object[1], "a")
testing.assert_eq(object[2], "b")
testing.assert_eq(object[3], "c")local got_in = 
false

useful_things.multi_field_replace_context({ { object, 1, "d" }, { 
object, 2, "e" }, { 
object, 3, "f" } }, function()

got_in = true
testing.assert_eq(object[1], "d")
testing.assert_eq(object[2], "e")return 
testing.assert_eq(object[3], "f")end)

testing.assert_eq(object[1], "a")
testing.assert_eq(object[2], "b")
testing.assert_eq(object[3], "c")return 
assert(got_in)end }), 


Test("judgement_after_filtering", { testing.create_state_steps(), function()local judgement = 

SMODS.create_card({ set = "Tarot", key = "c_judgement" })
judgement:use_consumeable(judgement.area)return 
true end }) })