class AdminDashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index
    @admin_dashboards = AdminDashboard.all
  end

  def show
    @admin_dashboard = AdminDashboard.find(params[:id])
  end

  def new
    @admin_dashboard = AdminDashboard.new
  end

  def edit
    @admin_dashboard = AdminDashboard.find(params[:id])
  end

  def create
    @admin_dashboard = AdminDashboard.new(admin_dashboard_params)
    if @admin_dashboard.save
      redirect_to @admin_dashboard, notice: 'Dashboard item was successfully created.'
    else
      render :new
    end
  end

  def update
    @admin_dashboard = AdminDashboard.find(params[:id])
    if @admin_dashboard.update(admin_dashboard_params)
      redirect_to @admin_dashboard, notice: 'Dashboard item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @admin_dashboard = AdminDashboard.find(params[:id])
    @admin_dashboard.destroy
    redirect_to admin_dashboards_url, notice: 'Dashboard item was successfully destroyed.'
  end

  private

  def admin_dashboard_params
    params.require(:admin_dashboard).permit(:title, :content)
  end

  def require_admin!
    redirect_to root_path, alert: 'Access denied. Admins only.' unless current_user&.role == 'admin'
  end
end
