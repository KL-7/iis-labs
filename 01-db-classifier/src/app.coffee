class Solver
  ITERATION_LIMIT = 30

  constructor: (db, attrsMap, attrsToAsk, select, button, label) ->
    @db = $.extend true, [], db

    @attrsMap   = attrsMap
    @attrsToAsk = attrsToAsk

    @select = select
    @label  = label
    @button = button

  resolve: (attr) ->
    this.initControls()

    @finalTarget = attr
    @targets = [{ 'attr': @finalTarget }]

    @iteration = 0
    @knowns = {}

    this.iterate()

  initControls: ->
    @select.empty().attr('disabled', true).unbind '.ask'
    @label.html ''
    @button.html('next').attr('disabled', true).unbind '.ask'

  iterate: ->
    if (@iteration += 1) > ITERATION_LIMIT
      throw 'Limit of ' + ITERATION_LIMIT + ' iteration exceeded =('

    if !@targets.length
      this.done()
      return

    this.log 'iterate:\n\ttargets:' + this.str(@targets)
    target = _.last @targets
    rule = this.findRule(target.attr)
    this.log '\ttarget:\t' + this.str(target) + '\n\trule:\t' + this.str(rule)

    if rule?
      this.processRule rule
      this.iterate()
    else
      if target.attr != @finalTarget and _.include(@attrsToAsk, target.attr)
        @targets.pop()
        this.ask(target.attr)
      else
        this.done()
        return

  processRule: (rule, target) ->
    this.log 'processing:\n\trule:\t' + this.str(rule)
    result = this.checkRule rule
    this.log '\tresult:\t' + result

    if result?
      if result
        for own attr, value of rule.then
          @knowns[attr] = value
        @targets.pop()
      else
        rule.false = true
    else
      unknownAttr = _.find _.keys(rule.if), (attr) => !this.isKnown(attr)
      @targets.push { 'attr': unknownAttr }

  findRule: (attr) ->
    _.find @db, (r) -> !r.false && _.has(r.then, attr)

  checkRule: (rule) ->
    for own attr, value of rule.if
      return unless this.isKnown(attr)
      return false if @knowns[attr] != value
    return true

  done: ->
    if _.has @knowns, @finalTarget
      alert @finalTarget + ' = ' + @knowns[@finalTarget]
    else
      alert "Can't resolve " + @finalTarget
      
    restartSolver()

  isKnown: (attr) ->
    _.has @knowns, attr

  ask: (attr) ->
    this.log 'ask:\n\t' + attr
    @label.html attr

    @button.attr('disabled', false).bind 'click.ask', =>
      this.onAnswer(attr)

    @select.empty().attr('disabled', false).bind 'keypress.ask', (e) =>
      if e.keyCode == 13 then this.onAnswer(attr)

    _.each @attrsMap[attr], (v) => $('<option>').html(v).appendTo(@select)

  onAnswer: (attr) ->
    this.log '\tanswer:\t' + @select.val()

    @knowns[attr] = @select.val()
    @button.attr('disabled', true).unbind '.ask'
    @select.attr('disabled', true).empty().unbind '.ask'
    @label.html ''

    this.iterate()

  str: (obj) ->
    JSON.stringify obj

  log: (msg) ->
    console.log msg

restartSolver = ->
  select = $('#ask select').attr('disabled', false).empty()
  button = $('#ask button').attr('disabled', false).html('start')
  label  = $('#ask label').html 'attribute to resolve'

  solver = new Solver(DB, ATTRIBUTES_MAP, ATTRIBUTES_TO_ASK, select, button, label)

  _.each TARGET_ATTRIBUTES, (attr) -> select.append $('<option>').html(attr)

  onClick = ->
    button.unbind '.start'
    select.unbind '.start'
    solver.resolve select.val()

  button.bind 'click.start', onClick
  select.bind 'keypress.start', (e) -> if e.keyCode == 13 then onClick()

$ ->
  $('#restart').click restartSolver
  restartSolver()
