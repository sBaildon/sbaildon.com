.PHONY: release clean

release:
	zola build

clean:
	rm -rf public
