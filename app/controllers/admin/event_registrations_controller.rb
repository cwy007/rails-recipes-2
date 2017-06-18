class Admin::EventRegistrationsController < AdminController

  before_action :find_event

  #逐层过滤
  def index
    @registrations = @event.registrations.includes(:ticket).order("id DESC").page(params[:page])

    if params[:registration_id].present?
      @registrations = @registrations.where(:id => params[:registration_id].split(",") )
    end

    if params[:start_on].present?
      @registrations = @registrations.where( "created_at >= ?", Date.parse(params[:start_on]).beginning_of_day )
    end

    if params[:end_on].present?
      @registrations = @registrations.where( "created_at <= ?", Date.parse(params[:end_on]).end_of_day )
    end

    if Array(params[:statuses]).any?
      @registrations = @registrations.by_status(params[:statuses])
    end

    if Array(params[:ticket_ids]).any?
      @registrations = @registrations.by_ticket(params[:ticket_ids])
    end

    if params[:status].present? && Registration::STATUS.include?(params[:status])
      @registrations = @registrations.by_status(params[:status])
    end

    if params[:ticket_id].present?
      @registrations = @registrations.by_ticket(params[:ticket_id])
    end

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
