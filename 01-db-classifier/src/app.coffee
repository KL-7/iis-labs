class Solver
  ITERATION_LIMIT = 1000

  constructor: (db) ->
    @db = $.extend [], db

    @input = $('#ask input')
    @label = $('#ask label')
    @button = $('#ask button')

  resolve: (attr) ->
    @finalTarget = attr
    @targets = [{ 'attr': @finalTarget }]

    @iteration = 0
    @knowns = {}

    this.iterate()

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
      if target.attr != @finalTarget
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

  isKnown: (attr) ->
    _.has @knowns, attr

  ask: (attr) ->
    this.log 'ask:\n\t' + attr
    @label.html attr
    @button.attr('disabled', false).bind 'click.ask', =>
      this.onAnswer(attr)
    @input.attr('disabled', false).bind 'keypress.ask', (e) =>
      if e.keyCode == 13 then this.onAnswer(attr)

  onAnswer: (attr) ->
    if value = $('#ask #value').val()
      @knowns[attr] = value

      this.log '\tanswer:\t' + value
      @button.attr('disabled', true).unbind '.ask'
      @input.attr('disabled', true).val('').unbind '.ask'
      @label.html ''

      this.iterate()
    else
      alert "Attribute value can't be blank!"

  str: (obj) ->
    JSON.stringify obj

  log: (msg) ->
    console.log msg

$ ->
  solver = new Solver(DB)
  solver.resolve 'name'