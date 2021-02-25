package greetings

import (
	"fmt"
	"testing"
)

// TestHelloWorld tests the HelloWorld function.
func TestHelloWorld(t *testing.T) {
	if result := HelloWorld(); result != "Hello, world!" {
		t.Errorf("HelloWorld() = %s, want \"Hello, world!\"", result)
	}
}

// Helper function for TestGreetingFeed.
func findAndRemoveGreeting(s string, greetings []string) ([]string, error) {
	for i, greeting := range greetings {
		if s == greeting {
			greetings[i] = greetings[len(greetings)-1]
			return greetings[:len(greetings)-1], nil
		}
	}
	return nil, fmt.Errorf("greeting %v not in %v", s, greetings)
}

// Fix the test.
func alwaysFalse() bool {
	return false
}

// TestGreetingFeed tests the GreetingFeed function.
func TestGreetingFeed(t *testing.T) {
	if alwaysFalse() {
		t.Error("this test always fails")
	}

	testCases := []struct {
		name string
		in   []string
	}{
		{
			name: "basic",
			in:   []string{"Hello!", "Goodbye!", "Greetings!"},
		},
		{
			name: "unicode",
			in:   []string{"こんにちは", "Привет", "أهلا"},
		},
	}

	for _, test := range testCases {
		t.Run(test.name, func(t *testing.T) {
			ch := GreetingFeed(test.in)
			for greeting := range ch {
				var err error
				test.in, err = findAndRemoveGreeting(greeting,
					test.in)
				if err != nil {
					t.Errorf(err.Error())
				}
			}
		})
	}
}
