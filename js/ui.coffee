class Editor
  constructor: (@detector)->
    @$textarea = jQuery('textarea.css-code')

    @$tip_correct = jQuery('.tip.correct')
    @$tip_error = jQuery('.tip.error')
    @$message = jQuery('.tip.message')

  init: ->
    @cm = CodeMirror.fromTextArea @$textarea[0], {
      mode: 'css'
      lineNumbers: true
      theme: 'vibrant-ink'
      lineWrapping: true
    }

    @check_css()
    @cm.on 'change', =>
      @check_css()

  check_css: ->
    code = @cm.getValue()
    @$tip_correct.hide()
    @$tip_error.hide()

    # try
    #   ast = css.parse code
    #   @tip_correct.show()
    # catch e
    #   @tip_error.show().find('.e').text e

    result = @detector.check code
    @$message.html result.message if result.message


jQuery ->
  detector = new Detector '你需要声明一个选择器来作为一条 CSS 规则的开头，现在尝试在代码编辑器里输入 body'
  detector.add_string_rule 'body', '不错，你现在已经输入了 body , 这在 CSS 中被称为选择器。选择器还有很多种写法，你需要逐步掌握。现在尝试在 body 之后输入 { 来开始样式声明。'

  detector.add_string_rule '{', '现在可以开始写样式了。尝试按回车换行，并输入 font-size'

  detector.add_string_rule 'font-size', 'font-size 被称为样式名称。每种样式名称对应一种外观上的属性。你需要逐步掌握不同元素上的不同的样式名称。现在继续输入 :14px;'

  detector.add_string_rule '\:'
  detector.add_string_rule '14px'
  detector.add_string_rule '\;', '这样一条样式规则就完成了。现在换行并输入 } 来关闭这个选择器。'

  detector.add_string_rule '}', '不错，这样就完成了一条完整的 CSS 样式。'


  new Editor(detector).init()