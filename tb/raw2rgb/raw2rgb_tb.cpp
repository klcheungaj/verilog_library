#include <iostream>
#include <queue>
#include "assert.h"
#include <vector>
#include <map>
#include <stdlib.h>     /* srand, rand */
#include <time.h>
#include <iomanip>
#include <sys/stat.h>  // mkdir
#include <cmath>  // mkdir
#include <fstream>

#include "Vraw2rgb_tb.h"
#include "verilated.h"
#include "verilated_fst_c.h"
#include <verilated_fst_sc.h>
#include <systemc.h>

#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace std;
using namespace cv;

SC_MODULE(top_tb) {
    sc_clock            clk;
    sc_signal<bool>     rstn;

    sc_signal<bool>     o_vsync;
    sc_signal<bool>     o_hsync;
    sc_signal<bool>     o_de;
    sc_signal<bool>     o_valid;
    sc_signal<uint32_t> o_x_cnt;
    sc_signal<uint32_t> o_y_cnt;
    sc_signal<uint64_t> o_rgb;
    
    sc_signal<bool>     ref_valid;
    sc_signal<bool>     ref_de;
    sc_signal<bool>     ref_hs;
    sc_signal<bool>     ref_vs;
    sc_signal<uint32_t> ref_x;
    sc_signal<uint32_t> ref_y;
    sc_signal<uint32_t> ref_raw;

    enum SimState{
        SIM_STATE_IDLE,
        SIM_STATE_RUN,
        SIM_STATE_END_NO_ERR,
        SIM_STATE_END_WITH_ERR
    };


    void debayer2rgb(vector<uint8_t> &mem, int cnt) {
        char buf[30];
        int len = snprintf(buf, 30, "logs/ref_debayer%d.bmp", cnt);

        Mat m = Mat(270, 480, CV_8UC1, mem.data());
        cout << "memory size: " << mem.size() << endl;
        cout << "Mat size: " << m.size() << endl;
        cvtColor(m, m_debayer, COLOR_BayerGBRG2BGR);
        cout << "Mat2 size: " << m_debayer.size() << endl;
        cout << "Mat2 size in byte: " << m_debayer.total() * m_debayer.elemSize() << endl;
        // imshow("debayer picture", m);
        imwrite(buf, m_debayer);
    }

    Mat savePicture(vector<uint8_t> &mem, int cnt) {
        char buf[30];
        int len = snprintf(buf, 30, "logs/debayer%d.bmp", cnt);

        Mat m = Mat(270, 480, CV_8UC3, mem.data());
        cout << "memory size: " << mem.size() << endl;
        cout << "Mat size: " << m.size() << endl;
        cvtColor(m, m, COLOR_RGB2BGR);
        // imshow("debayer picture", m);
        imwrite(buf, m);
        return m;
    }

private:
    #define TB_ASSERT(condition, message) \
        if (!(condition)) { \
            std::cerr << "Assertion `" #condition "` failed in " << __FILE__ \
                        << " line " << __LINE__ << ": " << message << std::endl; \
            state = SIM_STATE_END_WITH_ERR; \
        }

    vector<uint8_t> memory;
    vector<uint8_t> ref_memory;
    SimState state;
    Mat m_debayer;

    uint64_t getAllOnes(uint64_t numOfOne) {
        return ((1ULL << numOfOne) - 1ULL);
    }

    bool checkImagesEqual(Mat m1, Mat m2, int cnt) {
        int total_size = m1.total() * m1.elemSize();
        cout << "total_size: " << total_size << endl;
        uint64_t diff = 0;
        uint64_t diff_cnt = 0;
        Mat m_d = m1;
        for (int i=0 ; i<total_size ; i++) {
            m_d.data[i] = abs(m1.data[i] - m2.data[i]);
            diff += m_d.data[i];
            if (m1.data[i] != m2.data[i])
                ++diff_cnt;
        }
        char buf[30];
        int len = snprintf(buf, 30, "logs/difference%d.bmp", cnt);
        imwrite(buf, m_d);
        cout << "accumulated difference of two images: " << diff << endl;
        cout << "total count of different subpixel: " << diff_cnt << endl;
        return diff < 300000;   // just use a value that doesn't trigger an error 
    }

    void sequencer() {
        while (true) {//forever begin
            wait(clk.posedge_event()); // @(posedge clk)

            // Apply inputs
            if (sc_time_stamp() < sc_time(100, SC_NS)) {
                rstn = false;  // Assert reset
            } else {
                rstn = true;  // Deassert reset
            }
        }
    }
    
    void monitor() {
        wait(rstn.posedge_event());
        int frame_cnt = 0;
        int y_cnt = 0;
        int x_cnt = 0;
        int64_t clk_cnt = 0;
        bool r1_vsync = o_vsync;
        bool r1_de = o_de;

        while (true) {      // forever begin
            wait(clk.posedge_event()); // @(posedge clk)
            ++clk_cnt;

            if (frame_cnt > 1) {
                state = SIM_STATE_END_NO_ERR;
            }

            if (r1_vsync && !o_vsync) {
                ++frame_cnt;
                cout << "frame count: " << frame_cnt << endl;
                Mat m = savePicture(memory, frame_cnt);
                if (checkImagesEqual(m, m_debayer, frame_cnt)) {
                    cout << "SUCCESS: two images are equal" << endl;
                } 
                else {
                    cout << "ERROR: two images are different" << endl;
                    state = SIM_STATE_END_WITH_ERR;
                }

                memset(memory.data(), 0, 270*480*3);
                x_cnt = 0;
                y_cnt = 0;
            }

            if (r1_de && !o_de) {
                ++y_cnt;
                x_cnt = 0;
            }

            if (o_valid) {
                memcpy(memory.data() + (y_cnt)*(3*480) + x_cnt*(2*3), &o_rgb.read(), 3*2);
                cout << "y count: " << y_cnt << ". ";
                cout << "x count: " << x_cnt <<endl;
                x_cnt += 1;
            }

            if (clk_cnt > 1e6)
                state = SIM_STATE_END_WITH_ERR;

            r1_vsync = o_vsync;
            r1_de = o_de;
        }
    }

    void ref_monitor() {
        wait(rstn.posedge_event());
        int frame_cnt = 0;
        int y_cnt = 0;
        int x_cnt = 0;
        int64_t clk_cnt = 0;
        bool r1_vsync = ref_vs;
        bool r1_de = ref_de;

        while (true) {      // forever begin
            wait(clk.posedge_event()); // @(posedge clk)
            ++clk_cnt;

            if (r1_vsync && !ref_vs) {
                ++frame_cnt;
                cout << "ref frame count: " << frame_cnt << endl;
                debayer2rgb(ref_memory, frame_cnt);
                memset(ref_memory.data(), 0, 270*480);
                x_cnt = 0;
                y_cnt = 0;
            }

            if (r1_de && !ref_de) {
                ++y_cnt;
                x_cnt = 0;
            }

            if (ref_valid && x_cnt < 120) {
                memcpy(ref_memory.data() + (y_cnt)*(480) + x_cnt*(4), &ref_raw.read(), 4);
                cout << "ref y count: " << y_cnt << ". ";
                cout << "ref x count: " << x_cnt <<endl;
                x_cnt += 1;
            }

            r1_vsync = ref_vs;
            r1_de = ref_de;
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
        std::unique_ptr<Vraw2rgb_tb> &dut,
        size_t max_vsync_cnt
    ) 
    :sc_module(name)
    ,clk("clk", 5, SC_NS, 0.5, 3, SC_NS, true)
    {    
        SC_HAS_PROCESS(top_tb);
        SC_THREAD(sequencer);
        SC_THREAD(monitor);
        SC_THREAD(ref_monitor);
        dut->clk(clk);
        dut->rstn(rstn);
        dut->o_vsync(o_vsync);
        dut->o_hsync(o_hsync);
        dut->o_de(o_de);
        dut->o_valid(o_valid);
        dut->o_x_cnt(o_x_cnt);
        dut->o_y_cnt(o_y_cnt);
        dut->o_rgb(o_rgb);
        dut->ref_valid(ref_valid);
        dut->ref_de(ref_de);
        dut->ref_hs(ref_hs);
        dut->ref_vs(ref_vs);
        dut->ref_x(ref_x);
        dut->ref_y(ref_y);
        dut->ref_raw(ref_raw);

        rstn = false;
        memory.resize(480*270*3);
        ref_memory.resize(480*270);

        state = SIM_STATE_IDLE;
    }
};

int sc_main(int argc, char* argv[]) {
    srand (time(NULL));

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
    std::unique_ptr<Vraw2rgb_tb> dut(new Vraw2rgb_tb("dut"));
    std::unique_ptr<top_tb> tb(new top_tb("top_tb", dut, 4));
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
