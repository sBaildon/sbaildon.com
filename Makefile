PNGS = $(wildcard static/images/*.png)
WEBPS = $(patsubst static/images/%.png, static/images/%.webp, $(PNGS))

compress: $(WEBPS)

serve:
	hugo server --buildDrafts

tailwind:
	node_modules/.bin/tailwind -i tailwind.css -o assets/main.css --watch --postcss

static/images/%.webp: static/images/%.png
	cwebp -q 100 $< -o $@

build:
	npm run build
	hugo
