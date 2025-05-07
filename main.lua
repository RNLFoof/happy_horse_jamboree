assert(SMODS.load_file("libs\\string_util.lua"))()
package.path = 'Mods\\balatro-unknown-mod\\libs\\LuaNES\\?.lua;' .. package.path







SMODS.Atlas({ key = "modicon", path = 
"modicon.png", px = 
32, py = 
32 })

local load_all_files_in;load_all_files_in = function(directory)
directory = directory;local files = 
NFS.getDirectoryItems(SMODS.current_mod.path .. directory)for k, file in 
ipairs(files) do local fullPath = 
directory .. "/" .. file;if 
file:endswith(".lua") then
assert(SMODS.load_file(fullPath))()else

load_all_files_in(fullPath)end end end;return 

load_all_files_in("behavior")