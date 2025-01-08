#include <iostream>
#include <queue>
#include "assert.h"
#include <queue>
#include <map>
#include <stdlib.h>     /* srand, rand */
#include <time.h>
#include <iomanip>
#include <sys/stat.h>  // mkdir
#include <cmath>  // mkdir
#include <fstream>

#include "Vtrilinear_interpolation.h"
#include "verilated.h"
#include "verilated_fst_c.h"
#include <verilated_fst_sc.h>
#include <systemc.h>

#define FW 8    //fractional part width
#ifndef CD      //may be defined in makefile
    #define CD 8
#endif
using namespace std;

SC_MODULE(top_tb) {
    sc_clock clk;
    sc_signal<bool> rstn;
    sc_signal<bool>     in_valid;
    sc_signal<uint32_t> frac_r;
    sc_signal<uint32_t> frac_g;
    sc_signal<uint32_t> frac_b;
    sc_signal<bool>     out_valid;
    sc_signal<uint32_t> out_pt;
    sc_signal<uint32_t> (pt_nbr)[8];

    enum SimState{
        SIM_STATE_IDLE,
        SIM_STATE_RUN,
        SIM_STATE_END_NO_ERR,
        SIM_STATE_END_WITH_ERR
    };


private:
    SimState state;
    queue<uint32_t> q_exp_result;
    uint32_t tmp_pt_nbr[8];

    #define TB_ASSERT(condition, message) \
        if (!(condition)) { \
            std::cerr << sc_time_stamp() << ":  " << "Assertion `" #condition "` failed in " << __FILE__ \
                        << " line " << __LINE__ << ": " << message << std::endl; \
            state = SIM_STATE_END_WITH_ERR; \
        }

    uint64_t getAllOnes(uint64_t numOfOne) {
        return ((1ULL << numOfOne) - 1ULL);
    }

    uint32_t trilinear_interp (uint32_t pt[8], float frac_r, float frac_g, float frac_b) {
        float acc[3] = {0};
        uint32_t mask = getAllOnes(CD);
        // cout << "frac_r: " << frac_r << ". frac_g: " << frac_g << ". frac_b: " << frac_b << endl; 
        for (int k=0 ; k<2 ; k++) {
            for (int j=0 ; j<2 ; j++) {
                for (int i=0 ; i<2 ; i++) {
                    // cout << "red data of index " << k*4 + j*2 + i 
                    //         << " is: " << ((pt[k*4 + j*2 + i] >> 0*8) & 0xFF) << endl; 
                    for (int ch=0 ; ch<3 ; ch++) {
                        acc[ch] += ((i*frac_r) + (1-i)*(1-frac_r) ) *
                                    ((j*frac_g) + (1-j)*(1-frac_g) ) *
                                    ((k*frac_b) + (1-k)*(1-frac_b) ) *
                                    ((pt[k*4 + j*2 + i] >> ch*CD) & mask);
                    }
                }
            }
        }
        // cout << "acc of red is: " << acc[0] << endl;
        return (int(acc[2]) & mask) << (CD*2) | (int(acc[1]) & mask) << (CD) | int(acc[0]) & mask;
    }

    bool checkResult(uint32_t expect, uint32_t receive) {
        uint32_t mask = getAllOnes(CD);
        for (int ch=0 ; ch<3 ; ch++) {
            uint32_t e_ch = ((expect >> ch*CD) & mask);
            uint32_t r_ch = ((receive >> ch*CD) & mask);
            int64_t diff = e_ch - r_ch;
            // if (diff == 1) {
            //     cout << "[Warning] difference between expected and received value is 1, which is considered as acceptable" << endl; 
            // }
            if (diff > 1) {
                return false;
            }
        }
        return true;
    }

    uint32_t gen_next_fractional() {
        int randNum = rand() % 10;
        bool isZero = randNum < 1; 
        bool isOne = randNum == 9;
        if (isZero) return 0;
        else if (isOne) return getAllOnes(FW);
        else {
            return rand() % (1 << FW);
        }
    }

    void sequencer() {
        while (true) {//forever begin
            wait(clk.posedge_event()); // @(posedge clk)
            if (sc_time_stamp() < sc_time(100, SC_NS)) {
                rstn = false;  // Assert reset
                in_valid = 0;
            } else if (sc_time_stamp() < sc_time(120, SC_NS)) {
                rstn = true;    // deassert reset
            } else {
                bool isValid = (rand() % 4) < 3;
                uint32_t tmp_frac_r = gen_next_fractional();
                uint32_t tmp_frac_g = gen_next_fractional();
                uint32_t tmp_frac_b = gen_next_fractional();
                frac_r = tmp_frac_r;
                frac_g = tmp_frac_g;
                frac_b = tmp_frac_b;
                if (isValid) {
                    in_valid = 1;
                    for (int i=0 ; i<8 ; ++i) {
                        tmp_pt_nbr[i] = (rand() % (1 << CD)) << (CD*2) | (rand() % (1 << CD)) << (CD) | (rand() % (1 << CD));
                        pt_nbr[i] = tmp_pt_nbr[i];
                    }
                    uint32_t exp_result = trilinear_interp(tmp_pt_nbr, tmp_frac_r/256.0f, 
                        tmp_frac_g/256.0f, tmp_frac_b/256.0f); 
                    q_exp_result.push(exp_result);
                } else {
                    in_valid = 0;
                }
            }
        }
    }
    
    void monitor() {
        wait(rstn.posedge_event());

        while (true) {      // forever begin
            wait(clk.posedge_event()); // @(posedge clk)
            if (out_valid) {
                TB_ASSERT(!q_exp_result.empty(), "Expect result queue is empty" << endl);
                TB_ASSERT(checkResult(q_exp_result.front(), out_pt.read()), 
                    "Value is not equal! Expect: " << hex << q_exp_result.front() 
                    << ", Receive: " << out_pt << endl);
                q_exp_result.pop();
            }
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
        std::unique_ptr<Vtrilinear_interpolation> &dut
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
        dut->frac_r(frac_r);
        dut->frac_g(frac_g);
        dut->frac_b(frac_b);
        dut->out_valid(out_valid);
        dut->out_pt(out_pt);
        for (int i = 0; i < 8; ++i) {
            dut->pt_nbr[i](pt_nbr[i]);
        }

        rstn = false;
        state = SIM_STATE_IDLE;

        cout << "Color depth is " << CD << endl;
    }
};

int sc_main(int argc, char* argv[]) {
    // srand (time(NULL));
    srand (1);

    if (false && argc && argv) {}
    Verilated::debug(0);
    Verilated::randReset(2);
#if VM_TRACE
    Verilated::traceEverOn(true);
#endif
    Verilated::commandArgs(argc, argv);
    ios::sync_with_stdio();
    Verilated::mkdir("logs");
    ofstream tb_log("logs/tb_log.txt", std::ofstream::trunc);
    streambuf *coutbuf = cout.rdbuf(); //save old buf
    cout.rdbuf(tb_log.rdbuf()); //redirect std::cout to out.txt!

    /*  instantiate dut and testbench top   */
    std::unique_ptr<Vtrilinear_interpolation> dut(new Vtrilinear_interpolation("dut"));
    std::unique_ptr<top_tb> tb(new top_tb("top_tb", dut));
    sc_core::sc_start(sc_core::SC_ZERO_TIME);

    const char* flag = nullptr;
    /*  enable tracing  */
#if VM_TRACE
    VerilatedFstSc* tfp = nullptr;
    flag = Verilated::commandArgsPlusMatch("trace");
    if (flag && 0 == strcmp(flag, "+trace")) {
        printf("Enabling waves into logs/wave.fst...\r\n");
        tfp = new VerilatedFstSc;
        dut->trace(tfp, 99);  // Trace 99 levels of hierarchy
        Verilated::mkdir("logs");
        tfp->open("logs/wave.fst");
    }
#endif

    /*  run simulation  */
    do {
        sc_start(1, SC_NS);
    } while(!Verilated::gotFinish() && !tb->is_simulation_end());
    
    if (tb->has_error()) {
        printf("[error] simulation end early due to error. Simulation time: %s\r\n", sc_time_stamp().to_string().c_str());
    } else {
        printf("[info] simulation end normally. Simulation time: %s\r\n", sc_time_stamp().to_string().c_str());
    }
    tb->print_result();
    sc_start(10, SC_NS);    // run 10ns to capture more waveform

    dut->final();
    cout.rdbuf(coutbuf); //reset to standard output again
#if VM_TRACE
    if (tfp) {
        tfp->close();
        tfp = nullptr;
    }
#endif
    // Coverage analysis (calling write only after the test is known to pass)
#if VM_COVERAGE
    VerilatedCov::write("logs/coverage.dat");
#endif

    // imshow("recover_image", recover_image);
    // waitKey(0);
    return 0;
}
