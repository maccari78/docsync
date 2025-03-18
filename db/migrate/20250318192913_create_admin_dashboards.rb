class CreateAdminDashboards < ActiveRecord::Migration[7.1]
  def change
    create_table :admin_dashboards do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
