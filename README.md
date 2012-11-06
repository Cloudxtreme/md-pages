Static markdown pages
=====================

Minimalistic static page builder. Based at node.js, eco templates, markdown.

## Usage

### Start:

```bash
$ mkdir templates
$ touch tempaltes/layout.eco // default extended template
$ mkdir src // yours md files here
$ make serve // serve site at http://127.0.0.1:5000
```

### Markdown:

It uses the typical markdown syntax. But also yaml configuration file is used at the top of the file, separated by two line breaks(``\n\n``).

### Template:

Create base template ``mytemplate.eco`` in ``templates`` folder. And specify the template in *.md files. Default template is ``layout``, without ``.eco``.

Example:

```markdown
template: mytemplate
title: My Great Title
lang: ru
alter:
  en: /en

<!-- typical markdown syntax -->
## My Article
...
```





