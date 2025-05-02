return 
SMODS.PokerHand({ key = 'low_card', chips = 
0, mult = 
0, l_chips = 
100, l_mult = 
10, order_offset = 
6, visible = 
false, example = { { 

'S_2', true } }, loc_txt = { [



'en-us'] = { name = 'Low Card', description = { 

"Exactly one 2" } } }, evaluate = function(parts, hand)if #


hand > 1 then return 
{  }end;if #
SMODS.find_card("j_hhj_new_low", false) == 0 then return 
{  }end;for _, card in 
ipairs(hand) do if 
card:get_id() ~= 2 then return 
{  }end end;return 
hand end })
