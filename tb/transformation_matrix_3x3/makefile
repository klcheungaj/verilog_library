
.PHONY: gen build run view clean

IDW=8
ODW=8
MIDW=2
MFDW=8

ifeq ($(trace),on)
CMAKE_VAR += -DTRACE_FLAG=true
else
CMAKE_VAR += -DTRACE_FLAG=false
endif 
CMAKE_VAR += -DIDW=$(IDW)
CMAKE_VAR += -DODW=$(ODW)
CMAKE_VAR += -DMIDW=$(MIDW)
CMAKE_VAR += -DMFDW=$(MFDW)

gen:
	cmake -Bbuild -G Ninja -DCMAKE_BUILD_TYPE=Release $(CMAKE_VAR)

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
