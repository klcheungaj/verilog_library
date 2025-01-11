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
#include <sstream>
#include <filesystem>

#include "Vcolor_mapping_3dlut.h"
#include "verilated.h"
#include "verilated_fst_c.h"
#include <verilated_fst_sc.h>
#include <systemc.h>

#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#ifndef CD      //may be defined in makefile
    #define CD 8
#endif
#ifndef LUT_CD      //may be defined in makefile
    #define LUT_CD 8
#endif
#ifndef GS      //may be defined in makefile
    #define GS 33
#endif
using namespace std;
using namespace cv;
namespace fs = std::filesystem;

SC_MODULE(top_tb) {
    sc_clock p_clk;
    sc_signal<bool> p_rstn;
    sc_signal<bool> i_hs;
    sc_signal<bool> i_vs;
    sc_signal<bool> i_de;
    sc_signal<bool> i_valid;
    sc_signal<uint64_t> i_data;
    sc_signal<bool> o_hs;
    sc_signal<bool> o_vs;
    sc_signal<bool> o_de;
    sc_signal<bool> o_valid;
    sc_signal<uint64_t> o_data;
    sc_signal<bool> i_cfg_valid;
    sc_signal<bool> i_cfg_last;
    sc_signal<uint32_t> i_cfg_data;

    enum SimState{
        SIM_STATE_IDLE,
        SIM_STATE_RUN,
        SIM_STATE_END_NO_ERR,
        SIM_STATE_END_WITH_ERR
    };


private:
    SimState state;
    Mat image;
    Mat image_out;
    string imagedir;
    string cubedir;
    string image_name;
    string lut_name;

    #define TB_ASSERT(condition, message) \
        if (!(condition)) { \
            std::cerr << sc_time_stamp() << ":  " << "Assertion `" #condition "` failed in " << __FILE__ \
                        << " line " << __LINE__ << ": " << message << std::endl; \
            state = SIM_STATE_END_WITH_ERR; \
        }

    uint64_t getAllOnes(uint64_t numOfOne) {
        return ((1ULL << numOfOne) - 1ULL);
    }

    void load_cube(string path, vector<uint64_t> &init_ram) {
        ifstream file(path);
        string line; 
        while(file >> line) {
            std::stringstream ss(line);
            std::vector<int> output;
            string val_str;
            uint64_t val = 0;
            while(getline(ss, val_str, ',')) {
                val = (val << (LUT_CD)) | atoi(val_str.c_str());
            }
            init_ram.push_back(val);
        }
    }

    void load_image(string path) {
        image_name = fs::path(path).stem();
        image = imread(path);
        cvtColor(image, image, COLOR_BGR2RGB);
        cout << "loading of image, " << fs::path(path).stem() << ", is done" << endl;
        cout << "image Mat size: " << image.size() << endl;
        cout << "image Mat data length (in byte): " << image.total() * image.elemSize() << endl;
        image_out = Mat::zeros(image.size(), image.type());
    }

    void task_init_ram(string filepath) {
        vector<uint64_t> init_ram;
        load_cube(filepath, init_ram);
        for (int i=0 ; i<init_ram.size() ; ++i) {
            wait(p_clk.negedge_event());
            i_cfg_valid = 1;
            i_cfg_last = i == init_ram.size() - 1 ? 1 : 0;
            i_cfg_data = init_ram[i];
        }
        wait(p_clk.negedge_event());
        i_cfg_valid = 0;
        i_cfg_last = 0;
    }

    void task_send_image() {
        int cnt = 0;
        int height = image.size().height;
        int width = image.size().width;
        for (int y=0 ; y<height+5 ; ++y) {
            bool vvalid = y > 0;
            bool vporch = vvalid && (y < 3 || y >= height+3);
            for (int x=0 ; x<width+30 ; x+=2) {
                wait(p_clk.posedge_event()); // @(posedge p_clk)
                bool hvalid = x > 10;
                bool hporch = hvalid && (x < 20 || x >= width+20);
                bool data_valid = vvalid && !vporch && hvalid && !hporch; 
                i_vs = vvalid;
                i_hs = hvalid;
                i_de = data_valid;
                i_valid = data_valid;
                uint64_t temp = 0;
                memcpy(&temp                  , image.data + cnt*3, 3);
                memcpy(((uint8_t*)(&temp)) + 3, image.data + (cnt+1)*3, 3);
                i_data = temp;
                if (data_valid) cnt += 2;
            }
        }
        wait(p_clk.posedge_event()); // @(posedge p_clk)
        i_vs = 0;
        i_hs = 0;
        i_de = 0;
        i_valid = 0;
    }

    void sequencer() {
        p_rstn = false;  // Assert reset
        i_hs = 0;
        i_vs = 0;
        i_de = 0;
        i_valid = 0;
        i_cfg_valid = 0;
        i_cfg_last = 0;
        i_cfg_data = 0;
        i_data = 0;
        wait(100, SC_NS);
        p_rstn = true;    // deassert reset
        wait(20, SC_NS);
        
        for (const auto & image : fs::directory_iterator(imagedir)) {
            std::cout << image.path() << std::endl;
            load_image(image.path()); 
            for (const auto & cube : fs::directory_iterator(cubedir)) {
                std::cout << cube.path() << std::endl;
                string file = cube.path();
                lut_name = fs::path(file).stem(); 
                task_init_ram(file);
                cout << "Loading of the 3D LUT, " << file << ", is done" << endl;
                wait(10, SC_NS);
                task_send_image();
                wait(50, SC_NS);
            }
        }
        state = SIM_STATE_END_NO_ERR;
    }
    
    void monitor() {
        wait(p_rstn.posedge_event());
        int cnt = 0;
        int last_vs = 0;
        int image_cnt = 0;
        while (true) {      // forever begin
            wait(p_clk.posedge_event()); // @(posedge p_clk)
            if (o_valid.read()) {
                uint64_t temp = o_data.read();
                memcpy(image_out.data + cnt*3, &temp, 3);
                memcpy(image_out.data + (cnt+1)*3, ((uint8_t*)(&temp)) + 3, 3);
                // cout << "pixel count: " << dec << cnt << ". receive pixel: " << hex << o_data.read() << endl;
                cnt += 2;
            }

            if (last_vs && !o_vs) {
                if (cnt != image_out.total()) {
                    cout << "[ERROR] number of received pixels mismatch" << endl;
                } else {
                    cout << "all pixels are received" << endl;
                }
                string outpath = "images/" + image_name + "_" + lut_name + ".png";
                cout << "saving output image to path: " << outpath << endl;
                imwrite(outpath, image_out);
                cnt = 0;
                ++image_cnt;

            }
            last_vs = o_vs;
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
        std::unique_ptr<Vcolor_mapping_3dlut> &dut,
        string imagedir,
        string cubedir
    ) 
    :sc_module(name)
    ,p_clk("p_clk", 1, SC_NS, 0.5, 3, SC_NS, true)
    ,imagedir(imagedir)
    ,cubedir(cubedir)
    ,lut_name("none")
    {    
        SC_HAS_PROCESS(top_tb);
        SC_THREAD(sequencer);
        SC_THREAD(monitor);
        dut->p_clk(p_clk);
        dut->p_rstn(p_rstn);
        dut->i_hs(i_hs);
        dut->i_vs(i_vs);
        dut->i_de(i_de);
        dut->i_valid(i_valid);
        dut->o_hs(o_hs);
        dut->o_vs(o_vs);
        dut->o_de(o_de);
        dut->o_valid(o_valid);
        dut->i_cfg_valid(i_cfg_valid);
        dut->i_cfg_last(i_cfg_last);
        dut->i_cfg_data(i_cfg_data);
        dut->i_data(i_data);
        dut->o_data(o_data);

        p_rstn = false;
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
    Verilated::mkdir("images");
    ofstream tb_log("logs/tb_log.txt", std::ofstream::trunc);
    streambuf *coutbuf = cout.rdbuf(); //save old buf
    cout.rdbuf(tb_log.rdbuf()); //redirect std::cout to out.txt!

    const char* arg = nullptr;
    string cubedir = "";
    string imagedir = "";
    arg = Verilated::commandArgsPlusMatch("cubedir");
    if (arg && string(arg).find("+cubedir+") != std::string::npos) {
        cubedir = string(arg).replace(0, string("+cubedir+").size(), "");
        cout << "directory cube files " << cubedir << endl;
    }
    arg = Verilated::commandArgsPlusMatch("imagedir");
    if (arg && string(arg).find("+imagedir+") != std::string::npos) {
        imagedir = string(arg).replace(0, string("+imagedir+").size(), "");
        cout << "directory input images files " << imagedir << endl;
    }

    /*  instantiate dut and testbench top   */
    std::unique_ptr<Vcolor_mapping_3dlut> dut(new Vcolor_mapping_3dlut("dut"));
    std::unique_ptr<top_tb> tb(new top_tb("top_tb", dut, imagedir, cubedir));
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
