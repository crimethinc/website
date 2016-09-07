class Admin::AdminController < ApplicationController
  before_action :authorize
  layout "admin"
end
