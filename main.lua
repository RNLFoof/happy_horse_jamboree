assert(SMODS.load_file("libs\\string_util.lua"))()
package.path = 'Mods\\balatro-unknown-mod\\libs\\LuaNES\\?.lua;' .. package.path;return 

assert(SMODS.load_file("libs\\LuaNES\\main.lua"))()