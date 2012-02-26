hit = ->
  result = {
    additionalPool: 0,
    defenseBotched: false
  }
  $("#attack, #defense").each (index) ->
    $li = $(this)
    dp = $li.find('[name="dicepool"]').val()
    dif = $li.find('[name="difficulty"]').val()
    doReroll = $li.find('[name="specialty"]').attr("checked")
    res = roll(dp, dif, doReroll)

    successPurchased = $li.find('[name="willpower"]').attr("checked")
    if successPurchased
      res.botch = false
      if res.successes <= 0
        res.successes = 1
      else
        res.successes += 1
    texts = []
    texts.push '<strong class="botch">Botch!</strong>' if res.botch and not successPurchased
    texts.push "#{res.successes} successes"
    texts.push "#{formatEyes(eyes, dif)}" for eyes in res.eyes
    texts.push "(Willpower exausted)" if successPurchased

    $li.find(".result").html texts.join(" ")
    result.additionalPool += res.successes if $li.attr("id") is "attack"
    if $li.attr("id") is "defense"
      result.additionalPool -= (res.successes + 1)
      result.defenseBotched = true if res.botch
  result

calcDamage = (additionalPool, defenseBotched = false) ->
  damage = 0
  selector = "#damage"
  if defenseBotched
    $("#soak .result").html("No soak(defense botched)")
  else
    selector += ", #soak"
  $(selector).each (index) ->
    $li = $(this)
    dp = parseInt($li.find('[name="dicepool"]').val()) + additionalPool
    dif = $li.find('[name="difficulty"]').val()
    doReroll = false
    res = roll(dp, dif, doReroll)
    texts = []
    texts.push "#{res.successes} successes"
    texts.push "#{formatEyes(eyes, dif)}" for eyes in res.eyes

    damage += res.successes if $li.attr("id") is "damage"
    damage -= res.successes if $li.attr("id") is "soak"
    $li.find(".result").html texts.join(" ")
  damage

formatEyes = (eyes, difficulty) ->
  marked = []
  for eye in eyes
    if eye is 1
      marked.push '<strong class="one-eye">1</strong>'
    else if eye >= difficulty
      marked.push "<strong>#{eye}</strong>"
    else
      marked.push "#{eye}"
  "[#{marked.join(', ')}]"

$("#trigger").click (event) ->
  $(".result").html("")
  $("#result").html("")
  hitResult = hit()
  if hitResult.additionalPool < 0
    $("#result").html("Attack failured")
  else
    damage = calcDamage(hitResult.additionalPool, hitResult.defenseBotched)
    if damage <= 0
      $("#result").html("Attack soaked totally")
    else
      $("#result").html("Attack successed with <strong>#{damage}</strong> damages!")
