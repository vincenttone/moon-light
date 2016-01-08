#include <stdlib.h>
#include "brtree.h"

void init_tree(v_br_tree *tree, void* (*malloc_node)(size_t size), void (*free_node)(void* node))
{
  v_br_node *nil_node = malloc_node(sizeof(v_br_node));
  nil_node->color = VCT_BLACK;
  nil_node->key = 0;
  nil_node->parent = NULL;
  nil_node->left = NULL;
  nil_node->right = NULL;
  tree->root = nil_node;
  tree->NIL = nil_node;
  tree->malloc_node = malloc_node;
  tree->free_node = free_node;
}

static void destory_trees_node(v_br_tree *tree, v_br_node *node)
{
  if (tree->free_node) {
    tree->free_node(node);
  }
}

void free_all_node(v_br_tree *tree)
{
  backorder(tree, tree->root, destory_trees_node);
}
/**
 * left rorate brtree
 *
 *    x               y
 *   / \             / \
 *  a   y           x   c
 *      / \        / \
 *     b   c      a   b
 *
 * @params v_br_tree *tree
 * @params v_br_node *node
 **/
static int left_rorate(v_br_tree *tree, v_br_node *node)
{
  if (node->right == tree->NIL) {
    // without right child! can not rorate
    return 1;
  }
  // node which chanage to node position
  v_br_node *replace2_node = node->right;
  // change right child's left child to node's right child
  node->right = replace2_node->left;
  if (node->right != tree->NIL) {
    node->right->parent = node;
  }
  // change new node and it's parent relation
  replace2_node->parent = node->parent;
  if (node->parent == tree->NIL) {
    tree->root = replace2_node;
  } else if (node->parent->left == node) {
    node->parent->left = replace2_node;
  } else {
    node->parent->right = replace2_node;
  }
  // change node and new node relation
  replace2_node->left = node;
  node->parent = replace2_node;

  return 0;
}
/**
 * right rorate tree
 *
 *     x           y
 *    / \         / \
 *   y   c       a   x
 *  / \             / \
 * a   b           b   c
 *
 * @params v_br_tree *tree
 * @params v_br_node *node
 **/
static int right_rorate(v_br_tree *tree, v_br_node *node)
{
  if (node->left == tree->NIL) {
    // without left child! can not rorate
    return 1;
  }
  // the node which chanage to current node position
  v_br_node *replace2_node = node->left;
  // change left child's right child to node's left child
  node->left = replace2_node->right;
  if (node->left != tree->NIL) {
    node->left->parent = node;
  }
  // change new node and it's parent relation
  replace2_node->parent = node->parent;
  if (node->parent == tree->NIL) {
    tree->root = replace2_node;
  } else if (node->parent->left == node) {
    node->parent->left = replace2_node;
  } else {
    node->parent->right = replace2_node;
  }
  // change node and new node relation
  replace2_node->right = node;
  node->parent = replace2_node;

  return 0;
}

static void insert_fixup(v_br_tree *tree, v_br_node *node)
{
  // only fixup when parent is red
  while (node->parent->color == VCT_RED) {
    int is_left_branch = VBT_YES; // parent is left child 0, right child 1
    v_br_node *uncle;
    if (node->parent->parent->left == node->parent) {
      // parent is left child
      is_left_branch = VBT_YES;
      uncle = node->parent->parent->right;
    } else {
      is_left_branch = VBT_NO;
      uncle = node->parent->parent->left;
    }
    // cond 1: uncle is red
    if (uncle->color == VCT_RED) {
      // change parent and uncle color to black
      node->parent->color = uncle->color = VCT_BLACK;
      // change parent's parent color to red
      uncle->parent->color = VCT_RED;
      // now insert node is parent's parent
      node = uncle->parent;
    } else {
      if (is_left_branch == VBT_YES) {
        // cond 2: left branch, right child
        if (node->parent->right == node) {
          node = node->parent;
          left_rorate(tree, node);
        }
        // cond3: left branch, left child
        node->parent->color = VCT_BLACK;
        node->parent->parent->color = VCT_RED;
        right_rorate(tree, node->parent->parent);
      } else {
        if (node->parent->left == node) {
          node = node->parent;
          right_rorate(tree, node);
        }
        node->parent->color = VCT_BLACK;
        node->parent->parent->color = VCT_RED;
        left_rorate(tree, node->parent->parent);
      }
    }
  }
  tree->root->color = VCT_BLACK;
}

void insert_node(v_br_tree *tree, long key)
{
  v_br_node *node;
  node = tree->malloc_node(sizeof(v_br_node));
  node->color = VCT_RED;
  node->key = key;
  node->left = tree->NIL;
  node->right = tree->NIL;
  node->parent = tree->NIL;
  // find insert position
  v_br_node *current_node = tree->root,
    *pre_node = tree->NIL;
  while (current_node != tree->NIL) {
    pre_node = current_node;
    if (current_node->key == node->key) {
      // has this node
      return;
    } else if (node->key < current_node->key) {
      current_node = current_node->left;
    } else {
      current_node = current_node->right;
    }
  }
  node->parent = pre_node;
  if (pre_node == tree->NIL) {
    // empty tree
    tree->root = node;
  } else if (node->key < pre_node->key ) {
    // is left child
    pre_node->left = node;
  } else {
    // is right child
    pre_node->right = node;
  }
  insert_fixup(tree, node);
}

/**
 * search the needle key node
 * @params v_br_tree *tree
 * @params long key
 * @return v_br_node || NIL
 *         success: v_br_node
 *         failed: NIL
 */
