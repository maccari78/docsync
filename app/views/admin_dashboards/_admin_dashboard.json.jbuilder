json.extract! admin_dashboard, :id, :title, :content, :created_at, :updated_at
json.url admin_dashboard_url(admin_dashboard, format: :json)
