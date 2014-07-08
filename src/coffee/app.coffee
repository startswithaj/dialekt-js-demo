_ = require 'underscore'
$ = require 'jquery'

Dialekt       = require 'dialekt-js'
TreeRenderer  = require './treeRenderer'

parser        = new Dialekt.Parser.ExpressionParser
listParser    = new Dialekt.Parser.ListParser
renderer      = new Dialekt.Renderer.ExpressionRenderer
evaluator     = new Dialekt.Evaluator.Evaluator
treeRenderer  = new TreeRenderer

$elements = null
$ ->

  # Elements
  $elements =
    exprInput  : $('#expr')
    logicalOr  : $('#orByDefault')
    tagsInput  : $('#tags')
    submitBtn  : $('#submit')
   
    error      : $('#error')
    normExpr   : $('#normalised-expression')
    syntaxTree : $('#syntax-tree')

  # Events
  $elements.exprInput.keyup parse
  $elements.tagsInput.keyup parse
  $elements.submitBtn.click parse
  $elements.logicalOr.change ->
    parser.setLogicalOrByDefault $(this).prop('checked')
    parse()

  $('#version').text(" v" + Dialekt.version)


parse = ->
  expression = $elements.exprInput.val()
  tags       = $elements.tagsInput.val()
  try
    expression = parser.parse(expression)
    normExpr = renderer.render(expression)
    if tags and tags isnt ''
      tags = listParser.parseAsArray tags 
  catch e
    error e.name, e.message
    return true

  renderNormExpr(normExpr)
  renderSyntaxTree(expression, tags)
  $elements.error.hide()

error = (title, message) ->
  $elm = $elements.error
  if title and message
    $elm.slideDown()
    $elm.find('.error-title').text "Parse Error" + title
    $elm.find('.error-message').text message

renderNormExpr = (normExpr) -> 
  $elm = $elements.normExpr
  $content = $elm.find('.content').text ''
  if normExpr
    $elm.slideDown()
    $content.text _.escape(normExpr)
  else
    $elm.hide()

renderSyntaxTree = (expression, tags) ->
  $elm = $elements.syntaxTree
  $content = $elm.find('.content').html ""
  evalRes = null
  if tags
    evalRes = evaluator.evaluate(expression, tags)
  $content.html treeRenderer.render(expression, evalRes)
  $elm.slideDown()

