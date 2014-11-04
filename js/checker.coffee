# require https://github.com/reworkcss/css

class Rule
  constructor: ->
    @funcs = []

  # 应该包含选择器
  should_contain_selector: (selector, info = "")->
    @funcs.push (ast)->
      for rule in ast.stylesheet.rules
        console.log rule.selectors


class CssAstChecker
  constructor: ->
    @rules = []

  rule: ->
    rule = new Rule
    @rules.push rule
    return rule 

  check: (ast)->
    

window.CssAstChecker = CssAstChecker