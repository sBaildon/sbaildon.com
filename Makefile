PNGS = $(wildcard static/images/*.png)
WEBPS = $(patsubst static/images/%.png, static/images/%.webp, $(PNGS))

compress: $(WEBPS)

serve:
	hugo server --buildDrafts --bind="0.0.0.0"

tailwind:
	node_modules/.bin/tailwind -i tailwind.css -o assets/main.css --watch --postcss

static/images/%.webp: static/images/%.png
	cwebp -q 100 $< -o $@

build:
	npm run build
	hugo
