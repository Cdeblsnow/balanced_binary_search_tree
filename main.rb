require_relative "lib/tree"
arr = Array.new(15) { rand(1..100) }
arr2 = Array.new(15) { rand(1..100) }
tree = Tree.new(arr)

tree.build_tree
tree.pretty_print
p tree.balanced?

arr2.each { |num| tree.insert(num) }
tree.pretty_print
p tree.balanced?

tree.rebalance
tree.pretty_print
p tree.balanced?
