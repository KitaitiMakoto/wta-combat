(function() {
  var calcDamage, exports, hit;
  exports = this;
  hit = function() {
    var result;
    result = {
      additionalPool: 0,
      defenseBotched: false
    };
    $("#attack, #defense").each(function(index) {
      var $li, dif, doReroll, dp, eyes, res, successPurchased, texts, _i, _len, _ref;
      $li = $(this);
      dp = $li.find('[name="dicepool"]').val();
      dif = $li.find('[name="difficulty"]').val();
      doReroll = $li.find('[name="specialty"]').attr("checked");
      res = roll(dp, dif, doReroll);
      successPurchased = $li.find('[name="willpower"]').attr("checked");
      if (successPurchased) {
        res.botch = false;
        if (res.successes <= 0) {
          res.successes = 1;
        } else {
          res.successes += 1;
        }
      }
      texts = [];
      if (res.botch && !successPurchased) {
        texts.push("<strong>Botch!</strong>");
      }
      texts.push("" + res.successes + " successes");
      _ref = res.eyes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        eyes = _ref[_i];
        texts.push("[" + eyes + "]");
      }
      if (successPurchased) {
        texts.push("(Willpower exausted)");
      }
      $li.find(".result").html(texts.join(" "));
      if ($li.attr("id") === "attack") {
        result.additionalPool += res.successes;
      }
      if ($li.attr("id") === "defense") {
        result.additionalPool -= res.successes + 1;
        if (res.botch) {
          return result.defenseBotched = true;
        }
      }
    });
    return result;
  };
  calcDamage = function(additionalPool, defenseBotched) {
    var damage, selector;
    if (defenseBotched == null) {
      defenseBotched = false;
    }
    damage = 0;
    selector = "#damage";
    if (defenseBotched) {
      $("#soak .result").html("No soak(defense botched)");
    } else {
      selector += ", #soak";
    }
    $(selector).each(function(index) {
      var $li, dif, doReroll, dp, eyes, res, texts, _i, _len, _ref;
      $li = $(this);
      dp = parseInt($li.find('[name="dicepool"]').val()) + additionalPool;
      dif = $li.find('[name="difficulty"]').val();
      doReroll = false;
      res = roll(dp, dif, doReroll);
      texts = [];
      texts.push("" + res.successes + " successes");
      _ref = res.eyes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        eyes = _ref[_i];
        texts.push("[" + eyes + "]");
      }
      if ($li.attr("id") === "damage") {
        damage += res.successes;
      }
      if ($li.attr("id") === "soak") {
        damage -= res.successes;
      }
      return $li.find(".result").html(texts.join(" "));
    });
    return damage;
  };
  $("#trigger").click(function(event) {
    var damage, hitResult;
    $(".result").html("");
    $("#result").html("");
    hitResult = hit();
    if (hitResult.additionalPool < 0) {
      return $("#result").html("Attack failured");
    } else {
      damage = calcDamage(hitResult.additionalPool, hitResult.defenseBotched);
      if (damage <= 0) {
        return $("#result").html("Attack soaked totally");
      } else {
        return $("#result").html("Attack successed with " + damage + " damages!");
      }
    }
  });
}).call(this);
