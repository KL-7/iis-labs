class Solver
  ITERATION_LIMIT = 30

  constructor: (db) ->
    @db = $.extend true, {}, db
    @properties = @db['properties']
    @classes = @db['classes']
    @classesNames = _.keys(@classes)

    this.buildPropertiesMap()

    this.renderProperties()
    this.renderPropertiesTable()

  buildPropertiesMap: ->
    @propertiesMap = {}

    for own klass, objects of @classes
      classMap = _.reduce(@properties, ((memo, property) -> memo[property] = 0; memo), {})

      for object in objects
        for value, propertyIndex in object['properties']
          classMap[@properties[propertyIndex]] += value

      if objects.length
        classMap[property] /= objects.length for property in @properties

      @propertiesMap[klass] = classMap

    for property in @properties
      total = _.reduce(_.values(@propertiesMap), ((total, classMap) -> total + classMap[property]), 0)
      average = total / _.values(@db['classes']).length
      classMap[property] = Math.abs(classMap[property] - average) for own klass, classMap of @propertiesMap

  renderProperties: ->
    container = $('.properties')

    @propertiesTranslations = @db['propertiesTranslations']
    @inversePropertiesTranslations = _.reduce(
      @properties,
      ((memo, property) => memo[@propertiesTranslations[property]] = property; memo ),
      {}
    )

    for property in @properties
      englishProperty = @propertiesTranslations[property]
      id = englishProperty + '_property'
      wrapper = $('<p>').appendTo(container)
      $('<input>', { type: 'checkbox', id: id, name: englishProperty }).appendTo(wrapper)
      $('<label>', { for: id }).html(property).appendTo(wrapper)

  solve: ->
    properties = this.getProperties()

    result = {}
    n = @properties.length

    for klass in @classesNames
      result[klass] = 0
      klassMap = @propertiesMap[klass]

      for object in @classes[klass]
        objectProperties = object['properties']
        coeff = (index) -> if objectProperties[index] == properties[index] then 1 else -1

        sum1 = _.reduce([0...n], ((sum, index) => sum + coeff(index) * klassMap[@properties[index]]), 0)
        sum2 = _.reduce(@properties, ((sum, property) -> sum + klassMap[property]), 0)

        mu = sum1 / sum2
        result[klass] = mu if result[klass] < mu

    answer = this.str(_.reduce(@classesNames, ((memo, klass) -> memo[klass] = result[klass].toFixed(2); memo), {}))
    $('.result span').html(answer)

  getProperties: ->
    properties = _.reduce(
      $('input[type=checkbox]'),
      ((memo, checkbox) =>
        memo[@inversePropertiesTranslations[checkbox.name]] = if checkbox.checked then 1 else 0
        memo
      ),
      {}
    )
    _.map(@properties, (property) -> properties[property])

  renderPropertiesTable: ->
    table = $('<table>').appendTo $('.content')

    head = $('<thead>').appendTo table
    headRow = $('<tr>').appendTo head
    $('<th>').html(klass).appendTo(headRow) for klass in [''].concat(@classesNames)

    body = $('<thead>').appendTo table
    for property in @properties
      tr = $('<tr>').appendTo body
      for value in [property].concat((@propertiesMap[klass][property] for klass in @classesNames))
        $('<td>').html(value).appendTo(tr)


  str: (obj) ->
    JSON.stringify obj

  log: (msg) ->
    console.log msg


$ ->
  window.solver = new Solver(DB)
  $('#solve').live 'click', -> solver.solve()