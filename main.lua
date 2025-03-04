mig_psychostasia_atlas = SMODS.Atlas {
    key = "mig_psychostasia_atlas",
    path = "psychostasia_deck.png",
    px = 71,
    py = 95,
}

mig_psychostasia = SMODS.Back{
    name = "Psychostasia Deck",
    key = "mig_psychostasia",
    atlas = "mig_psychostasia_atlas",
    pos = {x = 0, y = 0},
    config = {mig_psychostasia = true, joker_slot = 5},
    loc_txt = {
        name = "Psychostasia Deck",
        text ={
            "{C:attention}+5{} Joker slots",
            "{C:green}Uncommon{}, {C:red}Rare{}, and {C:purple}Legendary{} Jokers",
            "cost {C:green}2{}, {C:red}3{}, and {C:purple}4{} Joker slots"
        },
    },

    loc_vars = function(self) 
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
    end,

    -- calculate = function(self, card, context)
    --     if then
    --         G.GAME.blind:debuff_card(card)
    --     end
    -- end,
}

function psychostasia_enabled()
    return G.GAME.starting_params.mig_psychostasia
end

function big_guy(card)
    return psychostasia_enabled() and card.config.center.rarity and card.config.center.rarity >= 3
end

-- debuffed_hand 

-- alert_no_space but with a different message. that's it 
function alert_too_heavy(card, area)
    G.CONTROLLER.locks.no_space = true
    attention_text({
        scale = 0.9, text = "Too heavy!", hold = 0.9, align = 'cm',
        cover = area, cover_padding = 0.1, cover_colour = adjust_alpha(G.C.BLACK, 0.7)
    })
    card:juice_up(0.3, 0.2)
    for i = 1, #area.cards do
      area.cards[i]:juice_up(0.15)
    end
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
      play_sound('tarot2', 0.76, 0.4);return true end}))
      play_sound('tarot2', 1, 0.4)
  
      G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.5*G.SETTINGS.GAMESPEED, blockable = false, blocking = false,
      func = function()
        G.CONTROLLER.locks.no_space = nil
      return true end}))
  end

local ref = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
    if G.GAME.starting_params.mig_psychostasia and card.ability.set == 'Joker' and #G.jokers.cards + card.config.center.rarity > G.jokers.config.card_limit then 
        alert_too_heavy(card, G.jokers)
        return false
    end
    return ref(card)
end

local ref = Card.init
function Card:init(X, Y, W, H, card, center, params) 
    output = ref(self, X, Y, W, H, card, center, params)

    -- This seems to trigger before the deck is known when loading. Doing it as an event makes it trigger afterwards.
    G.E_MANAGER:add_event(Event({
        func = function()
            if G.GAME.starting_params.mig_psychostasia then
                if self.ability and self.ability.set == 'Joker' then
                    new_scale = self.config.center.rarity * 0.5
                    if not big_guy(self) then
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
    if psychostasia_enabled() then

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

    if not psychostasia_enabled() then
        return
    end
    assert(G.GAME.starting_params.mig_psychostasia)
    
    -- Aligns jokers while taking their size into account. Based on the actual joker alignment code
    -- Checks for rarity because the consumable area is also type joker 
    if self.config.type == 'joker' and #self.cards > 0 and self.cards[1].config.center.rarity then
        psychostasia_k = 0
        effective_card_count = 0
        for _, card in ipairs(self.cards) do
            card.VT.r = card.VT.r + math.pi / 2
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
    
    -- Make the big guys turn sideways
    for k, card in ipairs(self.cards) do
        -- It's a little scuffed, but it assumes that, if the card is roughly straight up (within an 8th of a rotation), then it needs to be sideways instead
        -- This means the rest of the code can do whatever to it and it'll be accounted for
        -- at the cost of this obviously being jank as hell 
        if big_guy(card) and (math.modf(math.abs(card.T.r), math.pi * 2) < math.pi/4 ) then
            card.T.r = card.T.r + math.pi / 2
            card.VT.r = card.T.r
        end
    end
end   