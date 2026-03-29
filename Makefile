DATA_FILES := $(wildcard _data/*.yml)
UID := $(shell id -u)
GID := $(shell id -g)
RUBY_IMAGE := ruby:3.3

.PHONY: serve build clean clean-latex pdf

# --- Jekyll ---

serve:
	docker run --rm --name resume -p 4000:4000 \
		-v "$(PWD)":/app -w /app $(RUBY_IMAGE) \
		sh -c "bundle install --quiet && bundle exec jekyll serve --host 0.0.0.0"

build:
	docker run --rm \
		-v "$(PWD)":/app -w /app $(RUBY_IMAGE) \
		sh -c "bundle install --quiet && bundle exec jekyll build"

# --- PDF ---

_latex/resume.tex: build_tex.py _latex/resume.tex.j2 _config.yml $(DATA_FILES)
	uv run build_tex.py

_latex/resume.pdf: _latex/resume.tex _latex/deedy-resume.cls
	docker run --rm -u $(UID):$(GID) -v "$(PWD)/_latex":/work -w /work danteev/texlive xelatex -interaction=nonstopmode resume.tex

resume.pdf: _latex/resume.pdf
	cp _latex/resume.pdf resume.pdf

pdf: resume.pdf

# --- Cleanup ---

clean-latex:
	rm -f _latex/*.aux _latex/*.log _latex/*.out _latex/resume.tex _latex/resume.pdf resume.pdf

clean: clean-latex
	rm -rf _site .sass-cache .jekyll-cache
