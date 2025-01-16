require "rubocop"
require_relative "node"

class Tree
  def initialize(array)
    @root = nil
    @arr = array.uniq.sort
  end

  def build_tree(array = @arr, start = 0, final = @arr.length - 1)
    mid = (start + final) / 2

    return if start > final

    root = Node.new(array[mid])
    root.left_children = build_tree(array, start, mid - 1)
    root.right_children = build_tree(array, mid + 1, final)

    @root = root
  end

  def insert(value, node = @root)
    return if node.nil? || value == node.data_attribute

    insert(value, node.left_children) if node.data_attribute > value
    return node.left_children = Node.new(value) if node.left_children.nil? && node.data_attribute > value

    insert(value, node.right_children) if node.data_attribute < value
    return node.right_children = Node.new(value) if node.right_children.nil? && node.data_attribute < value # rubocop:disable Style/RedundantReturn
  end

  def delete(value, current_node = @root, parent = nil, side = "")
    return nil if current_node.nil?

    if current_node.data_attribute == value
      if current_node.right_children.nil? && current_node.left_children.nil? # first case, node with no children
        side == "r" ? parent.right_children = nil : parent.left_children = nil

      elsif (current_node.right_children.nil? && current_node.left_children) ||
            (current_node.left_children.nil? && current_node.right_children)
        delete_case_two(value, current_node, parent, side)
      else
        delete_case_three(value, current_node, parent, side)
      end
      return
    end

    delete(value, current_node.right_children, current_node, "r") if current_node.data_attribute < value
    delete(value, current_node.left_children, current_node, "l") if current_node.data_attribute > value
  end

  def delete_case_two(value, current_node, parent, side) # node with one children
    if side == "r"
      parent.right_children = current_node.right_children
    else
      parent.left_children = current_node.left_children
    end
    value
  end

  def delete_case_three(value, current_node, parent, side)
    return nil if current_node.nil?

    if current_node.data_attribute > value && current_node.left_children.nil? && side == "r"
      parent.right_children.data_attribute = current_node.data_attribute
    elsif current_node.data_attribute > value && current_node.left_children.nil? == false && side == "r"
      parent.right_children.data_attribute = current_node.left_children.data_attribute
    elsif current_node.data_attribute > value && current_node.left_children.nil? && side == "l"
      parent.left_children.data_attribute = current_node.data_attribute
    elsif current_node.data_attribute > value && current_node.left_children.nil? == false && side == "l"
      parent.left_children.data_attribute = current_node.left_children.data_attribute
    end

    delete_case_three(value, current_node.left_children, parent, side) if current_node.data_attribute > value
    delete_case_three(value, current_node.right_children, parent, side) if current_node.data_attribute <= value

    current_node
  end

  def pretty_print(node = @root, prefix = "", is_left = true)
    pretty_print(node.right_children, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_children
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data_attribute}"
    pretty_print(node.left_children, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_children
  end
end
