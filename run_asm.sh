nasm -f elf64 -o test.o test.s &&
echo "File compiled" &&
gcc -c helpers.c -o helpers.o &&
gcc -o test test.o helpers.o -no-pie -lc &&
echo "File linked" &&
echo "---------- Execution output -----------" &&
./test
