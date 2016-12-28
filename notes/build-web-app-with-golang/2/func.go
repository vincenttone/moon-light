package main
import "fmt"

func add1(a *int) int {
	*a = *a + 1
	return *a
}

type testInt func(int) bool

func isOdd(interger int) bool {
	if interger % 2 == 0 {
		return false
	}
	return true
}

func isEven(integer int) bool {
	if integer % 2 == 0 {
		return true
	}
	return false
}

func filter(slice []int, f testInt) []int {
	var result []int
	for _, value := range slice {
		if f(value) {
			result = append(result, value)
		}
	}
	return result
}

func main() {
	// pointer
	x := 3
	fmt.Println("x = ", x)
	x1 := add1(&x)

	fmt.Println("x+1 = ", x1)
	fmt.Println("x = ", x)
	// functinal program
	slice := []int {1,2,3,4,5,6,7}
	fmt.Println("slice = ", slice)
	odd := filter(slice, isOdd)
	fmt.Println("Odd elements of slice area: ", odd)
	even := filter(slice, isEven)
	fmt.Println("Even elements of slice area: ", even)
}
