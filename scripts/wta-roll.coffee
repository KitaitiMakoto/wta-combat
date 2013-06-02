exports = this

Roll = Backbone.Model.extend {
    defaults: ->
      {number: 10, difficulty: 6, result: null}
    roll: ->
      result = Math.floor(Math.random() * @get("number") + 1)
      @set "result", result
      result
  }
exports.Roll = Roll

RollCollection = Backbone.Collection.extend {
    model: Roll
  }
exports.RollCollection = RollCollection

class Die
  @roll: (number) ->
     Math.floor(Math.random() * number + 1)
exports.Die = Die

exports.roll = (dicePool, difficulty = 6, doReroll = false) ->
  result =
    eyes: []
    successes: 0
    botch: false
  return result if dicePool <= 0

  eyes = (Die.roll(10) for [1..dicePool])
  result.eyes.push eyes

  sfs = ((if eye >= difficulty then 1 else 0) for eye in eyes) # success or failure
  for sf in sfs
    result.successes++ if sf is 1

  if result.successes is 0 and 1 in eyes
    result.botch = true
    return result

  for eye in eyes
    result.successes-- if eye is 1

  result.successes = 0 if result.successes < 0

  return result unless doReroll

  nextDicePool = (eye for eye in eyes when eye is 10).length
  return result unless nextDicePool > 0

  rerollResult = reroll(nextDicePool, difficulty, [])
  for eyes in rerollResult
    result.eyes.push eyes
    successes = 0
    successes += (eye for eye in eyes when eye > difficulty).length
    successes -= (eye for eye in eyes when eye is 1).length
    successes = 0 if successes < 0
    result.successes += successes

  result

exports.reroll = (dicePool, difficulty, eyesList) ->
  eyes = (Die.roll(10) for [1..dicePool])

  eyesList.push eyes
  nextDicePool = (eye for eye in eyes when eye is 10).length

  reroll(nextDicePool, difficulty, eyesList) if nextDicePool > 0

  eyesList
