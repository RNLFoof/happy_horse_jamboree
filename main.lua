SMODS.Back{
    name = "Psychostasia Deck",
    key = "mig_psychostasia",
    pos = {x = 0, y = 3},
    config = {psychostasia = true, joker_slot = 5},
    loc_txt = {
        name = "Psychostasia Deck",
        text ={
            "{C:attention}+5{} Joker slots",
            "{C:green}Uncommon{}, {C:red}Rare{}, and {C:purple}Legendary{} Jokers",
            "cost {C:green}2{}, {C:red}3{}, and {C:purple}4{} Joker slots"
        },
    },
    loc_vars=function(self) 
        return {
            vars={}
        }
    end,
    apply = function()
        
        G.E_MANAGER:add_event(Event({
            func = function()
                -- SMODS.Joker:take_ownership('joker', -- object key (class prefix not required)
                --     { -- table of properties to change from the existing object
                --     cost = 5,
                --     calculate = function(self, card, context)
                --         -- more on this later
                --     end
                --     },
                --     false -- silent | suppresses mod badge
                -- )
                return true
            end
        }))
    end
}

local ref = Card.add_to_deck
function Card:add_to_deck() 
    if not self.added_to_deck then
        if self.ability and self.ability.set == 'Joker' then
            if not G.OVERLAY_MENU then
                G.jokers.config.card_limit = G.jokers.config.card_limit - (self.config.center.rarity - 1)
            end
        end
    end
    return ref(self)
end

local ref = Card.remove_from_deck
function Card:remove_from_deck() 
    if self.added_to_deck then
        if self.ability and self.ability.set == 'Joker' then
            if not G.OVERLAY_MENU then
                G.jokers.config.card_limit = G.jokers.config.card_limit + (self.config.center.rarity - 1)
            end
        end
    end

    return ref(self)
end