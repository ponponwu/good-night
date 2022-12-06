class ResourceNotFoundError < ApplicationError
  def message
    'Resource Not Found'
  end

  def status
    :not_found
  end
end