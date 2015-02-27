#include <stdlib.h>
#include "bstree.h"

bstree* init_bstree()
{
  bstree *tree = malloc(sizeof(bstree));
  tree->root = NULL;
  tree->count = 0;
  return tree;
}
static void destory_bstree_node(bstree_node *node)
{
  if (node == NULL) return;
  destory_bstree_node(node->left);
  destory_bstree_node(node->right);
  free(node);
}
void destory_bstree(bstree *tree)
{
  destory_bstree_node(tree->root);
  free(tree);
}
/*
 * 中序遍历
 */
void inorder(bstree_node *node, void (*action_func)(bstree_node *))
{
  if (node == NULL) return;
  inorder(node->left, action_func);
  action_func(node);
  //printf("%d\n", node->key);
  inorder(node->right, action_func);
}

void insert_node(bstree *tree, int key)
{
  bstree_node
    *node = malloc(sizeof(bstree_node)), // new node
    *current = tree->root, // current node
    *parent = NULL; // current node's parent
  node->key = key;
  node->left = NULL;
  node->right = NULL;
  node->parent = NULL;
  while (current != NULL) { // only insert after leaf node
    parent = current;
    if (current->key == key) return; // has this key, return
    else if (current->key > key) current = current->left; // too small, to left substree
    else current = current->right; // too large, to right substree
  }
  node->parent = parent;
  if (parent == NULL) tree->root = node; // empty tree
  else if (parent->key > key) parent->left = node;
  else parent->right = node;
}

bstree_node* search(bstree *tree, int key)
{
  bstree_node *current = tree->root;
  while (current != NULL && current->key != key) {
    if (current->key > key)
      current = current->left;
    else
      current = current->right;
  }
  return current;
}

bstree_node* search_min(bstree_node *node)
{
  if (node == NULL) return NULL;
  while (node->left != NULL) node = node->left;
  return node;
}

bstree_node* search_max(bstree_node *node)
{
  if (node == NULL) return NULL;
  while (node->right != NULL) node = node->right;
  return node;
}

bstree_node* search_succssor(bstree_node *node)
{
  if (node == NULL) return NULL;
  // has right subtree
  // return min node in right subtree
  if (node->right != NULL)
    return search_min(node->right);
  // without right subtree
  // find nearest parent node which belong to it's left subtree
  bstree_node *parent = node->parent;
  while (parent != NULL && parent->right == node) {
    node = parent;
    parent = node->parent;
  }
  return parent;
}

bstree_node* search_predecessor(bstree_node *node)
{
  if (node == NULL) return NULL;
  // has left subtree
  // return max node in left subtree
  if (node->left != NULL)
    return search_max(node->left);
  // without left subtree
  // find nearest parent node which belong to it's right subtree
  bstree_node *parent = node->parent;
  while (parent != NULL && parent->left == node) {
    node = parent;
    parent = node->parent;
  }
  return parent;
}

void delete_node(bstree *tree, int key)
{
  bstree_node *node = search(tree, key);
  if (node == NULL) return;
  // find the node to del
  bstree_node *node_to_del = (node->left == NULL || node->right == NULL)
    ? node
    : search_succssor(node);
  // find a child node for fix relationship
  bstree_node *child = node_to_del->left == NULL
    ? node_to_del->right : node_to_del->left;
  // finx child to new parent relationship
  if (child != NULL)
    child->parent = node_to_del->parent;
  if (node_to_del->parent == NULL) // empty tree after del
    tree->root = NULL;
  else if (node_to_del->parent->left == node_to_del) // del node is left child
    node_to_del->parent->left = child;
  else // del node is right child
    node_to_del->parent->right = child;
  // keep the key by node
  if (node != node_to_del)
    node->key = node_to_del->key;
  free(node_to_del);
}
