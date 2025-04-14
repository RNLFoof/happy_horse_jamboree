local haumea = 
SMODS.Consumable({ key = "mig_haumea", set = 
"Planet", atlas = 
"atlas_planets", pos = 
atlas_planets_positions["Haumea"], loc_txt = { name = 

"Haumea" }, generate_ui = 










0, process_loc_text = function(self)local target_text = 


G.localization.descriptions[self.set]['c_mercury'].text
SMODS.Consumable.process_loc_text(self)
G.localization.descriptions[self.set][self.key].text = target_text end, set_card_type_badge = function(self, card, badges)

badges[1] = create_badge(localize('k_dwarf_planet'), get_type_colour(self or card.config, card), nil, 1.2)end, config = { hand_type = 

'mig_low_card', softlock = 
true } })