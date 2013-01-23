# Gistub

Gistub is a stand alone application for sharing snippet such as `gist.github.com`.

## How to use

```sh
git clone git://github.com/seratch/gistub.git
cd gistub
bundle install
bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake assets:precompile
rails s
```

Access `http://localhost:3000/` through web browser.

## Live Demo

http://gistub-demo.seratch.net/

![demo](https://raw.github.com/seratch/gistub/master/gistub_demo.png)

## License

The MIT License