v_br_node* search_node(v_br_tree *tree, long key)
{
  v_br_node *current_node = tree->root;
  while (
         current_node != tree->NIL
         && key != current_node->key
         ) {
    current_node = key < current_node->key
      ? current_node->left
      : current_node->right;
  }
  return current_node;
}
/**
 * find min node in node's sub tree
 * @params tree
 * @params node
 * @return min node
 */
v_br_node* search_min(v_br_tree *tree, v_br_node *node)
{
  if (node == tree->NIL) {
    return tree->NIL;
  }
  while (node->left != tree->NIL) {
    node = node->left;
  }
  return node;
}
/**
 * find max node int node's sub tree
 */
v_br_node* search_max(v_br_tree *tree, v_br_node *node)
{
  if (node == tree->NIL) {
    return tree->NIL;
  }
  while (node->right != tree->NIL) {
    node = node->right;
  }
  return node;
}
/**
 * find in order successor of the node in tree
 * when find in order successor:
 * print out the left node, then the right node
 * just think of this, it should be easy
 */
v_br_node* search_successor(v_br_tree *tree, v_br_node *node)
{
  if (node == tree->NIL) {
    return tree->NIL;
  }
  // has right branch
  // find the min node in right branch
  if (node->right != tree->NIL) {
    return search_min(tree, node->right);
  }
  // right branch not exists
  // cond 1: node is left child, successor is parent;
  // cond 2: node is right child, find up until match cond 1.
  v_br_node *s_node = node->parent;
  while (s_node != tree->NIL && node == s_node->right) {
    node = s_node;
    s_node = node->parent;
  }
  return node;
}

/**
 * fixup colors and struct after delete
 * @param v_br_tree
 * @param v_br_node
 * @return void
 */
static void delete_fixup(v_br_tree *tree, v_br_node *node)
{
  while (node != tree->root && node->color == VCT_BLACK) {
    int is_left_branch = node->parent->left == node
      ? VBT_YES
      : VBT_NO;
    v_br_node *brother = is_left_branch == VBT_YES
      ? node->parent->right
      : node->parent->left;
    if (brother->color == VCT_RED) {
      // when brother is red, convert to black-brother
      brother->color = VCT_BLACK;
      node->parent->color = VCT_RED;
      if (is_left_branch == VBT_YES) {
        left_rorate(tree, node->parent);
        brother = node->parent->right;
      } else {
        right_rorate(tree, node->parent);
        brother = node->parent->left;
      }
    }
    // when black-brother
    if (
        brother->left->color == VCT_BLACK
        && brother->right->color == VCT_BLACK
        ) {
      // when brother has double-black-children
      // convert to delete_fixup parent node
      brother->color = VCT_RED;
      node = node->parent;
    } else {
      if (is_left_branch == VBT_YES) {
        if (brother->right->color == VCT_BLACK) {
          // when brother has black-right-red-left-children
          // convert to brother has right-red-child
          brother->left->color = VCT_BLACK;
          brother->color = VCT_RED;
          right_rorate(tree, brother);
          brother = node->parent->right;
        }
      } else {
        if (brother->left->color == VCT_BLACK) {
          brother->right->color = VCT_BLACK;
          brother->color = VCT_RED;
          left_rorate(tree, brother);
          brother = node->parent->left;
        }
      }
      // when brother has right-red-child (in left branch)
      brother->color = node->parent->color;
      node->parent->color = VCT_BLACK;
      if (is_left_branch == VBT_YES) {
        brother->right->color = VCT_BLACK;
        left_rorate(tree, node->parent);
      } else {
        brother->left->color = VCT_BLACK;
        right_rorate(tree, node->parent);
      }
      node = tree->root;
    }
  }
  // red-black node to black
  node->color = VCT_BLACK;
}

/**
 * delete node match the key int tree
 */
void delete_node(v_br_tree *tree, long key)
{
  v_br_node *del_node = search_node(tree, key);
  if (del_node == tree->NIL) return;
  // find the real position to del
  // cond 1: only one child branch, del the node
  // cond 2: two child branch, find the successor
  v_br_node *rp_node = 
    (del_node->left == tree->NIL
     || del_node->right == tree->NIL)
    ? del_node
    : search_successor(tree, del_node);
  v_br_node *rp_child_node = 
    rp_node->left == tree->NIL
    ? rp_node->right
    : rp_node->left;
  // adjust relations
  //if (rp_child_node != tree->NIL) {
  rp_child_node->parent = rp_node->parent;
    //}
  if (rp_node->parent == tree->NIL) {
    // rp_node is root
    tree->root = rp_child_node;
  } else if (rp_node->parent->left == rp_node) {
    // rp_node is left child
    rp_node->parent->left = rp_child_node;
  } else {
    // rp_node is right child
    rp_node->parent->right = rp_child_node;
  }
  // fix the key
  if (del_node != rp_node) {
    del_node->key = rp_node->key;
  }
  // if deleted node is black, need to fixup
  if (rp_node->color == VCT_BLACK) {
    delete_fixup(tree, rp_child_node);
  }
  // delete the node
  tree->free_node(rp_node);
}

void inorder(v_br_tree *tree, v_br_node *node, void (*action_func)(v_br_tree *, v_br_node *))
{
  if (node == tree->NIL) return;
  inorder(tree, node->left, action_func);
  action_func(tree, node);
  inorder(tree, node->right, action_func);
}

void preorder(v_br_tree *tree, v_br_node *node, void (*action_func)(v_br_tree *, v_br_node *))
{
  if (node == tree->NIL) return;
  action_func(tree, node);
  preorder(tree, node->left, action_func);
  preorder(tree, node->right, action_func);
}

void backorder(v_br_tree *tree, v_br_node *node, void (*action_func)(v_br_tree *, v_br_node *))
{
  if (node == tree->NIL) return;
  preorder(tree, node->left, action_func);
  preorder(tree, node->right, action_func);
  action_func(tree, node);
}
