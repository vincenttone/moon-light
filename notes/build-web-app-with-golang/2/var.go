package main
import "fmt"

func main () {
	_, b := 34, 35
	fmt.Printf("%d\n", b)
	var c complex64 = 5+5i
	fmt.Printf("Value is: %v\n", c)
	// string
	e := "hello"
	f := []byte(e)
	f[0] = 'c'
	e2 := string(f)
	e = "c" + e[1:]
	fmt.Printf("Now e2 is %s, e is %s\n", e2, e)
	// array
	var arr [10]int
	arr[0] = 42
	arr[1] = 13
	fmt.Printf("The first element is %d\n", arr[0])
	fmt.Printf("The last element is %d\n", arr[9])
	// slice
	s0 := []byte {'a', 'b', 'c', 'd', 'e'}
	var s1,s2 []byte
	s1 = s0[2:5]
	s2 = s0[3:5]
	fmt.Printf("s1 len is %d, s2[1] is %d\n", len(s1), s2[1])
	// map
	m := make(map[string]int)
	m["one"] = 1
	m["two"] = 2
	fmt.Println("one of m is ", m["one"])
	m1 := m
	m1["one"] = 3
	fmt.Println("one of m is ", m["one"])
	fmt.Println("one of m1 is ", m1["one"])
}
