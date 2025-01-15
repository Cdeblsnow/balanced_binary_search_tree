class Node
  attr_accessor :data_attribute, :right_children, :left_children

  def initialize(value)
    @data_attribute = value
    @right_children = nil
    @left_children = nil
  end
end
