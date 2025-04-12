namespace :db do
  desc 'Force apply Active Storage migration'
  task force_active_storage_migration: :environment do
    puts 'Forcing Active Storage migration...'
    ActiveRecord::MigrationContext.new(
      'db/migrate',
      ActiveRecord::SchemaMigration
    ).migrate
    puts 'Migration applied!'
  end
end
