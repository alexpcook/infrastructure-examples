package greetings

import (
	"testing"
)

func TestHelloWorld(t *testing.T) {
	if result := HelloWorld(); result != "Hello, world!" {
		t.Errorf("HelloWorld() = %s, want \"Hello, world!\"", result)
	}
}
