local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()local useful_things = 
assert(SMODS.load_file("useful_things.lua"))()local _obj_0 = 

G.steamodded_tests.tests

_obj_0[#_obj_0 + 1] = testing.TestBundle("misc", { 
testing.Test("wrap_method", { function()local buildup = 
{  }local obj = { fun = function()


buildup[#buildup + 1] = "middle"end }

useful_things.wrap_method(obj, "fun", (function()buildup[#buildup + 1] = "before"end), (function()buildup[#buildup + 1] = "after"end))
obj.fun()return 
testing.assert_eq(table.concat(buildup, "_"), "before_middle_after")end }) })