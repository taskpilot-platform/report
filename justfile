src := "src/main.typ"
out_name := "DA1_23520161_TranNguyenThaiBinh_23521049_NguyenThaiGiaNguyen_SE121.Q21"

alias b := build
alias d := dev
alias dz := dev-zathura
alias f := format
alias sd := sync-diagrams

[parallel]
build: build-pdf build-html

mkdir:
    mkdir -p build

build-pdf: mkdir
    typst compile {{ src }} ./build/{{ out_name }}.pdf

build-html: mkdir
    typst compile --features html {{ src }} ./build/index.html

build-watch:
    typst watch {{ src }} ./build/{{ out_name }}.pdf

dev: mkdir
    tinymist preview {{ src }}

[unix]
preview-zathura: build-pdf
    zathura ./build/{{ out_name }}.pdf

[parallel]
[unix]
watch-preview-zathura: build-watch preview-zathura

[unix]
dev-zathura: build-pdf watch-preview-zathura

format:
    typstyle -i --line-width=80 --indent-width=2 --wrap-text ./src/

[unix]
sync-diagrams:
    ./scripts/sync-diagrams.sh

[unix]
sync-gen-mermaid:
    ./scripts/sync-gen-mermaid.sh
