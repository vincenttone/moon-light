#ifndef _BSTREE_H
#define _BSTREE_H 1

typedef struct bstree_node {
  int key;
  struct bstree_node *parent;
  struct bstree_node *left;
  struct bstree_node *right;
} bstree_node;

typedef struct bstree {
  bstree_node *root;
  int count;
} bstree;

bstree* init_bstree();
void inorder(bstree_node *node);
void insert_node(bstree *tree, int key);

#endif
