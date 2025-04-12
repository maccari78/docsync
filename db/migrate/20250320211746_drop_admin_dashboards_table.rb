class DropAdminDashboardsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :admin_dashboards
  end
end