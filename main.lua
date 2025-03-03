SMODS.Back{
    name = "Psychostasia Deck",
    key = "mig_psychostasia",
    pos = {x = 0, y = 3},
    config = {mig_psychostasia = true, joker_slot = 5},
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
                G.GAME.starting_params.mig_psychostasia = true
                return true
            end
        }))
    end
}

local ref = Card.init
function Card:init(X, Y, W, H, card, center, params) 
    output = ref(self, X, Y, W, H, card, center, params)

    -- This seems to trigger before the deck is known when loading. Doing it as an event makes it trigger afterwards.
    G.E_MANAGER:add_event(Event({
        func = function()
            if G.GAME.starting_params.mig_psychostasia then
                if self.ability and self.ability.set == 'Joker' then
                    self.T.w = self.T.w * 0.5 * (self.config.center.rarity)
                end
            end
            return true
        end
    }))
    return output
end

local ref = Card.add_to_deck
function Card:add_to_deck() 
    if G.GAME.starting_params.mig_psychostasia then
        if not self.added_to_deck then
            if self.ability and self.ability.set == 'Joker' then
                if not G.OVERLAY_MENU then
                    G.jokers.config.card_limit = G.jokers.config.card_limit - (self.config.center.rarity - 1)
                end
            end
        end
    end
    return ref(self)
end

local ref = Card.remove_from_deck
function Card:remove_from_deck() 
    if G.GAME.starting_params.mig_psychostasia then

        if self.added_to_deck then
            if self.ability and self.ability.set == 'Joker' then
                if not G.OVERLAY_MENU then
                    G.jokers.config.card_limit = G.jokers.config.card_limit + (self.config.center.rarity - 1)
                end
            end
        end
    end

    return ref(self)
end