class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.global_find(id)
    case id
    when Viewer::ID
      Viewer.new
    else
      descendants.reduce(nil) { |acc, elem| acc || elem.find_by(id: id) }
    end
  end

  def graph_type
    c_name = self.class.name

    "Types::#{c_name}Type".constantize
  end
end
