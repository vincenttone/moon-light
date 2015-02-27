#include <stdlib.h>
#include <stdio.h>
#include "bstree.h"

void print_node_key(bstree_node *node)
{
  printf("node val is: %d\n", node->key);
}

int main()
{
  bstree* tree = init_bstree();
  insert_node(tree, 5);
  insert_node(tree, 2);
  insert_node(tree, 6);
  insert_node(tree, 1);
  insert_node(tree, 3);
  insert_node(tree, 4);
  insert_node(tree, 7);
  printf("tree's root is: %d.\n", tree->root->key);
  bstree_node *node = search(tree, 6);
  printf("node's key is: %d.\n", node->key);
  printf("inorder print out:\n");
  inorder(tree->root, print_node_key);
  printf("tree's min key is %d, max key is %d.\n",
         search_min(tree->root)->key,
         search_max(tree->root)->key
         );
  delete_node(tree, 5);
  inorder(tree->root, print_node_key);
  printf("tree's root is: %d.\n", tree->root->key);
  destory_bstree(tree);
  return 0;
}
