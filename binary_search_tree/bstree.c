#include <stdlib.h>
#include <stdio.h>
#include "bstree.h"

bstree* init_bstree()
{
  bstree *tree = malloc(sizeof(bstree));
  tree->root = NULL;
  tree->count = 0;
  return tree;
}
/*
 * 中序遍历
 */
void inorder(bstree_node *node)
{
  if (node == NULL) return;
  inorder(node->left);
  printf("%d\n", node->key);
  inorder(node->right);
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
