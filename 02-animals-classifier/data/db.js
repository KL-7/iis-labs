var DB = {

  // отряды четвероногих
  classes: {

    'Земноводные': [
    ],

    'Пресмыкающиеся': [
      { 'name': 'Крокодил', 'properties': [1, 1, 1] },
    ],

    'Птицы': [
      { 'name': 'Фламинго', 'properties': [1, 1, 0] },
    ],

    'Млекопетающие': [
      { 'name': 'Мышь', 'properties': [0, 1, 0] },
      { 'name': 'Слон', 'properties': [1, 1, 0] },
    ],

  },

  properties: [
    'большое',  // 0
    'хвост',    // 1
    'плавает',  // 2
  ],

  propertiesTranslations: {
    'большое': 'big',
    'хвост':   'tail',
    'плавает': 'swim',
  }

};