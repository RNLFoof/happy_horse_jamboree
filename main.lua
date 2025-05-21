assert(SMODS.load_file("libs\\string_util.lua"))()
assert(SMODS.load_file("atlases.lua"))()
package.path = 'Mods\\balatro-unknown-mod\\libs\\LuaNES\\?.lua;' .. package.path


SMODS.Atlas({ key = "modicon", path = 
"modicon.png", px = 
32, py = 
32 })local extra_glyphs_font = 

love.graphics.newFont("Mods/" .. SMODS.current_mod.path:gsub("^.+Mods", "") .. "assets/glyphs/m6x11plus_extra_glyphs.ttf", G.TILESIZE * 10)local _list_0 = 
G.FONTS;for _index_0 = 1, #_list_0 do local font = _list_0[_index_0]
font.FONT:setFallbacks(extra_glyphs_font)end;local _list_1 = 
G.LANGUAGES;for _index_0 = 1, #_list_1 do local language = _list_1[_index_0]
language.font:setFallbacks(extra_glyphs_font)end

local load_all_files_in;load_all_files_in = function(directory)
directory = directory;local files = 
NFS.getDirectoryItems(SMODS.current_mod.path .. directory)for k, file in 
ipairs(files) do local fullPath = 
directory .. "/" .. file;if 
file:endswith(".lua") then
assert(SMODS.load_file(fullPath))()else

load_all_files_in(fullPath)end end end;return 

load_all_files_in("behavior")