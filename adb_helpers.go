package tokyocabinet

import (
	"sort"
)

// IterKeysString is an IterKeys() helper method that returns a slice of iterated strings.
//
// NOTE: returned []string can be in arbitrary order, see IterKeysStringSorted()
func (db *ADB) IterKeysString() ([]string, error) {
	var s []string

	c, e := db.IterKeys()
	for {
		if c == nil && e == nil {
			break
		}
		select {
		case err, ok := <-e:
			if ok == false {
				e = nil
			} else {
				return nil, err
			}
		case val, ok := <-c:
			if ok == false {
				c = nil
			} else {
				s = append(s, string(val))
			}
		}
	}

	return s, nil
}

// IterKeysStringSorted is an IterKeys() helper method that returns a sorted slice of iterated strings.
func (db *ADB) IterKeysStringSorted() ([]string, error) {
	s, err := db.IterKeysString()
	if err != nil {
		return nil, err
	}

	sort.Strings(s)

	return s, nil
}
