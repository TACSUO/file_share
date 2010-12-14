class FileShare::ApplicationController < ApplicationController
  helper_method :has_authorization?

  private
    # Redefine this method to implement authorization
    def has_authorization?(*args)
      true
    end
  protected
  public
end
