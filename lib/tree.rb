require "rubocop"
require_relative "node"

class Tree
  def initialize(array)
    @root = nil
    @arr = array.uniq.sort
    @find = nil
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
        delete_case_three(current_node)
      end
      return
    end

    delete(value, current_node.right_children, current_node, "r") if current_node.data_attribute < value
    delete(value, current_node.left_children, current_node, "l") if current_node.data_attribute > value
  end

  # node with one children
  def delete_case_two(value, current_node, parent, side)
    if side == "r"
      parent.right_children = current_node.right_children
    else
      parent.left_children = current_node.left_children
    end
    value
  end

  # node with two children
  def delete_case_three(current_node)
    parent = current_node
    successor = current_node.right_children

    while successor.left_children
      parent = successor
      successor = successor.left_children
    end
    current_node.data_attribute = successor.data_attribute

    if parent == current_node
      parent.right_children = successor.right_children

    else
      parent.left_children = successor.right_children
    end
  end

  def find(value, current_node = @root)
    return nil if current_node.nil?

    @find = current_node if current_node.data_attribute == value
    find(value, current_node.right_children) if current_node.data_attribute < value
    find(value, current_node.left_children) if current_node.data_attribute > value

    @find
  end

  def level_order(current_node = @root)
    arr = []
    arr += [current_node]
    while arr
      break if arr[0].nil?

      yield arr[0].data_attribute
      arr << arr[0].left_children
      arr << arr[0].right_children
      arr = arr.drop(1)
    end
  end

  def inorder(current_node = @root, arr = [], &block)
    return if current_node.nil?

    inorder(current_node.left_children, arr, &block)
    if block
      yield current_node.data_attribute
    else
      arr << current_node.data_attribute
    end
    inorder(current_node.right_children, arr, &block)

    arr if arr.nil? == false
  end

  def preorder(current_node = @root, arr = [], &block)
    return nil if current_node.nil?

    if block
      yield current_node.data_attribute
    else
      arr << current_node.data_attribute
    end
    preorder(current_node.left_children, arr, &block)
    preorder(current_node.right_children, arr, &block)

    arr if arr.nil? == false
  end

  def postorder(current_node = @root, arr = [], &block)
    return if current_node.nil?

    postorder(current_node.left_children, arr, &block)
    postorder(current_node.right_children, arr, &block)
    if block
      yield current_node.data_attribute
    else
      arr << current_node.data_attribute
    end

    arr if arr.nil? == false
  end

  def height(node, edges_to_leaf_right = 0, edges_to_leaf_left = 0, side = "")
    if node.nil? && side == "r"
      return edges_to_leaf_right
    elsif node.nil?
      return edges_to_leaf_left
    end

    left_height = height(node.left_children, edges_to_leaf_right, edges_to_leaf_left, side = "l")
    right_height = height(node.right_children, edges_to_leaf_right, edges_to_leaf_left, side = "r")

    if side == "r"
      edges_to_leaf_right += 1
    else
      edges_to_leaf_left += 1
    end
    [left_height, right_height].max + 1
  end

  def pretty_print(node = @root, prefix = "", is_left = true)
    pretty_print(node.right_children, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_children
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data_attribute}"
    pretty_print(node.left_children, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_children
  end
end
