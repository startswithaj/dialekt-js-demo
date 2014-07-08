_ = require 'underscore'
$ = require 'jquery'

ExpressionInterface = require('dialekt-js').AST.ExpressionInterface

class TreeRenderer

  # Render an expression to a string.
  #
  # @param ExpressionInterface expression The expression to render.
  #
  # @return string The rendered expression.
  #
  render: (expression, evaluationResult) ->
    @result = evaluationResult

    html  = '<ul class="syntax-tree">'
    html += @_renderList([expression])
    html += '</ul>'

    return html
  
  # Visit a LogicalAnd node.
  #
  # @internal
  #
  # @param LogicalAnd node The node to visit.
  #
  # @return mixed
  #
  visitLogicalAnd: (node) ->
    html  = '<span class="node-label">AND</span>'
    html += @_renderResult(node)
    html += @_renderList(node.children)

    return html
  
  # Visit a LogicalOr node.
  #
  # @internal
  #
  # @param LogicalOr node The node to visit.
  #
  # @return mixed
  #
  visitLogicalOr: (node) ->
    html  = '<span class="node-label">OR</span>'
    html += @_renderResult(node)
    html += @_renderList(node.children)

    return html
  
  # Visit a LogicalNot node.
  #
  # @internal
  #
  # @param LogicalNot node The node to visit.
  #
  # @return mixed
  #
  visitLogicalNot: (node) ->
    html  = '<span class="node-label">NOT</span>'
    html += @_renderResult(node)
    html += @_renderList([node.child])

    return html
  
  # Visit a Tag node.
  #
  # @internal
  #
  # @param Tag node The node to visit.
  #
  # @return mixed
  #
  visitTag: (node) ->
    html  = '<span class="node-label">TAG</span>'
    html += '<span class="node-data">'
    html += JSON.stringify(node.name)
    html += '</span>'
    html += @_renderResult(node)

    return html
  
  # Visit a Pattern node.
  #
  # @internal
  #
  # @param Pattern node The node to visit.
  #
  # @return mixed
  #
  visitPattern: (node) ->
    html  = '<span class="node-label">PATTERN</span>'
    html += @_renderResult(node)
    html += @_renderList(node.children)

    return html
  
  # Visit a PatternLiteral node.
  #
  # @internal
  #
  # @param PatternLiteral node The node to visit.
  #
  # @return mixed
  #
  visitPatternLiteral: (node) ->
    html  = '<span class="node-label">LITERAL</span>'
    html += '<span class="node-data">'
    html += JSON.stringify(node.string)
    html += '</span>'

    return html
  
  # Visit a PatternWildcard node.
  #
  # @internal
  #
  # @param PatternWildcard node The node to visit.
  #
  # @return mixed
  #
  visitPatternWildcard: (node) ->
    html = '<span class="node-label">WILDCARD</span>'

    return html
  
  # Visit a EmptyExpression node.
  #
  # @internal
  #
  # @param EmptyExpression node The node to visit.
  #
  # @return mixed
  #
  visitEmptyExpression: (node) ->
    html  = '<span class="node-label">EMPTY</span>'
    html += @_renderResult(node)

    return html

  _renderList: (nodes) ->
    html = '<ul>'

    for n in nodes
      html += '<li class="node">'
      if n instanceof ExpressionInterface and @result
        result = @result.resultOf(n)
        if result.isMatch
            html += '<span class="node-status success">&#x2714</span> '
        else 
            html += '<span class="node-status error">&#x2718</span> '  
      else 
        html += '<span class="node-status">&#151</span> '
      
      html += n.accept(this)
      html += '</li>'

    html += '</ul>'

    return html

  _inheritanceHierachy: (obj, klasses) ->
    klasses ?= []
    if obj.constructor
      klasses.push obj.constructor
    if obj.constructor?.__super__?
      @_inheritanceHierachy(obj.constructor.__super__, klasses)
    return klasses
  
  _renderResult: (expression) ->
    if not @result
      return ''
    
    result = @result.resultOf(expression)

    html  = '<span class="node-result">'

    if result.matchedTags.length > 0
      html += '<span class="success">'
      html += '('
      html += _.map(result.matchedTags, _.escape).join(', ')
      html += ') '
      html += '</span>'
  
    if result.unmatchedTags.length > 0 
      html += '<span class="error">'
      html += '('
      html += _.map(result.unmatchedTags, _.escape).join(', ')
      html += ')'
      html += '</span>'

    html += '</span>'

    return html


  module.exports = TreeRenderer
