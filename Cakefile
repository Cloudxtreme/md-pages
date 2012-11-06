md      = require("node-markdown").Markdown
fs      = require 'fs'
path    = require 'path'
eco     = require 'eco'
async   = require 'async'
console = require('tracer').colorConsole()
{exec}  = require 'child_process'
yaml    = require('js-yaml')
_       = require 'underscore'
tmpl    = {}
config  = {}

option '-i', '--input [IN]', 'output file'
option '-o', '--output [OUT]', 'output file'

task 'gen', 'Generate html file', (opts)->
  f = opts.file ? 'src/ru.md'
  inFile = path.resolve __dirname, f
  outFile = inFile.replace('.md', '.html').replace('/src/', '/build/')
  tmpl = fs.readFileSync './layout.eco', 'utf-8'
  text = fs.readFileSync inFile, 'utf-8'
  fs.writeFileSync(outFile,eco.render(tmpl, {page:md(text)}), 'utf-8')

readConfig = (next)->
  config = yaml.load fs.readFileSync('./config.yml').toString()
  next() if next?
  config

treeItem = ->
  name: 'index'
  path: null
  include: null
  config: null
  toLink:false

defConf = ->
  title:null
  template:'layout'

genTmplCache = (next)->
  for file in fs.readdirSync './templates'
    tmpl[file.split('.', 2)[0]] = fs.readFileSync(path.join('./templates', file)).toString()
  next()

buildTree = (name, relative='./',tree={})->
  for local in fs.readdirSync(name)
    t = treeItem()
    t.path = path.resolve(name, local)
    t.relPath = path.join relative, local
    if fs.statSync(path.resolve(name, local)).isDirectory()
      t.include = {}
      t.name = local
      buildTree path.resolve(name, local), t.relPath,t.include
    else if (local.split('.').slice(-1)[0] ? '') in ['md', 'markdowm']
      raw = fs.readFileSync(path.resolve(name, local)).toString().split('\n\n')
      t.text = md(raw.slice(1).join('\n\n'))
      t.config = _.extend defConf(), yaml.load(raw[0])
      t.name = local.split('.', 2)[0]
    else
      t.name = local
      t.toLink = true
    tree[t.name]= t

getTree = (name, next)->
  tree= {}
  buildTree path.resolve('./', name), null, tree
  next(null,tree)

buildFolder = (tree, rel, src)->
  try fs.mkdirSync path.resolve(rel)
  for key,value of tree
    if not value.include? and not value.toLink
      done = eco.render tmpl[value.config.template], _.extend(value.config,{page:value.text, config:config})
      fs.writeFileSync path.resolve(rel, value.name+'.html'), done,'utf-8'
    else if value.include?
      buildFolder value.include, path.join(rel, value.name), src
    else if !!value.toLink and not value.include?
      try fs.linkSync(path.resolve(src, value.relPath), path.resolve(rel.split('/', 1).pop(), value.relPath))

buildPages = (tree, relative='./', src,next)->
  buildFolder tree, relative, src
  next()

task 'build', 'Build static pages', (opts)->
  baseFolder = path.join '.', opts.input ? 'src'
  targetFolder = path.join '.', opts.output ? 'build'
  async.waterfall [
    genTmplCache
  , readConfig
  , (next)-> 
    getTree baseFolder, (err, tree)->
      next(err,tree)
  , (tree, next)-> 
    buildPages tree, targetFolder, baseFolder, ->
      next()
  ], (err, res)->
    console.error(err) if err?
    console.info '\n\n\tDone!\n'

