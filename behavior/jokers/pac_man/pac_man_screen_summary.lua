return 
SMODS.Shader({ key = "pac_man_screen_summary", path = 
"pac_man_screen_summary.fs", send_vars = function(sprite, card)return { gameplay = 


card.doesnt_save.nes.image, gameplay_dims = { 
card.doesnt_save.nes.image:getDimensions() } }end })
