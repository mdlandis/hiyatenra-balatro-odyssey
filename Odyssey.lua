
SMODS.Atlas 
{
  key = "Odyssey",
  path = "Odyssey.png",
  px = 71,
  py = 95
}

local init_game_object_ref = Game.init_game_object
function Game:init_game_object()
  local init_game_object_val = init_game_object_ref(self)

  init_game_object_val.OdysseyVars = 
  {
  }
  return init_game_object_val
end

--take ownership of spectrals to properly return created cards
local function random_destroy(used_tarot)
  local destroyed_cards = {}
  destroyed_cards[#destroyed_cards + 1] = pseudorandom_element(G.hand.cards, pseudoseed('random_destroy'))
  G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
          play_sound('tarot1')
          used_tarot:juice_up(0.3, 0.5)
          return true
      end
  }))
  G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.1,
      func = function()
          for i = #destroyed_cards, 1, -1 do
              local card = destroyed_cards[i]
              if card.ability.name == 'Glass Card' then
                  card:shatter()
              else
                  card:start_dissolve(nil, i ~= #destroyed_cards)
              end
          end
          return true
      end
  }))
  return destroyed_cards
end

SMODS.Consumable:take_ownership('grim', {
  use = function(self, card, area, copier)
      local used_tarot = copier or card
      local destroyed_cards = random_destroy(used_tarot)
      G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.7,
          func = function()
              local cards = {}
              for i = 1, card.ability.extra do
                  -- TODO preserve suit vanilla RNG
                  local _suit, _rank =
                      pseudorandom_element(SMODS.Suits, pseudoseed('grim_create')).card_key, 'A'
                  local cen_pool = {}
                  for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                      if v.key ~= 'm_stone' and not v.overrides_base_rank then
                          cen_pool[#cen_pool + 1] = v
                      end
                  end
                  cards[i] = create_playing_card({
                      front = G.P_CARDS[_suit .. '_' .. _rank],
                      center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
                  }, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
              end
              playing_card_joker_effects(cards)
              return true
          end
      }))
      delay(0.3)
      for i = 1, #G.jokers.cards do
          G.jokers.cards[i]:calculate_joker({ remove_playing_cards = true, removed = destroyed_cards })
      end
  end,
})

SMODS.Consumable:take_ownership('familiar', {
  use = function(self, card, area, copier)
      local used_tarot = copier or card
      local destroyed_cards = random_destroy(used_tarot)
      G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.7,
          func = function()
              local cards = {}
              for i = 1, card.ability.extra do
                  -- TODO preserve suit vanilla RNG
                  local faces = {}
                  for _, v in ipairs(SMODS.Rank.obj_buffer) do
                      local r = SMODS.Ranks[v]
                      if r.face then table.insert(faces, r) end
                  end
                  local _suit, _rank =
                      pseudorandom_element(SMODS.Suits, pseudoseed('familiar_create')).card_key,
                      pseudorandom_element(faces, pseudoseed('familiar_create')).card_key
                  local cen_pool = {}
                  for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                      if v.key ~= 'm_stone' and not v.overrides_base_rank then
                          cen_pool[#cen_pool + 1] = v
                      end
                  end
                  cards[i] = create_playing_card({
                      front = G.P_CARDS[_suit .. '_' .. _rank],
                      center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
                  }, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
              end
              playing_card_joker_effects(cards)
              return true
          end
      }))
      delay(0.3)
      for i = 1, #G.jokers.cards do
          G.jokers.cards[i]:calculate_joker({ remove_playing_cards = true, removed = destroyed_cards })
      end
  end,
})

