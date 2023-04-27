class UnlocksController < Devise::UnlocksController
  protected

  def after_unlock_path_for(_resource)
    root_path
  end
end
