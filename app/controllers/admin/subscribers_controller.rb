class Admin::SubscribersController < Admin::AdminController
  before_action :authorize
  before_action :set_subscriber, only: [:show, :edit, :update, :destroy]

  # /admin/subscribers
  def index
    @subscribers = Subscriber.all
  end

  # /admin/subscribers/1
  def show
  end

  # /admin/subscribers/new
  def new
    @subscriber = Subscriber.new
  end

  # /admin/subscribers/1/edit
  def edit
  end

  # /admin/subscribers
  def create
    @subscriber = Subscriber.new(subscriber_params)

    if @subscriber.save
      redirect_to [:admin, @subscriber], notice: "Subscriber was successfully created."
    else
      render :new
    end
  end

  # /admin/subscribers/1
  def update
    if @subscriber.update(subscriber_params)
      redirect_to [:admin, @subscriber], notice: "Subscriber was successfully updated."
    else
      render :edit
    end
  end

  # /admin/subscribers/1
  def destroy
    @subscriber.destroy
    redirect_to [:admin, :subscribers], notice: "Subscriber was successfully destroyed."
  end

  private

  def set_subscriber
    @subscriber = Subscriber.find(params[:id])
  end

  def subscriber_params
    params.require(:subscriber).permit(:email, :frequency)
  end
end
