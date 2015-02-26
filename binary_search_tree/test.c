#include <stdlib.h>
#include "bstree.h"

int main()
{
  bstree* tree = init_bstree();
  insert_node(tree, 1);
  insert_node(tree, 8);
  insert_node(tree, 6);
  insert_node(tree, 11);
  inorder(tree->root);
  free(tree);
  return 0;
}
