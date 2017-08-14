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

JS_FILES=$(shell find "$(SOURCE_DIR)/js" -maxdepth 1 -type f -name "*.js")
JS_OUT=$(patsubst $(SOURCE_DIR)/js/%.js, $(BUILD_DIR)/js/%.js, $(JS_FILES))

FONT_FILES=$(shell find "$(SOURCE_DIR)/fonts" -maxdepth 1 -type f)
FONT_OUT=$(patsubst $(SOURCE_DIR)/fonts/%, $(BUILD_DIR)/fonts/%, $(FONT_FILES))

all: node_modules/.yarn-integrity $(HTML_FILES) $(CSS_MIN) $(JS_OUT) $(FONT_OUT)

$(BUILD_DIR)/%.html: $(SOURCE_DIR)/views/%.pug $(PUG_INCLUDES)
	$(PUG) $(PUG_FLAGS) $< -o $(BUILD_DIR)

$(CSS_MIN): $(SCSS_FILES)
	mkdir -p $(dir $@)
	$(SCSS) $(SCSS_FLAGS) $(SOURCE_DIR)/css/site.scss > $@

$(BUILD_DIR)/js/%.js: $(SOURCE_DIR)/js/%.js
	mkdir -p $(dir $@)
	cp $< $@

$(BUILD_DIR)/fonts/%: $(SOURCE_DIR)/fonts/%
	mkdir -p $(dir $@)
	cp $< $@

node_modules/.yarn-integrity: package.json
	yarn install

.PHONY: devserver
devserver:
	$(eval IP_ADDR := $(shell ip route get 8.8.8.8 | awk '{print $$NF; exit}'))
	devd --address $(IP_ADDR) -ol static/

.PHONY: clean
clean:
	rm -rf node_modules
	rm -rf $(BUILD_DIR)
