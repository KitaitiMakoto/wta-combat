(function() {
  var Die, exports;
  var __indexOf = Array.prototype.indexOf || function(item) {
    for (var i = 0, l = this.length; i < l; i++) {
      if (this[i] === item) return i;
    }
    return -1;
  };
  exports = this;
  Die = (function() {
    function Die() {}
    Die.roll = function(number) {
      return Math.floor(Math.random() * number + 1);
    };
    return Die;
  })();
  exports.Die = Die;
  exports.roll = function(dicePool, difficulty, doReroll) {
    var eye, eyes, nextDicePool, rerollResult, result, sf, sfs, successes, _i, _j, _k, _len, _len2, _len3;
    if (difficulty == null) {
      difficulty = 6;
    }
    if (doReroll == null) {
      doReroll = false;
    }
    result = {
      eyes: [],
      successes: 0,
      botch: false
    };
    eyes = (function() {
      var _i, _results;
      _results = [];
      for (_i = 1; 1 <= dicePool ? _i <= dicePool : _i >= dicePool; 1 <= dicePool ? _i++ : _i--) {
        _results.push(Die.roll(10));
      }
      return _results;
    })();
    result.eyes.push(eyes);
    sfs = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = eyes.length; _i < _len; _i++) {
        eye = eyes[_i];
        _results.push((eye >= difficulty ? 1 : 0));
      }
      return _results;
    })();
    for (_i = 0, _len = sfs.length; _i < _len; _i++) {
      sf = sfs[_i];
      if (sf === 1) {
        result.successes++;
      }
    }
    if (result.successes === 0 && __indexOf.call(eyes, 1) >= 0) {
      result.botch = true;
      return result;
    }
    for (_j = 0, _len2 = eyes.length; _j < _len2; _j++) {
      eye = eyes[_j];
      if (eye === 1) {
        result.successes--;
      }
    }
    if (result.successes < 0) {
      result.successes = 0;
    }
    if (!doReroll) {
      return result;
    }
    nextDicePool = ((function() {
      var _k, _len3, _results;
      _results = [];
      for (_k = 0, _len3 = eyes.length; _k < _len3; _k++) {
        eye = eyes[_k];
        if (eye === 10) {
          _results.push(eye);
        }
      }
      return _results;
    })()).length;
    if (!(nextDicePool > 0)) {
      return result;
    }
    rerollResult = reroll(nextDicePool, difficulty, []);
    for (_k = 0, _len3 = rerollResult.length; _k < _len3; _k++) {
      eyes = rerollResult[_k];
      result.eyes.push(eyes);
      successes = 0;
      successes += ((function() {
        var _l, _len4, _results;
        _results = [];
        for (_l = 0, _len4 = eyes.length; _l < _len4; _l++) {
          eye = eyes[_l];
          if (eye > difficulty) {
            _results.push(eye);
          }
        }
        return _results;
      })()).length;
      successes -= ((function() {
        var _l, _len4, _results;
        _results = [];
        for (_l = 0, _len4 = eyes.length; _l < _len4; _l++) {
          eye = eyes[_l];
          if (eye === 1) {
            _results.push(eye);
          }
        }
        return _results;
      })()).length;
      if (successes < 0) {
        successes = 0;
      }
      result.successes += successes;
    }
    return result;
  };
  exports.reroll = function(dicePool, difficulty, eyesList) {
    var eye, eyes, nextDicePool;
    eyes = (function() {
      var _i, _results;
      _results = [];
      for (_i = 1; 1 <= dicePool ? _i <= dicePool : _i >= dicePool; 1 <= dicePool ? _i++ : _i--) {
        _results.push(Die.roll(10));
      }
      return _results;
    })();
    eyesList.push(eyes);
    nextDicePool = ((function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = eyes.length; _i < _len; _i++) {
        eye = eyes[_i];
        if (eye === 10) {
          _results.push(eye);
        }
      }
      return _results;
    })()).length;
    if (nextDicePool > 0) {
      reroll(nextDicePool, difficulty, eyesList);
    }
    return eyesList;
  };
}).call(this);
