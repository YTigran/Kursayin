#include <stdio.h>
#include <limits.h>

#define MAX_SIZE 20
int arr[MAX_SIZE];

void my_scanf(const char* msg, int* val) {
	int res;

	do {
		if (msg)
			printf("%s", msg);
		res = scanf("%d", val);
		if (res != 1) {
			printf("Invalid input, try again\n");
			while (getchar() != '\n');
				continue;
    	}
	} while (res != 1);
	while (getchar() != '\n');
		;
}

void input_arr(int* target, int* size) {
	do {
		my_scanf("Input the size of array ([1, 20]): ", size);
		if (*size <= 0 || *size > MAX_SIZE) {
			printf("The size must be [1, 20]\n");
			continue;
		}
	} while(*size <= 0 || *size > MAX_SIZE);

	int val;
	for (int i = 0; i < *size;) {
		printf("arr[%d] = ", i);
		my_scanf(NULL, &val);
		if (i >= 1 && val < arr[i - 1])
		{
			printf("Input greater or equal number than last one\n");
			continue;
		}
		arr[i] = val;
		++i;
	}

	my_scanf("Input the target: ", target);
}