DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundler exec rails db:drop RAILS_ENV=production || true
bundler exec rails db:create RAILS_ENV=production
bundler exec rails db:migrate RAILS_ENV=production
bundler exec rails db:seed RAILS_ENV=production