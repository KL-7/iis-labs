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
    'if'  : { 'type': 'key-value', 'proprietary': 'no' },
    'then': { 'name': 'Tokyo Cabinet' }
  },
  {
    'if'  : { 'type': 'key-value', 'proprietary': 'yes' },
    'then': { 'name': 'Dynamo' }
  },
  {
    'if'  : { 'type': 'column-oriented', 'proprietary': 'yes' },
    'then': { 'name': 'Greenplum' }
  },
  {
    'if'  : { 'type': 'column-oriented', 'license': 'Apache' },
    'then': { 'name': 'Cassandra' }
  },
  {
    'if'  : { 'type': 'column-oriented', 'license': 'MPL' },
    'then': { 'name': 'MonetDB' }
  },
  {
    'if'  : { 'GPL based license': 'yes', 'changes release under a different license': 'no' },
    'then': { 'license': 'AGPL' }
  },
  {
    'if'  : { 'GPL based license': 'no', 'changes release under a different license': 'limited' },
    'then': { 'license': 'MPL' }
  },
  {
    'if'  : { 'GPL based license': 'no', 'changes release under a different license': 'yes' },
    'then': { 'license': 'Apache' }
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

var TARGET_ATTRIBUTES = ['name', 'license']

var ATTRIBUTES_TO_ASK = [
  'type',
  'ddl transactions',
  'proprietary',
  'GPL based license',
  'changes release under a different license',
  'commit hooks'
]

var ATTRIBUTES_MAP = {
  'type':              ['column-oriented', 'relational', 'document-oriented', 'key-value'],
  'ddl transactions':  ['yes', 'no'],
  'GPL based license': ['yes', 'no'],
  'proprietary':       ['yes', 'no'],
  'license':           ['AGPL', 'Apache', 'MPL'],
  'commit hooks':      ['yes', 'no'],
  'changes release under a different license': ['yes', 'no', 'limited']
};