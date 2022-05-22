.PHONY: format clean all

all: build/linux/downfall.bin build/windows/downfall.exe build/html5/downfall.html

build/linux/downfall.bin:
	mkdir -p build/linux
	godot --no-window --export "Linux" build/linux/downfall.bin

build/windows/downfall.exe:
	mkdir -p build/windows
	godot --no-window --export "Windows" build/windows/downfall.exe

build/html5/downfall.html:
	mkdir -p build/html5
	godot --no-window --export "HTML5" build/html5/downfall.html

clean:
	rm -rf build

format:
	find . -name '*.gd' -print0 | xargs -0 -P $(nproc) gdformat
