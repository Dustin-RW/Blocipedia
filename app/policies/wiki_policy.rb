class WikiPolicy < ApplicationPolicy

  def update?
    user.premium? || user.admin?
  end
end
