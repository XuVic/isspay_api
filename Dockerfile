FROM ruby-2.5.1:vicxu

ENTRYPOINT bundle exec puma -b unix:///app/tmp/sockets/puma.sock