SMODS.Consumable:take_ownership('incantation', {
  use = function(self, card, area, copier)
      local used_tarot = copier or card
      local destroyed_cards = random_destroy(used_tarot)
      G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.7,
          func = function()
              local cards = {}
              for i = 1, card.ability.extra do
                  -- TODO preserve suit vanilla RNG
                  local numbers = {}
                  for _, v in ipairs(SMODS.Rank.obj_buffer) do
                      local r = SMODS.Ranks[v]
                      if v ~= 'Ace' and not r.face then table.insert(numbers, r) end
                  end
                  local _suit, _rank =
                      pseudorandom_element(SMODS.Suits, pseudoseed('incantation_create')).card_key,
                      pseudorandom_element(numbers, pseudoseed('incantation_create')).card_key
                  local cen_pool = {}
                  for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                      if v.key ~= 'm_stone' and not v.overrides_base_rank then
                          cen_pool[#cen_pool + 1] = v
                      end
                  end
                  cards[i] = create_playing_card({
                      front = G.P_CARDS[_suit .. '_' .. _rank],
                      center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
                  }, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
              end
              playing_card_joker_effects(cards)
              return true
          end
      }))
      delay(0.3)
      for i = 1, #G.jokers.cards do
          G.jokers.cards[i]:calculate_joker({ remove_playing_cards = true, removed = destroyed_cards })
      end
  end,
})

SMODS.Joker 
{
  key = 'maringios',
  loc_txt = 
  {
    name = 'Maringios',
    text = 
    {
      "This Joker gains {X:mult,C:white} X#1# {} Mult",
      "for every {C:attention}Stone Card{}",
      "scored this round",
      "{C:inactive}(Currently {X:mult,C:white} X#2# {}{C:inactive} Mult)"
    }
  },

  config = { extra = { extra = 0.5 } },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    return { vars = { card.ability.extra.extra, card.ability.x_mult } }
  end,

  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  rarity = 2,

  atlas = 'Odyssey',
  pos = { x = 0, y = 0 },

  cost = 6,

  in_pool = function()
    local condition = false
    if G.playing_cards then
        for k, v in pairs(G.playing_cards) do
            if v.config.center == G.P_CENTERS.m_stone then condition = true break end
        end
    end
    return condition
  end,

  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card.ability.name == G.P_CENTERS.m_stone.name and not context.blueprint then
      card.ability.x_mult = card.ability.x_mult + card.ability.extra.extra

    return {                    
        extra = { focus = card, message = localize { type='variable', key = 'a_xmult', vars = { card.ability.x_mult }, colour = G.C.MULT }},
        card = card,
    }
    elseif context.end_of_round and not context.blueprint then
      if card.ability.x_mult > 1 then
        card.ability.x_mult = 1
        return 
        {
          message = localize('k_reset'),
        }
      end
    end
  end
}

SMODS.Joker 
{
  key = 'lineus',
  loc_txt = 
  {
    name = 'Lineus',
    text = 
    {
      "Upgrade played {C:attention}poker hand{}",
      "on {C:attention}final hand{} of round",
      "{C:blue}-#1#{} hand per round"
    }
  },
  config = { extra = { hands_mod = 1 } },

  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.hands_mod } }
  end,

  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  rarity = 1,

  atlas = 'Odyssey',
  pos = { x = 1, y = 0 },

  cost = 4,

  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands_mod
  end,

  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands_mod
  end,

  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.before and G.GAME.current_round.hands_left == 0 then 
      return 
      {
        card = self,
        level_up = true,
        message = localize('k_level_up_ex')
      }
    end
  end
}

