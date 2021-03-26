class CallSlipsController < ApplicationController

  set_access_control "view_repository" => [:generate]

  def index
  end

  def generate
    aspace_uri = params[:object_uri]
    generator = CallSlipGenerator.new(aspace_uri)
    call_slip_url = generator.generate_url
    render plain: call_slip_url
  end
end
