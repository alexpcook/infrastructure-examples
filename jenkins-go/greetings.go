package greetings

import (
	"math/rand"
	"time"
)

func init() {
	rand.Seed(time.Now().UnixNano())
}

// HelloWorld returns the greeting "Hello, world!"
func HelloWorld() string {
	return "Hello, world!"
}

// GreetingFeed takes the slice of greetings input and sends
// the greetings in a random order on the returned channel.
func GreetingFeed(greetings []string) <-chan string {
	ch := make(chan string)
	go func() {
		for _, v := range rand.Perm(len(greetings)) {
			ch <- greetings[v]
		}
		close(ch)
	}()
	return ch
}