SMODS.Joker
{
  key = 'melira',
  loc_txt = 
  {
    name = 'Melira',
    text = 
    {
      '{C:attention}Steel Cards{} count',
      'as {C:attention}Gold{} cards',
      'and vice versa'
    }
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    info_queue[#info_queue+1] = G.P_CENTERS.m_gold
    return {}
  end,

  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  rarity = 2,

  atlas = 'Odyssey',
  pos = { x = 2, y = 0 },

  cost = 7,

  in_pool = function()
    local condition = false
    if G.playing_cards then
        for k, v in pairs(G.playing_cards) do
            if v.config.center == G.P_CENTERS.m_steel or v.config.center == G.P_CENTERS.m_gold then condition = true break end
        end
    end
    return condition
  end,

  calculate = function(self, card, context)
    if context.check_enhancement and not context.blueprint then
      if context.other_card.config.center == G.P_CENTERS.m_gold or context.other_card.config.center == G.P_CENTERS.m_steel then
        return 
        {
          m_steel = true,
          m_gold = true
        }
      end
    end
  end,
}

SMODS.Joker
{
  key = 'evigalina',
  loc_txt = 
  {
    name = 'Evigalina',
    text = 
    {
      '{X:mult,C:white} X#1# {} Mult if you used',
      'a {C:attention}Consumable{} since',
      'playing your last hand',
    }
  },

  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult } }
  end,

  config = { extra = { Xmult = 3.0, is_active = false } },

  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  rarity = 2,

  atlas = 'Odyssey',
  pos = { x = 3, y = 0 },

  cost = 5,

  calculate = function(self, card, context)
    if context.using_consumeable and not context.blueprint then
      card.ability.extra.is_active = true
      G.E_MANAGER:add_event(Event(
      {
        func = function() 
          card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable', key='k_evig_active'}})
          local eval = function(card) return (card.ability.extra.is_active) end
          juice_card_until(card, eval, true)
          return true
        end
      }))
    elseif context.joker_main then
      if card.ability.extra.is_active then
        return 
        {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          Xmult_mod = card.ability.extra.Xmult
        }
      end
    elseif context.cardarea == G.jokers and context.after and not context.blueprint then
      if card.ability.extra.is_active then
        card.ability.extra.is_active = false
        return
        {
          message = localize('k_reset'),
        }
      end
    end
  end
}

SMODS.Joker
{
  key = 'asta',
  loc_txt = 
  {
    name = 'Asta',
    text = 
    {
      'This Joker gains {C:mult}+#1#{} Mult',
      'when you enter and leave a',
      '{C:attention}shop{} without buying anything',
      '{C:inactive}(Currently{} {C:mult}+#2#{}{C:inactive} Mult)' 
    }
  },

  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult } }
  end,

  config = { extra = { mult_mod = 4, mult = 0, saw_non_shop = false, saw_shop_entry = false, purchased_anything = false } },

  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  rarity = 1,

  atlas = 'Odyssey',
  pos = { x = 4, y = 0 },

  cost = 3,

  calculate = function(self, card, context)
    if not context.blueprint and (context.buying_card or context.open_booster or context.reroll_shop) then
      card.ability.extra.purchased_anything = true
    elseif not context.blueprint and context.ending_shop then
      if card.ability.extra.saw_shop_entry and not card.ability.extra.purchased_anything then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
        G.E_MANAGER:add_event(Event(
        {
          func = function() 
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Upgraded!', colour = G.C.MULT})
            return true
          end
        }))
      end
      card.ability.extra.saw_non_shop = false
      card.ability.extra.saw_shop_entry = false
      card.ability.extra.purchased_anything = false
    elseif context.joker_main then
      if card.ability.extra.mult > 0 then
        return
        {
          mult_mod = card.ability.extra.mult,
          message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
        }
      end
    end
  end,

  -- hack: balatro has no context.shop_begin, so we use update 
  -- to see when we go from not being in a shop to being in a shop
  -- and essentially call that 'shop begin'
  update = function(self, card)
    if not G.jokers then return end

    local found = false
    for i=1, #G.jokers.cards do
      if G.jokers.cards[i] == card then
        found = true
        break
      end
    end

    if not found then return end

    if G.STATE ~= G.STATES.SHOP then
      card.ability.extra.saw_non_shop = true
    elseif G.STATE == G.STATES.SHOP and card.ability.extra.saw_non_shop then
      card.ability.extra.saw_shop_entry = true
      card.ability.extra.saw_non_shop = false
    end
  end
}

