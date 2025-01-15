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

    root = Node.new(mid)
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

  def delete(value, current_node = @root)
    return nil if current_node.nil?

    next_right_node = current_node.right_children
    next_left_node = current_node.left_children

    # first case, node with no children
    if next_right_node.data_attribute == value && next_right_node.right_children.nil? && next_right_node.left_children.nil?
      return current_node.right_children = nil

    end

    if next_left_node.data_attribute == value && next_left_node.right_children.nil? && next_left_node.left_children.nil?
      return current_node.left_children = nil

    end

    delete(value, current_node.right_children) if current_node.data_attribute < value
    delete(value, current_node.left_children) if current_node.data_attribute > value
  end

  def pretty_print(node = @root, prefix = "", is_left = true)
    pretty_print(node.right_children, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_children
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data_attribute}"
    pretty_print(node.left_children, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_children
  end
end
