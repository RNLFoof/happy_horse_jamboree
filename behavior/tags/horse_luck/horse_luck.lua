return SMODS.Tag({
	key = "horse_luck",
	loc_txt = {
		name = "HORSE LUCK TAG",
		text = {
			"Shop has a {C:attention}horse{} :)"
		}
	},
	atlas = "hhj_atlas_tags",
	pos = atlas_tags_positions["horse_luck"],
	no_collection = true,
	in_pool = function(self, args)
		return false
	end
})
