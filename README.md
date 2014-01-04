# Gistub

Gistub is a stand alone application for sharing snippet such as `gist.github.com`.

If you're familiar with Rails apps, you can set up Gistub in several minutes. 

Many companies and organizations use Gistub for sharing code snippets safely in house.

[![Build Status](https://travis-ci.org/seratch/gistub.png)](https://travis-ci.org/seratch/gistub)
[![Coverage Status](https://coveralls.io/repos/seratch/gistub/badge.png?branch=develop)](https://coveralls.io/r/seratch/gistub?branch=develop)
[![Code Climate](https://codeclimate.com/github/seratch/gistub.png)](https://codeclimate.com/github/seratch/gistub)

## How to use

`master` branch is always the lastest stable version.

```sh
git clone git://github.com/seratch/gistub.git -b master
cd gistub
bin/bundle install
bin/bundle exec rake db:migrate
bin/bundle exec rails s
```

Access `http://localhost:3000/` through web browser.

## Live Demo

http://gistub.herokuapp.com/

Top page:

![top](https://raw.github.com/seratch/gistub/master/screenshot1.png)

Rich Editor with Ace:

![input](https://raw.github.com/seratch/gistub/master/screenshot2.png)


## Configuration over environment variables

Specify settings in `.bashrc` or others.

```
export GISTUB_OPENID_IDENTIFIER=https://your_auth_server/openid/
export GISTUB_AUTO_LINK=true
export GISTUB_ALLOWS_ANONYMOUS=false
export GISTUB_SECRET_TOKEN=xxx...
export GISTUB_SECRET_KEY_BASE=yyy...
```

## Gistub Tools

### For Emacs users

https://github.com/tototoshi/gistub-el

### For Vimmers

https://github.com/glidenote/nogistub.vim

## License

(The MIT License)

Copyright (c) 2012 Kazuhiro Sera <seratch__at__gmail.com>


