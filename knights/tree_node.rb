class PolyTreeNode
  attr_reader :parent, :children, :value

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent=(node)
    # Remove from old parent node
    if parent != nil
        @parent.children.delete_if { |sibling| sibling == self }
    end

    # Assign new parent node
    @parent = node
    return if node == nil
    node.children << self if !node.children.include?(self)
  end

  def add_child(child_node)
    @children << child_node
    child_node.parent = self
  end

  def remove_child(child_node)
    child_node.parent = nil
    raise "Not a child node" unless self.children.include?(child_node)
  end

  def dfs(target_value)
    return self if @value == target_value
    @children.each do |child|
      node = child.dfs(target_value)
      return node if node != nil
    end
    return nil
  end

  def bfs(target_value)
    queue = [self]
    while !queue.empty?
      # Get a node from the queue and process it
      node = queue.shift
      return node if node.value == target_value

      # Push the node's children if it isn't the target
      queue += node.children
    end
    return nil
  end
end