class WikiPolicy < ApplicationPolicy
  def update?
    user.admin? 
  end
end
