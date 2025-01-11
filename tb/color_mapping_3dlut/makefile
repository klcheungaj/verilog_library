
.PHONY: gen build run view clean

CD = 8
GS = 33
LUT_CD = 8
cubedir = ../cubes/33
imagedir = ../images

ifeq ($(trace),on)
CMAKE_VAR += -DTRACE_FLAG=true -DCD=$(CD) -DGS=$(GS) -DLUT_CD=$(LUT_CD)
else
CMAKE_VAR += -DTRACE_FLAG=false -DCD=$(CD) -DGS=$(GS) -DLUT_CD=$(LUT_CD)
endif 

gen:
	cmake -Bbuild -G Ninja -DCMAKE_BUILD_TYPE=Release  $(CMAKE_VAR)

build: gen
	cmake --build build -j16

run: CMAKE_VAR += -DTRACE_FLAG=false
run: build
	cd ./build ; ./Vout +imagedir+$(imagedir) +cubedir+$(cubedir)

run_trace: CMAKE_VAR += -DTRACE_FLAG=true 
run_trace: build
	-cd ./build ; ./Vout +trace

view: run_trace
	-cd ./build/logs ; gtkwave wave.fst --save=../../cfg.gtkw

clean: 
	rm -r build
