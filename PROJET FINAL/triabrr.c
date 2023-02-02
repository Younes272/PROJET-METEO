#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENGTH 1024

typedef struct csv_line {
  char *line;
  char *sort_column;
  struct csv_line *left;
  struct csv_line *right;
} csv_line_t;

csv_line_t *new_csv_line(char *line) {
  char *sort_column = strdup(line);
  char *token = strtok(sort_column, ",");
  csv_line_t *csv_line = malloc(sizeof(csv_line_t));
  csv_line->line = line;
  csv_line->sort_column = sort_column;
  csv_line->left = NULL;
  csv_line->right = NULL;
  return csv_line;
}

void free_csv_line(csv_line_t *csv_line) {
  free(csv_line->sort_column);
  free(csv_line->line);
  free(csv_line);
}

int compare_csv_lines(const csv_line_t *a, const csv_line_t *b) {
  return strcmp(a->sort_column, b->sort_column);
}

csv_line_t *insert_csv_line(csv_line_t *root, csv_line_t *csv_line) {
  if (!root) {
    return csv_line;
  }
  if (compare_csv_lines(csv_line, root) < 0) {
    root->left = insert_csv_line(root->left, csv_line);
  } else {
    root->right = insert_csv_line(root->right, csv_line);
  }
  return root;
}

void print_csv_line(FILE *fp, const csv_line_t *csv_line) {
  fprintf(fp, "%s", csv_line->line);
}

void inorder_traverse(FILE *fp, csv_line_t *root) {
  if (!root) {
    return;
  }
  inorder_traverse(fp, root->left);
  print_csv_line(fp, root);
  inorder_traverse(fp, root->right);
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("Usage: %s <csv_file>\n", argv[0]);
    return 1;
  }

  char *filename = argv[1];
  FILE *fp = fopen(filename, "r");
  if (!fp) {
    printf("Error opening file: %s\n", filename);
    return 1;
  }

  csv_line_t *root = NULL;

  char *line = NULL;
  size_t line_length = 0;
  while (getline(&line, &line_length, fp) >= 0) {
    csv_line_t *csv_line = new_csv_line(line);
    root = insert_csv_line(root, csv_line);
    line = NULL;
  }
  free(line);

  fclose(fp);

  FILE *out_fp = fopen("sorted.csv", "w");
  if (!out_fp) {
    printf("Error opening output file: sorted.csv\n");
    return 1;
  }

  inorder_traverse(out_fp, root);
  fclose(out_fp);

  return 0;
}

