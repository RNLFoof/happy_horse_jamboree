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
testing.assert_eq(useful_things.normalize(1, 5, 5), 1)end }) })