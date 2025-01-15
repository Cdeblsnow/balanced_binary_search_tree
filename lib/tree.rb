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

  def pretty_print(node = @root, prefix = "", is_left = true)
    pretty_print(node.right_children, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_children
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data_attribute}"
    pretty_print(node.left_children, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_children
  end
end
