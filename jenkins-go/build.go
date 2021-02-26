package main

import (
	"math/rand"
	"os"
	"time"
)

func init() {
	rand.Seed(time.Now().UnixNano())
}

func trueOrFalse() bool {
	return []bool{true, false}[rand.Intn(2)]
}

// Simulate a flaky build that has a 50% chance of failing.
func main() {
	if trueOrFalse() {
		os.Exit(1)
	}
}
