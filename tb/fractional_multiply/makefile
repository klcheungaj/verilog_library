
.PHONY: gen build run view clean

FACTOR=0.062745	## 16/255

ifeq ($(trace),on)
CMAKE_VAR += -DTRACE_FLAG=true -DFACTOR=$(FACTOR)
else
CMAKE_VAR += -DTRACE_FLAG=false -DFACTOR=$(FACTOR)
endif 

gen:
	cmake -Bbuild -G Ninja -DCMAKE_BUILD_TYPE=Release  $(CMAKE_VAR)

build: gen
	cmake --build build -j16

run: CMAKE_VAR += -DTRACE_FLAG=false
run: build
	cd ./build ; ./Vout

run_trace: CMAKE_VAR += -DTRACE_FLAG=true 
run_trace: build
	-cd ./build ; ./Vout +trace

view: run_trace
	-cd ./build/logs ; gtkwave wave.fst --save=../../cfg.gtkw

clean: 
	rm -r build
