# Gistub

Gistub is a stand alone application for sharing snippet such as `gist.github.com`.

## How to use

```sh
git clone git://github.com/seratch/gistub.git -b master
cd gistub
git submodule init
git submodule update
bundle install
bundle exec rake db:migrate
bundle exec rails s
```

Access `http://localhost:3000/` through web browser.

## Live Demo

http://gistub-demo.seratch.net/

![demo](https://raw.github.com/seratch/gistub/master/gistub_demo.png)

## Travis CI

[![Build Status](https://travis-ci.org/seratch/gistub.png)](https://travis-ci.org/seratch/gistub)

## Coveralls

[![Coverage Status](https://coveralls.io/repos/seratch/gistub/badge.png?branch=develop)](https://coveralls.io/r/seratch/gistub?branch=develop)

## Code Climate

[![Code Climate](https://codeclimate.com/github/seratch/gistub.png)](https://codeclimate.com/github/seratch/gistub)


## Gistub Tools

### For Emacs users

https://github.com/tototoshi/gistub-el

### For Vimmers

https://github.com/glidenote/nogistub.vim

## License

(The MIT License)

Copyright (c) 2012 Kazuhiro Sera <seratch__at__gmail.com>


