class Admin::ContributorsController < Admin::AdminController
  before_action :authorize
  before_action :set_contributor, only: [:show, :edit, :update, :destroy]

  # /admin/contributors
  def index
    @contributors = Contributor.all
    @title = admin_title
  end

  # /admin/contributors/1
  def show
    @title = admin_title(@contributor, [:name])
  end

  # /admin/contributors/new
  def new
    @contributor = Contributor.new
    @title = admin_title
  end

  # /admin/contributors/1/edit
  def edit
    @title = admin_title(@contributor, [:id, :name])
  end

  # /admin/contributors
  def create
    @contributor = Contributor.new(contributor_params)

    if @contributor.save
      redirect_to [:admin, @contributor], notice: "Contributor was successfully created."
    else
      render :new
    end
  end

  # /admin/contributors/1
  def update
    if @contributor.update(contributor_params)
      redirect_to [:admin, @contributor], notice: "Contributor was successfully updated."
    else
      render :edit
    end
  end

  # /admin/contributors/1
  def destroy
    @contributor.destroy
    redirect_to [:admin, :contributors], notice: "Contributor was successfully destroyed."
  end

  private

  def set_contributor
    @contributor = Contributor.find(params[:id])
  end

  def contributor_params
    params.require(:contributor).permit(:name, :bio, :photo, :slug)
  end
end
