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
                    new_scale = self.config.center.rarity * 0.5
                    if self.config.center.rarity <= 2 then
                        self.T.w = self.T.w * new_scale
                        self.T.h = self.T.h * new_scale
                    else
                        self.T.h = G.CARD_W * new_scale
                        self.T.w = self.T.h * G.CARD_W / G.CARD_H 
                    end
                    self.VT.w = self.T.w
                    self.VT.h = self.T.h
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

local ref = CardArea.align_cards
function CardArea:align_cards()
    ref(self)

    -- Aligns jokers while taking their size into account. Based on the actual joker alignment code 
    if self.config.type == 'joker' and G.GAME.starting_params.mig_psychostasia then
        psychostasia_k = 0
        effective_card_count = 0
        for _, card in ipairs(self.cards) do
            effective_card_count = effective_card_count + card.config.center.rarity
        end
        ecc = effective_card_count
        previous_psychostasia_k = 0 -- Replaces k-1

        for k, card in ipairs(self.cards) do
            psychostasia_k = psychostasia_k + card.config.center.rarity
            -- self.card_width is the actual width that cards have, potentially modified per CardArea. I'm going to just assume it's normal 
            -- This can't be set as just the card's actual width, because of wee joker and maybe others
            width_of_this_card = card.config.center.rarity*0.5*self.card_w --
            if not card.states.drag.is then 
                card.T.r = 0.1*(-ecc/2 - 0.5 + psychostasia_k)/(ecc)+ (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(2*G.TIMERS.REAL+card.T.x)

                if card.config.center.rarity == 3 then
                    card.T.r = card.T.r + math.pi / 2
                end

                if ecc > 2 or (ecc > 1 and self == G.consumeables) or (ecc > 1 and self.config.spread) then
                    card.T.x = 
                        -- The card area's own X
                        self.T.x
                        + (self.T.w-self.card_w*0.5)*(
                            (previous_psychostasia_k)/(ecc-1)
                        )
                        -- Centers the card within the space allocated to it 
                        + 0.5*(width_of_this_card - card.T.w)
                end
                local highlight_height = G.HIGHLIGHT_H/2
                if not card.highlighted then highlight_height = 0 end
                card.T.y = self.T.y + self.T.h/2 - card.T.h/2 - highlight_height+ (G.SETTINGS.reduced_motion and 0 or 1)*0.03*math.sin(0.666*G.TIMERS.REAL+card.T.x)
                card.T.x = card.T.x + card.shadow_parrallax.x/30
            end

            previous_psychostasia_k = psychostasia_k
        end
    end
end   