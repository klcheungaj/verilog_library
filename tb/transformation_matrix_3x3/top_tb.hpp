
#pragma once

#include <iostream>
#include <queue>
#include "assert.h"
#include <stdlib.h>     /* srand, rand */
#include <time.h>
#include <iomanip>
#include <cmath>  
#include <fstream>

#include <systemc.h>

#include "Vdut.h"

#ifndef IDW      //may be defined in makefile
    #define IDW (8)
#endif

#ifndef ODW      //may be defined in makefile
    #define ODW (8)
#endif

#ifndef MIDW      //may be defined in makefile
    #define MIDW (2)
#endif

#ifndef MFDW      //may be defined in makefile
    #define MFDW (8)
#endif

#define MDW (MIDW + MFDW)

using namespace std;

SC_MODULE(top_tb) {
    sc_clock                        clk;
    sc_signal<bool>                 rstn;
    sc_signal<bool>                 in_valid;
    sc_signal<bool>                 out_valid;
    sc_signal<uint32_t>             din;
    sc_signal<uint32_t>             dout;
    sc_signal<sc_dt::sc_bv<72> >    matrix;


    enum SimState{
        SIM_STATE_IDLE,
        SIM_STATE_RUN,
        SIM_STATE_END_NO_ERR,
        SIM_STATE_END_WITH_ERR
    };


private:
    SimState state;
    queue<uint32_t> q_din;
    queue<uint32_t> q_matrix;

    #define TB_ASSERT(condition, message) \
        if (!(condition)) { \
            cerr << sc_time_stamp() << ":  " << "Assertion `" #condition "` failed in " << __FILE__ \
                        << " line " << __LINE__ << ": " << message << endl; \
            state = SIM_STATE_END_WITH_ERR; \
        }

    uint64_t getAllOnes(uint64_t numOfOne) {
        return ((1ULL << numOfOne) - 1ULL);
    }


    void sequencer() {
        while (true) {//forever begin
            wait(clk.posedge_event()); // @(posedge clk)
            if (sc_time_stamp() < sc_time(100, SC_NS)) {
                rstn = false;  // Assert reset
                in_valid = 0;
                din = 0;
                matrix = sc_bv<72>(0);
            } else if (sc_time_stamp() < sc_time(120, SC_NS)) {
                rstn = true;    // deassert reset
            } else {
                uint32_t data = (rand() % (1<<IDW));
                sc_bv<MDW> tmp_m[9]; 
                in_valid = 0;
                for (int i=0 ; i<9 ; ++i) {
                    tmp_m[i] = (rand() % (1<<MDW));
                }
                matrix = (tmp_m[8], tmp_m[7], tmp_m[6], tmp_m[5]
                            , tmp_m[4], tmp_m[3], tmp_m[2], tmp_m[1]
                            , tmp_m[0]);
                
            }
        }
    }
    
    void monitor() {
        wait(rstn.posedge_event());

        while (true) {      // forever begin
            wait(clk.posedge_event()); // @(posedge clk)
        }
    }

public:
    bool has_error() const {
        return state == SIM_STATE_END_WITH_ERR;
    }

    bool is_simulation_end() const {
        return state == SIM_STATE_END_NO_ERR || state == SIM_STATE_END_WITH_ERR;
    }

    void print_result() const {
        cout << "--------------------printing final result----------------\r\n";
    }
    
    top_tb (
        const sc_module_name name,
        unique_ptr<Vdut> &dut
    ) 
    :sc_module(name)
    ,clk("clk", 5, SC_NS, 0.5, 3, SC_NS, true)
    {    
        SC_HAS_PROCESS(top_tb);
        SC_THREAD(sequencer);
        SC_THREAD(monitor);
        dut->clk(clk);
        dut->rstn(rstn);
        dut->in_valid(in_valid);
        dut->out_valid(out_valid);
        dut->din(din);
        dut->dout(dout);
        dut->matrix(matrix);
        rstn = false;
        state = SIM_STATE_IDLE;
    }
};
