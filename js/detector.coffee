class Detector
  constructor: (init_message = '')->
    @rules = []
    @messages = [
      init_message
    ]

  check: (code)->
    # 依次检查每一条规则，记录通过检查的规则数目
    passed = -1
    remain = code
    for rule, idx in @rules
      result = rule.check(remain)
      if result.match
        passed = idx
        remain = result.remain
      else
        break

    return {
      passed: passed
      message: @messages[passed + 1]
    }

  add_string_rule: (string, message)->
    @rules.push new StringRule string
    @messages.push message

class Rule

class StringRule extends Rule
  constructor: (regex_string)->
    @regex = new RegExp "^#{regex_string}"

  check: (code)->
    _code = code.trim()
    console.log _code
    match = _code.match @regex
    remain_code = _code.replace @regex, ''
    return {
      match: match
      remain: remain_code
    }

class ASTRule extends Rule
  constructor: ->
    @matcher = null

window.Detector = Detector