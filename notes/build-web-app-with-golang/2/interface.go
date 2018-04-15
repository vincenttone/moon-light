package main
import "fmt"

type Human struct {
	name string
	age int
	phone string
}

type Student struct {
	Human
	school string
	loan float32
}

type Employee struct {
	Human
	company string
	money float32
}

func (h Human) SayHi() {
	fmt.Printf("Hi, I am %s you can call me on %s\n", h.name, h.phone)
}

func (h Human) Sing(lyrics string) {
	fmt.Printf("La la la la...", lyrics)
}

func (e Employee) SayHi() {
	fmt.Printf("Hi, I am %s, I work at %s. Call me on %s\n", e.name, e.company, e.phone)
}

type Men interface {
	SayHi()
	Sing(lyrics string)
}

func main() {
	mike := Student{Human{"Mike", 25, "222-222-XXX"}, "MIT", 0.00}
	paul := Student{Human{"Paul", 26, "111-222-XXX"}, "Harvard", 1000.00}
	sam := Employee{Human{"Sam", 36, "444-222-XXX"}, "Golang Inc.", 10000}
	tom := Employee{Human{"Tom", 36, "222-444-XXX"}, "Things Ltd.", 10000}

	var i Men
	i = mike
	fmt.Println("This is Mike, a student: ")
	i.SayHi()
	i.Sing("November rain")

	i = tom
	fmt.Println("This is tom, an Employee")
	i.SayHi()
	i.Sing("Born to be wild")

	fmt.Println("Let's use a slice of Men and se what happends")
	x := make([]Men, 3)
	x[0], x[1], x[2] = paul, sam, mike

	for _, value := range x {
		value.SayHi()
	}
}
