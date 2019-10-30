system "bundle exec rails db:create db:migrate"
system "bundle exec puma -C config/puma.rb"