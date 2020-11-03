SOURCE:=$(shell fd --type=file)

public: $(SOURCE)
	zola build

clean:
	rm -rf public
