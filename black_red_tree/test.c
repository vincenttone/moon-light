#include <stdlib.h>
#include <stdio.h>
#include "brtree.h"

void print_node_and_children(v_br_tree *tree, v_br_node *node)
{
  char* colors[VCT_TOTAL];
  colors[VCT_RED] = "red";
  colors[VCT_BLACK] = "black";
  printf("node: %ld (%s), left: %ld (%s), right: %ld (%s)\n",
         node->key, colors[node->color],
         node->left->key, colors[node->left->color],
         node->right->key, colors[node->right->color]);
}

void print_key(v_br_tree *tree, v_br_node *node)
{
  printf("key is: %ld\n", node->key);
}

int main()
{
  const int CLEN = 11;
  v_br_tree *tree = malloc(sizeof(v_br_tree));
  v_br_node *node;
  init_tree(tree, malloc, free);
  int counts[CLEN];
  for (int i = 1; i <= CLEN; i++) {
    insert_node(tree, i);
  }
  printf("root val is %ld\n", tree->root->key);
  node = search_min(tree, tree->root);
  printf("min val is %ld\n", node->key);
  printf("max val is %ld\n", search_max(tree, tree->root)->key);
  inorder(tree, tree->root, print_key);
  preorder(tree, tree->root, print_node_and_children);
  delete_node(tree, 6);
  delete_node(tree, 2);
  delete_node(tree, 5);
  inorder(tree, tree->root, print_key);
  preorder(tree, tree->root, print_node_and_children);
  /*
  delete_node(tree, 10);
  printf("after del %d, root is: %ld\n", 10, tree->root->key);
  preorder(tree, tree->root, print_node_and_children);
  */
  free_all_node(tree);
  free(tree);
}
