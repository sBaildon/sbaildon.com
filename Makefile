PNGS = $(wildcard static/images/*.png)
WEBPS = $(patsubst static/images/%.png, static/images/%.webp, $(PNGS))

compress: $(WEBPS)

serve:
	hugo server -D

static/images/%.webp: static/images/%.png
	cwebp -q 100 $< -o $@
