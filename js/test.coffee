do ->
  QUnit.module '类定义'

  QUnit.test 'Detector', (assert)->
    assert.ok Detector

  QUnit.module '简单匹配，两条字符串规则'

  # 检查代码 console.
  detector = new Detector
  detector.add_string_rule 'console'
  detector.add_string_rule '\\.'

  QUnit.test '不匹配任何一条规则', (assert)->
    assert.equal detector.check('aaa').passed, -1

  QUnit.test '不匹配第一条规则，匹配第二条规则', (assert)->
    assert.equal detector.check('.').passed, -1

  QUnit.test '仅匹配第一条规则', (assert)->
    assert.equal detector.check('console').passed, 0
    assert.equal detector.check('consoleabc').passed, 0

  QUnit.test '匹配第一条，第二条规则', (assert)->
    assert.equal detector.check('console.').passed, 1

  QUnit.test '一二条规则之间隔着空格/换行', (assert)->
    assert.equal detector.check('console  .').passed, 1
    assert.equal detector.check('console\n.').passed, 1
    assert.equal detector.check('console  \n .').passed, 1

  QUnit.test '一二条规则之间隔着其他字符', (assert)->
    assert.equal detector.check('console a .').passed, 0

  QUnit.module '进阶匹配，若干字符串规则'

  # 检查代码 console.log("hello world")
  detector = new Detector
  detector.add_string_rule 'console'
  detector.add_string_rule '\\.'
  detector.add_string_rule 'log'
  detector.add_string_rule '\\('
  detector.add_string_rule '"hello world"'
  detector.add_string_rule '\\)'

  QUnit.test '连续匹配', (assert)->
    assert.equal detector.check('abc').passed, -1
    assert.equal detector.check('console').passed, 0
    assert.equal detector.check('console.').passed, 1
    assert.equal detector.check('console.log').passed, 2
    assert.equal detector.check('console.log(').passed, 3
    assert.equal detector.check('console.log("hello world"').passed, 4
    assert.equal detector.check('console.log("hello world")').passed, 5
    assert.equal detector.check('console . log( \n "hello world" \n )').passed, 5