local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()local ui = 
assert(SMODS.load_file("behavior/functions/ui.lua"))()local Test = 

testing.Test;local TestBundle = 
testing.TestBundle;local assert_eq = 
testing.assert_eq;local assert_ne = 
testing.assert_ne;local assert_valid_ui = 
testing.assert_valid_ui;local _obj_0 = 

G.steamodded_tests.tests
_obj_0[#_obj_0 + 1] = TestBundle("ui", { 
Test("_optional_config_wrapper", { function()
assert_eq(ui._optional_config_wrapper({  }), { {  }, {  } })
assert_eq(ui._optional_config_wrapper({  }, {  }), { {  }, {  } })
assert_eq(ui._optional_config_wrapper({ "burp" }), { {  }, { "burp" } })
assert_eq(ui._optional_config_wrapper("burp"), { {  }, "burp" })return 
assert_eq(ui._optional_config_wrapper({ "okay" }, { "burp" }), { { "okay" }, { "burp" } })end }), 


TestBundle("column", { 
Test("runs_without_erroring", { function()
assert_valid_ui(ui.column())
assert_valid_ui(ui.column({  }))
assert_valid_ui(ui.column(ui.text("lol")))
assert_valid_ui(ui.column({ ui.text("lol") }))return 
true end }) }), 


Test("hhj_badge", { function()return assert_ne(ui.hhj_badge(), nil)end }) })