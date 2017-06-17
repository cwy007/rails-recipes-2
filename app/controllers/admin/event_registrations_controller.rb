class Admin::EventRegistrationsController < AdminController

  before_action :find_event

  def index
    @registrations = @event.registrations.includes(:ticket).order("id DESC")
  end

  def new
    @registration = @event.registrations.new
  end

  def create
    @registration = @event.registrations.new(registration_params)

    if @registration.save
      flash[:notice] = "Registration 成功"
      redirect_to admin_event_registrations_path
    else
      render "new"
    end
  end

  def edit
    @registration = @event.registrations.find_by_uuid(params[:id])
  end

  def update
    @registration = @event.registrations.find_by_uuid(params[:id])

    if @registration.update(registration_params)
      flash[:notice] = "修改成功"
      redirect_to admin_event_registrations_path
    else
      render "edit"
    end
  end

  def destroy
    @registration = @event.registrations.find_by_uuid(params[:id])
    @registration.destroy

    flash[:alert] = "#{@registration.name} 已删除"
    redirect_to admin_event_registrations_path(@event)
  end

  protected

  def find_event
    @event = Event.find_by_friendly_id(params[:event_id])
  end

  def registration_params
    params.require(:registration).permit( :status, :ticket_id, :name, :email, :cellphone, :website, :bio )
  end

end
