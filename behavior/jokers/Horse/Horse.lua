local horse_names = {
	"Chestnut",
	"Peanut",
	"Acorn",
	"Gertrude"
}
local bonus_types = {
	"chips",
	"mult",
	"money"
}
local round
round = function(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end
local index = 0
for bonus_1_index, bonus_1 in ipairs(bonus_types) do
	for bonus_2_index, bonus_2 in ipairs((function()
		local _accum_0 = { }
		local _len_0 = 1
		for _index_0 = bonus_1_index, #bonus_types do
			local _ = bonus_types[_index_0]
			_accum_0[_len_0] = _
			_len_0 = _len_0 + 1
		end
		return _accum_0
	end)()) do
		for _, bonus_3 in ipairs((function()
			local _accum_0 = { }
			local _len_0 = 1
			for _index_0 = bonus_2_index, #bonus_types do
				local _ = bonus_types[_index_0]
				_accum_0[_len_0] = _
				_len_0 = _len_0 + 1
			end
			return _accum_0
		end)()) do
			index = index + 1
			local bonuses_as_list = {
				bonus_1,
				bonus_2,
				bonus_3
			}
			local bonuses_for_this_horse = {
				chips = round(8 / 1 * #(function()
					local _accum_0 = { }
					local _len_0 = 1
					for _index_0 = 1, #bonuses_as_list do
						local bonus = bonuses_as_list[_index_0]
						if bonus == "chips" then
							_accum_0[_len_0] = bonus
							_len_0 = _len_0 + 1
						end
					end
					return _accum_0
				end)()),
				mult = round(10 / 6 * #(function()
					local _accum_0 = { }
					local _len_0 = 1
					for _index_0 = 1, #bonuses_as_list do
						local bonus = bonuses_as_list[_index_0]
						if bonus == "mult" then
							_accum_0[_len_0] = bonus
							_len_0 = _len_0 + 1
						end
					end
					return _accum_0
				end)()),
				money = round(1 / 1 * #(function()
					local _accum_0 = { }
					local _len_0 = 1
					for _index_0 = 1, #bonuses_as_list do
						local bonus = bonuses_as_list[_index_0]
						if bonus == "money" then
							_accum_0[_len_0] = bonus
							_len_0 = _len_0 + 1
						end
					end
					return _accum_0
				end)())
			}
			local horse_ability_description = { }
			if bonuses_for_this_horse.chips > 0 then
				horse_ability_description[#horse_ability_description + 1] = "{C:chips}+" .. tostring(bonuses_for_this_horse.chips) .. "{} chips"
			end
			if bonuses_for_this_horse.mult > 0 then
				horse_ability_description[#horse_ability_description + 1] = "{C:mult,}+" .. tostring(bonuses_for_this_horse.mult) .. "{} Mult"
			end
			if bonuses_for_this_horse.money > 0 then
				horse_ability_description[#horse_ability_description + 1] = "{C:money}+$" .. tostring(bonuses_for_this_horse.money) .. "{} per round"
			end
			local _list_0 = {
				"Additional {C:attention}Horses{} may appear, are {C:dark_edition}negative{},",
				"and have varied abilities"
			}
			for _index_0 = 1, #_list_0 do
				local line = _list_0[_index_0]
				horse_ability_description[#horse_ability_description + 1] = line
			end
			local horse_name = "A HORSE (" .. tostring(index) .. ")"
			print("Added horse", index, bonus_types)
			local horse_joker = SMODS.Joker({
				key = "mig_horse_" .. index,
				atlas = "atlas_jokers",
				pos = atlas_decks_positions["Horse"],
				rarity = 1,
				cost = 1,
				loc_txt = {
					name = horse_name,
					text = horse_ability_description
				},
				discovered = true,
				in_pool = function(self, args)
					return true, {
						allow_duplicates = true
					}
				end
			})
		end
	end
end
