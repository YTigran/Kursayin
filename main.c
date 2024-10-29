#include "helpers.c"

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

int main () {
	int target;
	int size;
	input_arr(&target, &size);
	
	int target_index = binary_search(arr, size, target);
	if (target_index == -1)
		printf("There is no such value in array (%d)\n", target);
	else
		printf("index: %d - arr[index]: %d\n", target_index, arr[target_index]);
}
