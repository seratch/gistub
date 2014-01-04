# -*- encoding : utf-8 -*-
Gistub::Application.config.secret_token = ENV['GISTUB_SECRET_TOKEN'] || '9d823ec9de09d00bec258fee515a324f9499cc3d334bdd8955a4e779094cf1bf37f6c2d77ff65ef6222ab038a8b49f6e1fd81949b05ffdbaa64e5df2fc5f507b'
Gistub::Application.config.secret_key_base = ENV['GISTUB_SECRET_TOKEN'] || 'something like 4f9499cc3d334bdd8955a4e779094cf1bf37f6c2'

