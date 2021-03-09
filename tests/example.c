#include <stdio.h>
#include "Rmath.h"

#define LOWER_TAIL 1  // use upper_tail
#define LOG_P 0       // decimal prob not log
#define MEAN 0.0      // standard gaussian/normal
#define STDEV 1.0     // standard gaussian/normal

// Note: qnorm and qt compute the one-sided quantile. We want the two-sided
// quantile, so the probability to use is one_sided = 1 - (1 - two_sided) / 2.

int main(int argc, char *argv[]) {
  double probs[] = { // two-sided probabilities
    0.50, 0.60, 0.70, 0.80, 0.90, 0.95, 0.98, 0.99, 0.995, 0.999,
  };
  int numprobs = sizeof probs / sizeof probs[0];

  printf("%-8s", "%Conf->");
  for (int i = 0; i < numprobs; ++i) {
      printf(" %9.4f", 100 * probs[i]);
  }
  printf("\n");

  printf("%-8s", "Normal:");
  for (int i = 0; i < numprobs; ++i) {
    double prob = 1 - (1 - probs[i]) / 2;  // one-sided probability
    printf(" %9.4f", qnorm(prob, MEAN, STDEV, LOWER_TAIL, LOG_P));
  }
  printf("\n");

  printf("Student's t:\n");
  for (int n = 2; n <= 31; n++) {
    double dof = n - 1;
    printf("%7.0f ", dof);
    for (int i = 0; i < numprobs; ++i) {
      double prob = 1 - (1 - probs[i]) / 2;  // one-sided probability
      printf(" %9.4f", qt(prob, dof, LOWER_TAIL, LOG_P));
    }
    printf("\n");
  }
}
