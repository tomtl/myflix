module ApplicationHelper
  def stars_list
    [5,4,3,2,1].map { |number| [pluralize(number, "Star")] }
  end
end
