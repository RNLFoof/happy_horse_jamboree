assert(SMODS.load_file('atlases.lua'))()
assert(atlas_decks)

mig_psychostasia_atlas = atlas_decks
print(atlas_decks)

mig_psychostasia = SMODS.Back{
    name = "Psychostasia Deck",
    key = "mig_psychostasia",
    atlas = "atlas_decks",
    pos = atlas_decks_positions["Psychostasia Deck"],
    config = {mig_psychostasia = true, joker_slot = 5},
    loc_txt = {
        name = "Psychostasia Deck",
        text ={
            "{C:attention}+5{} Joker slots",
            "{C:green}Uncommon{}, {C:red}Rare{}, and {C:purple}Legendary{} Jokers",
            "cost {C:green}2{}, {C:red}3{}, and {C:purple}4{} Joker slots",
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

function overburdened()
    return psychostasia_enabled() and #G.jokers.cards > G.jokers.config.card_limit
end

function big_guy(card)
    return psychostasia_enabled() and card.config.center.rarity and card.config.center.rarity >= 3
end

function force_notch_bar_update(cardArea)
    if cardArea == G.jokers and G.jokers.children.area_uibox then
        G.jokers.children.area_uibox.definition.nodes[2].nodes[6] = nil
    end
end

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
    ref(self)
    
    force_notch_bar_update(self)
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

    ref(self)
    force_notch_bar_update(self)
end

-- CardArea

local ref = CardArea.draw
function CardArea:draw()
    local notch_side = 0.25
    local notch_padding = 0.025 / 2 -- I wonder if this could be made to be one pixel regardless of screen size?
    local notch_emboss=0.1
    local notch_inactive_emboss_ratio=0.5
    local notch_r = 0.05
    local danger_color = G.C.MIG_OVERBURDENED

    if      self.children
        and self.children.area_uibox
        and self.children.area_uibox.definition.nodes 
        and self.children.area_uibox.definition.nodes[2]
        and self.children.area_uibox.definition.nodes[2].nodes
        -- and self.children.area_uibox.children[2]
        -- and self.children.area_uibox.children[2].children
    then
        it_goes_in_here = self.children.area_uibox.definition.nodes[2] --[2].children
        it = it_goes_in_here.nodes[6]
    end

    if self == G.jokers and it_goes_in_here and self.children.area_uibox then -- I have NO clue how it_goes_in_here can be set without self.children.area_uibox but here we are
        if not it then
            the_actual_bar = {}
            -- the_actual_bar[#the_actual_bar+1] = {
            --         n=G.UIT.B,
            --         config={align="cm", w=notch_padding, h=notch_padding}
            -- }

            effective_card_limit =get_effective_card_limit()
            print(effective_card_limit)

            -- Filled notches
            filled_notch_count = 0
            for _, card in ipairs(self.cards) do
                for _=1, card.config.center.rarity do
                    the_actual_bar[#the_actual_bar+1] = {
                        n=G.UIT.C, config={minh=notch_side+notch_padding}, nodes={{ -- Needs to be a row in a column because uuhhhhh bad
                            n=G.UIT.R,
                            config={
                                align="cm",
                                minw=(
                                    notch_side*card.config.center.rarity
                                    + notch_padding*(card.config.center.rarity-1)
                                ) / card.config.center.rarity, 
                                minh=notch_side,
                                colour = filled_notch_count<effective_card_limit and G.C.RARITY[card.config.center.rarity] or danger_color, 
                                emboss=notch_emboss, 
                                r=notch_r
                            }
                        }}
                    }
                    filled_notch_count = filled_notch_count + 1
                end
                the_actual_bar[#the_actual_bar+1] = {
                        n=G.UIT.B,
                        config={w=notch_padding, h=notch_padding}
                }
                --if #the_actual_bar >= 2 then break end
            end

            -- Empty notches
            for _=#self.cards+1, self.config.card_limit do
                the_actual_bar[#the_actual_bar+1] = {
                    n=G.UIT.C, config={minh=notch_side+notch_padding, mninw=notch_side+notch_emboss}, nodes={
                        --OH MY GOD WHY IS BALATRO'S UI SO BUGGY
                        -- WHY IS THIS SHIT NECESSARY
                        -- (without the extra layers, the alignment doesn't work)
                        {n=G.UIT.R, nodes={{n=G.UIT.C, config={minw=notch_side, minh=notch_side+notch_emboss, align="bm"},nodes={

                            -- {
                            --         n=G.UIT.R,
                            --         config={minw=notch_side, minh=notch_emboss*(1-notch_inactive_emboss_ratio), colour=G.C.CLEAR}
                            -- },
                            { -- Needs to be a row in a column because uuhhhhh bad
                                n=G.UIT.R,
                                config={
                                    minw=notch_side,
                                    minh=notch_side+notch_padding,
                                    colour = G.C.UI.BACKGROUND_INACTIVE, 
                                    emboss=notch_emboss*notch_inactive_emboss_ratio, 
                                    r=1,
                                    --offset={x=0, y=1}
                                }
                            },
                        }}}}
                    }
                }
                the_actual_bar[#the_actual_bar+1] = {
                        n=G.UIT.B,
                        config={w=notch_padding, h=notch_padding}
                }
            end

            -- Overburdened warning
            if overburdened() then
                the_actual_bar[#the_actual_bar+1] = {n=G.UIT.B, config={w = 0.1/2,h=0.1}}
                the_actual_bar[#the_actual_bar+1] = {n=G.UIT.T, config={text="Overburdened! Jokers won't activate!", scale = 0.3, colour = danger_color}}
            end
            
            it_goes_in_here.nodes[6] = {n=G.UIT.C, config = {colour=G.C.CLEAR}, nodes={{
                    n=G.UIT.R, config = {colour = G.C.CLEAR, minw=notch_side*1+notch_padding*9, minh=notch_side+notch_padding, align="cm"},
                    nodes=the_actual_bar
                }}}
            self.children.area_uibox = UIBox{definition=self.children.area_uibox.definition, config=self.children.area_uibox.config}
        end
        -- it_goes_in_here.mig_psychostasia_bar:draw()
    end
    ref(self)
end

-- local ref = CardArea.update
-- function CardArea:update(dt)
--     ref(self, dt)
--     force_notch_bar_update(self)
-- end

function get_effective_card_count()
    effective_card_count = 0
    for _, card in ipairs(G.jokers.cards) do
        effective_card_count = effective_card_count + card.config.center.rarity
    end
    return effective_card_count
end

function get_effective_card_limit()
    return get_effective_card_count() + (G.jokers.config.card_limit-#G.jokers.cards) 
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
        ecc = get_effective_card_count()
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

        -- Sorting is what lets you change the positions of the cards
        table.sort(self.cards, function (a, b) return a.T.x + a.T.w/2 < b.T.x + b.T.w/2 end)
        positions = ""
        for _,card in ipairs(self.cards) do positions = positions .. (card.ability and card.ability.name or 'idk') end
        if positions ~= self.mig_previousJokerPositions then
            print(positions)
            force_notch_bar_update(G.jokers)
        end
        self.mig_previousJokerPositions = positions
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



local ref = Card.calculate_joker
function Card:calculate_joker(context)
    output = ref(self, context)

    -- Shows the overburdened text, but only if the joker would have displayed/done something anyway
    if self.ability.set == "Joker" and overburdened() then 
        if output then
            -- Based on the debuff behavior in card_eval_status_text in common_events
            G.E_MANAGER:add_event(
                Event({
                    trigger = 'before', 
                    delay = 0.4,
                    --blocking = true,
                    func = function()
                        attention_text({
                            text = "Overburdened!",
                            scale = 0.6,
                            hold = 0.65 - 0.2,
                            backdrop_colour = G.C.MIG_OVERBURDENED,
                            align = "bm",
                            major = self,
                            offset = {x = 0, y = 0.05*self.T.h}
                        })
                        play_sound("cancel", 0.8+1*0.2, 1)
                        self:juice_up(0.6, 0.1)
                        G.ROOM.jiggle = G.ROOM.jiggle + 0.7
                        return true
                    end
                })
            )
        end
        return nil
    end
    return output
end


local ref = Game.update
function Game:update(dt)
    ref(self, dt)
    if not G.C.MIG_OVERBURDENED then
        self.C.MIG_OVERBURDENED = {1,1,1,1}
    end
        dif = 1/8
        G.C.MIG_OVERBURDENED[1] = (1-dif)+dif*(1+math.sin(self.TIMERS.REAL*3))
        G.C.MIG_OVERBURDENED[2] = (1-3*dif)+dif*(1+math.sin(self.TIMERS.REAL*4.5))
        G.C.MIG_OVERBURDENED[3] = (1-5*dif)
end