SMODS.Joker
{
  key = 'acacius',
  loc_txt = 
  {
    name = 'Acacius',
    text = 
    {
      'Whenever you add a',
      'card to your deck,',
      'add {C:attention}#1#{} extra copies' 
    }
  },

  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.extra_copies } }
  end,

  config = { extra = { extra_copies = 3 } },

  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  rarity = 2,

  atlas = 'Odyssey',
  pos = { x = 5, y = 0 },

  cost = 5,

  calculate = function(self, card, context)
    if context.playing_card_added then
      --sendDebugMessage('cards: ' .. inspect(context.cards), MyDebugLogger)
      if context.cards then
        for _, card_to_copy in ipairs(context.cards) do
          if not card_to_copy.added_by_acacius then
            for i = 1, card.ability.extra.extra_copies, 1 do
              G.playing_card = (G.playing_card and G.playing_card + 1) or 1
              local new_card = copy_card(card_to_copy, nil, nil, G.playing_card)
              new_card:add_to_deck()
              G.deck.config.card_limit = G.deck.config.card_limit + 1
              table.insert(G.playing_cards, new_card)
              new_card.states.visible = nil
              -- we set added_by_acacius to prevent infinite loops of card adding
              new_card.added_by_acacius = true
              local eval_card = card
              if context.blueprint then eval_card = context.blueprint_card end
              card_eval_status_text(eval_card, 'extra', nil, nil, nil, {message = localize('k_copied_ex'), colour = G.C.CHIPS, card = eval_card, playing_cards_created = {new_card}})
            end
          end
        end
      end
    end
  end
}

SMODS.Joker
{
  key = 'merica',
  loc_txt = 
  {
    name = 'Merica',
    text = 
    {
      'This Joker gains {C:chips}+#2#{} Chips',
      'if {C:attention}poker hand{} is a {C:attention}#1#{},',
      'then poker hand changes',
      "{C:inactive}(Currently {}{C:chips}+#3#{} {C:inactive}Chips)"
    }
  },

  loc_vars = function(self, info_queue, card)
    return { vars = { (localize(get_current_merica_hand(card), 'poker_hands')), card.ability.extra.chip_mod, card.ability.extra.chips } }
  end,

  config = { extra = { merica_poker_hand = nil, chip_mod = 12, chips = 0 } },

  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  rarity = 2,

  atlas = 'Odyssey',
  pos = { x = 0, y = 1 },

  cost = 5,

  calculate = function(self, card, context)
    if context.scoring_name == get_current_merica_hand(card) and not context.blueprint then
      card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod

      local _poker_hands = {}
      for k, v in pairs(G.GAME.hands) do
          if v.visible then 
            _poker_hands[#_poker_hands+1] = k 
          end
      end
      local old_hand = card.ability.extra.merica_poker_hand
      card.ability.extra.merica_poker_hand = nil

      while not card.ability.extra.merica_poker_hand do
        card.ability.extra.merica_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('merica'))
        if card.ability.extra.merica_poker_hand == old_hand then 
          card.ability.extra.merica_poker_hand = nil 
        end
      end

      return
      {
        message = 'Upgraded!',
        colour = G.C.CHIPS,
        card = card
      }
    elseif context.joker_main and card.ability.extra.chips > 0 then
      return 
      {
        chip_mod = card.ability.extra.chips,
        message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips }},
        colour = G.C.CHIPS
      }
    end
  end
}

-- generate a random initial hand if current merica hand is not initialized
function get_current_merica_hand(card)
  if not card.ability.extra.merica_poker_hand then
    local _poker_hands = {}
    for k, v in pairs(G.GAME.hands) do
        if v.visible then _poker_hands[#_poker_hands+1] = k end
    end

    local random_hand = pseudorandom_element(_poker_hands, pseudoseed('merica', nil))
    card.ability.extra.merica_poker_hand = random_hand
  end

  return card.ability.extra.merica_poker_hand
end

SMODS.Joker
{
  key = 'opal',
  loc_txt = 
  {
    name = 'Opal',
    text = 
    {
      'Create a {C:dark_edition}Negative{}',
      '{C:purple}Tarot{} card for each',
      'discarded {C:attention}5{}'
    }
  },

  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.extra_copies } }
  end,

  config = { extra = { extra_copies = 3 } },

  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  rarity = 3,

  atlas = 'Odyssey',
  pos = { x = 1, y = 1 },

  cost = 5,

  calculate = function(self, card, context)
    if context.discard then
      if context.other_card:get_id() == 5 and not context.other_card.debuff then
        local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'opal')
        card:set_edition('e_negative', true)
        card:add_to_deck()
        G.consumeables:emplace(card)
        return 
        {
          message = localize('k_plus_tarot'),
          card = self
        }
      end
    end
  end
}

