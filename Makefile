BUILD_DIR=static
SOURCE_DIR=source

NODE_BINARIES=node_modules/.bin

PUG=$(NODE_BINARIES)/pug
PUG_FLAGS=--pretty
PUG_FILES=$(shell find "$(SOURCE_DIR)/views" -maxdepth 1 -type f -name "*.pug")
PUG_INCLUDES=$(shell find $(SOURCE_DIR)/views/includes $(SOURCE_DIR)/views/layouts -type f -name "*.pug")
HTML_FILES=$(patsubst $(SOURCE_DIR)/views/%.pug, $(BUILD_DIR)/%.html, $(PUG_FILES))

SCSS=$(NODE_BINARIES)/node-sass
SCSS_FLAGS=--include-path node_modules/normalize.css/ \
	   --include-path node_modules/include-media/dist/
SCSS_FILES=$(shell find $(SOURCE_DIR)/css -type f -name "*.scss")
CSS_MIN=$(BUILD_DIR)/stylesheets/min.css

RESUME=$(BUILD_DIR)/resume.pdf

all: node_modules/.yarn-integrity $(HTML_FILES) $(CSS_MIN) $(RESUME)

$(BUILD_DIR)/%.html: $(SOURCE_DIR)/views/%.pug $(PUG_INCLUDES)
	$(PUG) $(PUG_FLAGS) $< -o $(BUILD_DIR)

$(CSS_MIN): $(SCSS_FILES)
	mkdir -p $(dir $@)
	$(SCSS) $(SCSS_FLAGS) $(SOURCE_DIR)/css/site.scss > $@

$(RESUME): $(SOURCE_DIR)/resume.pdf
	cp $< $@

node_modules/.yarn-integrity: package.json
	yarn install

.PHONY: clean
clean:
	rm -rf node_modules
	rm -rf $(BUILD_DIR)
