class HomeController < ApplicationController

  def index
  end

  def subscribe
    Newsletter.home_page_email(params[:email]).deliver
    redirect_to root_path, :notice => "Thank you for your interest. We'll contact you when the beta is ready."
  end

  def payments
    redirect_to root_path && return if current_user.blank?
  end
end
