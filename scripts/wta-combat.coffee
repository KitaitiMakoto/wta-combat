hit = ->
  result =
    additionalPool: 0,
    defenseBotched: false

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

    view =
      botch: res.botch
      successPurchased: successPurchased
      successes: res.successes
      formattedEyes: formatEyes(eyes, dif) for eyes in res.eyes
    $(".result", $li).html Mustache.render($("#roll-result").html(), view)

    if $li.attr("id") is "attack"
      if res.successes <= 0
        result.additionalPool = -1
      else
        result.additionalPool += res.successes
    if $li.attr("id") is "defense"
      if res.botch
        result.defenseBotched = true
      else
        result.additionalPool -= (res.successes + 1)

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
    attacking = ($li.attr("id") is "damage")
    dp = parseInt($li.find('[name="dicepool"]').val())
    dp += additionalPool if attacking
    dif = $li.find('[name="difficulty"]').val()
    doReroll = false
    res = roll(dp, dif, doReroll)

    successPurchased = $li.find('[name="willpower"]').attr("checked")
    if successPurchased
      if res.successes <= 0
        res.successes = 1
      else
        res.successes += 1

    view =
      successPurchased: successPurchased
      successes: res.successes
      formattedEyes: formatEyes(eyes, dif) for eyes in res.eyes
      additionalPool: if attacking && (additionalPool > 0) then additionalPool else null
    $(".result", $li).html Mustache.render($("#roll-result").html(),view)

    damage += res.successes if $li.attr("id") is "damage"
    damage -= res.successes if $li.attr("id") is "soak"
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

reset = ->
  $(".result").html("")
  $("#result").html("")
  $("#additional-pool").html("")

$("#diceroll input[type='submit']").click (event) ->
  event.preventDefault()
  $container = $("#diceroll")
  $resultArea = $(".result", $container)
  $resultArea.html("")
  dp = $('input[name="dicepool"]').val()
  dif = $('input[name="difficulty"]', $container).val()
  doReroll = $('[name="specialty"]').attr("checked")
  $(".result", $container).html("roll")
  res = roll(dp, dif, doReroll)
  successPurchased = $('[name="willpower"]', $container).attr("checked")
  if successPurchased
    res.botch = false
    if res.successes <= 0
      res.successes = 1
    else
      res.successes += 1
  view =
    botch: res.botch
    successPurchased: successPurchased
    successes: res.successes
    formattedEyes: formatEyes(eyes, dif) for eyes in res.eyes
  $resultArea.html Mustache.render($("#roll-result").html(), view)
  console.log res

$("#trigger").click (event) ->
  reset()
  hitResult = hit()
  if hitResult.additionalPool < 0
    $("#result").html("Attack failured")
  else
    damage = calcDamage(hitResult.additionalPool, hitResult.defenseBotched)
    if damage <= 0
      $("#result").html("Attack totally soaked")
    else
      $("#result").html("Attack succeeded with <strong class=\"number\">#{damage}</strong> damages!")

$('input[type="reset"]').click (event) ->
  reset()

$defWill = $("#defense input[name=\"willpower\"]")
$soakWill = $("#soak input[name=\"willpower\"]")
$defWill.change (event) ->
  if $defWill.attr("checked")
    $soakWill.attr("disabled", true)
  else
    $soakWill.attr("disabled", false)
$soakWill.change (event) ->
  if $soakWill.attr("checked")
    $defWill.attr("disabled", true)
  else
    $defWill.attr("disabled", false)
