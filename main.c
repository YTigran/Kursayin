#include <stdio.h>
#include <stdlib.h>

int binary_search(int* arr, int size, int target) {
	int left = 0;
	int right = size - 1;
	int mid;

	while (left <= right)
	{
		mid = left + (right - left) / 2;
		if (target == arr[mid])
			return mid;
		else if (target > arr[mid])
			left = mid + 1;
		else
			right = mid - 1;
	}
	return -1;
}

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
}

int* input_arr(int* target, int* size) {
	my_scanf("Input the size of array: ", size);
	int* arr = (int*)malloc(sizeof(int) * (*size));

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

	return arr;
}

int main () {
	int target;
	int size;
	int* arr = input_arr(&target, &size);
	
	int target_index = binary_search(arr, size, target);
	if (target_index == -1)
		printf("There is no such value in array (%d)\n", target);
	else
		printf("index: %d - arr[index]: %d\n", target_index, arr[target_index]);
	free(arr);
}