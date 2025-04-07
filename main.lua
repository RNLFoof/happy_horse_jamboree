assert(SMODS.load_file("libs\\string_util.lua"))()

local load_all_files_in;load_all_files_in = function(directory)
directory = directory;local files = 
NFS.getDirectoryItems(SMODS.current_mod.path .. directory)
print(NFS)
print("Loading all files in ", directory)for k, file in 
ipairs(files) do
print("File: ", file)local fullPath = 
directory .. "/" .. file;if 
file:endswith(".lua") then
assert(SMODS.load_file(fullPath))()
print("Loading ", file)else

load_all_files_in(fullPath)end end end;return 

load_all_files_in("behavior")