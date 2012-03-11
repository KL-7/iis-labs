var DB = [
  {
    'if'  : { 'type': 'relational', 'ddl transactions': 'yes' },
    'then': { 'name': 'PostgreSQL' }
  },
  {
    'if'  : { 'type': 'relational', 'ddl transactions': 'no' },
    'then': { 'name': 'MySQL' }
  },
  {
    'if'  : { 'type': 'key-value' },
    'then': { 'name': 'Tokyo Cabinet' }
  },
  {
    'if'  : { 'type': 'column-oriented' },
    'then': { 'name': 'Cassandra' }
  },
  {
    'if'  : { 'type': 'document-oriented', 'license': 'AGPL' },
    'then': { 'name': 'MongoDB' }
  },
  {
    'if'  : { 'type': 'document-oriented', 'license': 'Apache', 'commit hooks': 'yes' },
    'then': { 'name': 'Riak' }
  },
  {
    'if'  : { 'type': 'document-oriented', 'license': 'Apache', 'commit hooks': 'no' },
    'then': { 'name': 'CouchDB' }
  }
];