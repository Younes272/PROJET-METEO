#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENGTH 1024

int compare_csv_lines(const void *a, const void *b) {
  const char *ia = *(const char **)a;
  const char *ib = *(const char **)b;
  char *sa = strdup(ia);
  char *sb = strdup(ib);
  char *token_a = strtok(sa, ",");
  char *token_b = strtok(sb, ",");
  int result = strcmp(token_a, token_b);
  free(sa);
  free(sb);
  return result;
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

  char **lines = NULL;
  size_t lines_alloc = 0;
  size_t lines_count = 0;

  char *line = NULL;
  size_t line_length = 0;
  while (getline(&line, &line_length, fp) >= 0) {
    if (lines_count + 1 > lines_alloc) {
      lines_alloc = lines_alloc ? lines_alloc * 2 : 16;
      lines = realloc(lines, lines_alloc * sizeof(char *));
    }
    lines[lines_count] = line;
    line = NULL;
    lines_count++;
  }
  free(line);

  fclose(fp);

  qsort(lines, lines_count, sizeof(char *), compare_csv_lines);

  FILE *out_fp = fopen("sorted.csv", "w");
  if (!out_fp) {
    printf("Error opening output file\n");
    for (int i = 0; i < lines_count; i++) {
      free(lines[i]);
    }
    free(lines);
    return 1;
  }

  for (int i = 0; i < lines_count; i++) {
    fprintf(out_fp, "%s", lines[i]);
    free(lines[i]);
  }
  free(lines);
  fclose(out_fp);
  return 0;
}

