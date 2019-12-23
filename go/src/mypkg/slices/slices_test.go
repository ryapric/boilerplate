package slices

import "testing"

func TestGetSlice(t *testing.T) {
	got := GetSlice()
	want := []int{1, 2, 3}
	if len(got) != len(want) {
		t.Errorf("GetSlice() returned bad length: got %d, want %d", len(got), len(want))
	}
}
