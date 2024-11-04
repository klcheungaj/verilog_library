import argparse
import yaml
from pathlib import Path
import io
import os
from datetime import datetime

INDENT_SPACE = 4
current_datetime = None

class RegDefine():
    def __init__(self, name, width, reg_type, unpacked_width, bus_width, index):
        try:
            if (type(name) is list) != (type(width) is list):
                raise TypeError("name and width should have same dimension")
            if type(width) is list:
                for w in width:
                    if w == 0:
                        raise ValueError("Width of 0 is not supported")
                if sum(width) > bus_width:
                    raise ValueError(f"packed width larger than bus width is not supported for normal register. Register width: {sum(width)}, Bus width: {bus_width}")
                if len(width) != len(name):
                    raise ValueError(f"name and width have different length. {len(name)} vs {len(width)}")
            else:
                if width == 0 or unpacked_width == 0:
                    raise ValueError("Width of 0 is not supported")
                if width > bus_width:
                    raise ValueError(f"packed width larger than bus width is not supported for normal register. Register width: {width}, Bus width: {bus_width}")
            if reg_type == 'w':
                raise ValueError("Write only type is not supported")
            if unpacked_width: ## 2D ports with unpacked width
                pass
            elif type(name) is list: ## multiple signals packed into single register
                pass
            else: ## normal register
                pass
        except Exception as e:
            print(f"name: {name}, width: {width}, reg_type: {reg_type}, unpacked_width: {unpacked_width}, bus_width: {bus_width}, index: {index}")
            raise e
        finally:
            pass

        self.__name = name
        self.__width = width
        self.__reg_type = reg_type
        self.__unpacked_width = unpacked_width
        self.__bus_width = bus_width
        self.__index = index

    @property
    def reg_count(self):
        if self.__unpacked_width:
            return self.__unpacked_width
        else:
            return 1
        
    @property
    def total_width(self):
        if type(self.__width) is list:
            return sum(self.__width)
        else:
            return self.__width
        
    @property
    def writable(self):
        w_list = ['rw', 'wr']
        if self.__reg_type in w_list:
            return True
        else:
            return False
        
    @property
    def readable(self):
        r_list = ['r', 'rw', 'wr']
        if self.__reg_type in r_list:
            return True
        else:
            return False
                
    @property
    def direction(self):
        output_list = ['rw', 'wr']
        input_list = ['r']
        if self.__reg_type in output_list:
            return "output"
        elif self.__reg_type in input_list:
            return "input"
        else:
            raise ValueError("Unpexected Read/Write attribute")
        
    @property
    def port_type(self):
        output_list = ['rw', 'wr']
        input_list = ['r']
        if self.__reg_type in output_list:
            return "reg"
        elif self.__reg_type in input_list:
            return "wire"
        else:
            raise ValueError("Unpexected Read/Write attribute")

    def to_concat_name(self, prefix: str = "", suffix: str = "", matchBusWidth: bool = False):
        ret = ""
        if type(self.__name) is list:
            concat_name = "{"
            for name in self.__name:
                concat_name += prefix + name + suffix + ", "
            ret = concat_name[:-2] + "}"
        else:
            ret = prefix + self.__name + suffix
        if matchBusWidth:
            if self.__bus_width == self.total_width:
                return ret
            else:
                return "{{ {}'b0, {} }}".format(self.__bus_width - self.total_width, ret)
        else:
            return ret
        
    def to_port_decl(self, format_str):
        ret = []
        if self.__unpacked_width:
            if type(self.__name) is list:
                for name, width in zip(self.__name, self.__width):
                    ret.append(format_str.format(self.direction, self.port_type, f"[{width-1:>3}:0]", name, f"[{self.__unpacked_width-1}:0]"))
            else:
                ret.append(format_str.format(self.direction, self.port_type, f"[{self.__width-1:>3}:0]", self.__name, f"[{self.__unpacked_width-1}:0]"))
        elif type(self.__name) is list:
            for name, width in zip(self.__name, self.__width):
                ret.append(format_str.format(self.direction, self.port_type, f"[{width-1:>3}:0]", name, f""))
        else:
            ret.append(format_str.format(self.direction, self.port_type, f"[{self.__width-1:>3}:0]", self.__name, f""))
        return ret

    def to_write_statement(self, format_str):
        ret = []
        if self.__unpacked_width:
            for i in range(self.__unpacked_width):
                ret.append(format_str.format(port_name=self.to_concat_name("", f"[{i}]", False), address=self.__index + i, width=self.total_width))
        else:
            ret.append(format_str.format(port_name=self.to_concat_name(), address=self.__index, width=self.total_width))
        return ret

    def to_read_statement(self, format_str):
        ret = []
        if self.__unpacked_width:
            for i in range(self.__unpacked_width):
                ret.append(format_str.format(index=self.__index + i, port_name=self.to_concat_name("", f"[{i}]", True)))
        else:
            ret.append(format_str.format(index=self.__index, port_name=self.to_concat_name("", "", True)))
        return ret
    
    def to_c_macro(self):
        ret = []
        reg_format = "#define REG_{{:<30}}    {}{{:<10}} //index: {{}}\n".format(''.ljust(INDENT_SPACE), "")
        offset_format = "{}#define OFFSET_{{:<30}} {{:<10}}\n".format(''.ljust(INDENT_SPACE))
        bit = 0
        if self.__unpacked_width:
            if type(self.__name) is list:
                ret.append(reg_format.format(self.__name[0].upper(), hex(self.__index * 4), self.__index))
                for name, width in reversed(list(zip(self.__name, self.__width))):
                    ret.append(offset_format.format(name.upper(), bit))
                    bit += width
            else:
                ret.append(reg_format.format(self.__name.upper(), hex(self.__index * 4), self.__index))
        elif type(self.__name) is list:
            ret.append(reg_format.format(self.__name[0].upper(), hex(self.__index * 4), self.__index))
            for name, width in reversed(list(zip(self.__name, self.__width))):
                ret.append(offset_format.format(name.upper(), bit))
                bit += width
        else:
            ret.append(reg_format.format(self.__name.upper(), hex(self.__index * 4), self.__index))
        return ret

def generate_c_header(basename, port_def: list[RegDefine], reg_dict):
    def to_param_define(param_list: list[dict]):
        ret = []
        for param in param_list:
            key = next(iter(param))
            ret.append(f"#define PARAM_{key:<20} {param[key]:<10}\n")
        ret.append("\n")
        return "".join(ret)
    
    output = io.StringIO()
    beginning_code = [
        f"////////////////////////////////////////////\n",
        f"// revision       : {reg_dict['revision']}\n",
        f"// File generated : {current_datetime.strftime('%Y-%m-%d %H:%M:%S')}\n"
        f"////////////////////////////////////////////\n",
        f"#pragma once\n\n"
    ]
    output.writelines(beginning_code)
    output.writelines(to_param_define(reg_dict['params']))
    for port in port_def:
        output.writelines(port.to_c_macro())
    return output.getvalue()


def generate_verilog_module_header(basename, port_def: list[RegDefine], reg_dict):
    output = io.StringIO()
    addr_width = reg_dict['addr_width']
    data_width = reg_dict['data_width']
    reset_polarity = reg_dict['reset_polarity']
    reset_name = "s_apb3_rst" if reset_polarity else "s_apb3_rstn"
    beginning_code = [
        f"////////////////////////////////////////////\n",
        f"// revision       : {reg_dict['revision']}\n",
        f"// File generated : {current_datetime.strftime('%Y-%m-%d %H:%M:%S')}\n"
        f"////////////////////////////////////////////\n",
        f"`default_nettype none\n",
        os.linesep,
        f"module {basename} (\n"
    ]
    format_str_last_line = "{}{{:<6}} {{:<4}} {{:>7}} {{:<20}}{{:>6}}".format(''.ljust(INDENT_SPACE))
    format_str = format_str_last_line + ",\n"
    ending_code = [
        "\n",
        format_str.format('input', "wire", "", "s_apb3_clk", ""),
        format_str.format('input', "wire", "", reset_name, ""),
        format_str.format('input', "wire", f"[{addr_width-1:>3}:0]", "s_apb3_paddr", ""),
        format_str.format('input', "wire", "", "s_apb3_psel", ""),
        format_str.format('input', "wire", "", "s_apb3_penable", ""),
        format_str.format('output', "reg", "", "s_apb3_pready", ""),
        format_str.format('input', "wire", "", "s_apb3_pwrite", ""),
        format_str.format('input', "wire", f"[{data_width-1:>3}:0]", "s_apb3_pwdata", ""),
        format_str.format('output', "reg", f"[{data_width-1:>3}:0]", "s_apb3_prdata", ""),
        format_str_last_line.format('output', "wire", "", "s_apb3_pslverror", ""),
        "\n);\n",
    ]
    output.writelines(beginning_code)
    for port in port_def:
        output.writelines(port.to_port_decl(format_str))
    output.writelines(ending_code)
    return output.getvalue()

def generate_verilog_module_body(port_def: list[RegDefine], reg_dict):
    def to_localparam_statement(param_list: list[dict]):
        ret = [
            "//-- Following parameters were defined when this RTL file was generated. \n//-- They are not directly used in this file\n"
        ]
        for param in param_list:
            key = next(iter(param))
            ret.append(f"// localparam {key} = {param[key]};\n")
        return "".join(ret)
    output = io.StringIO()
    addr_width = reg_dict['addr_width']
    polarity = reg_dict['reset_polarity']
    sync_reset = reg_dict['sync_reset']
    data_width = reg_dict['data_width']
    reset_name = "s_apb3_rst" if polarity else "s_apb3_rstn"
    reset_condition = "{} == {}".format(reset_name, "1'b1" if polarity == 1 else "1'b0")
    reset_sensitivity = "{}".format("" if sync_reset else " or {} {}".format("posedge" if polarity == 1 else "negedge", reset_name))
    beginning_code = "{param_define}\nassign s_apb3_pslverror = 1'b0;\nreg [{addr_width}-3:0] loc_addr;\nreg          loc_wr_vld;\nreg          loc_rd_vld;\n\nalways @(posedge s_apb3_clk{reset_sensitivity}) begin\n    if({reset_condition})\n        loc_addr <= {index_width}'b0;\n    else if((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0))\n        loc_addr <= s_apb3_paddr[2 +: {index_width}];\nend\n\nalways @(posedge s_apb3_clk{reset_sensitivity}) begin\n    if({reset_condition})\n        loc_wr_vld <= 1'b0;\n    else if((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b1))\n        loc_wr_vld <= 1'b1;\n    else\n        loc_wr_vld <= 1'b0;\nend\n\nalways @(posedge s_apb3_clk{reset_sensitivity}) begin\n    if({reset_condition})\n        loc_rd_vld <= 1'b0;\n    else if((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b0))\n        loc_rd_vld <= 1'b1;\n    else\n        loc_rd_vld <= 1'b0;\nend\n\nalways @(posedge s_apb3_clk{reset_sensitivity}) begin\n    if({reset_condition})\n        s_apb3_pready <= 1'b0;\n    else if((loc_wr_vld == 1'b1) || (loc_rd_vld == 1'b1))\n        s_apb3_pready <= 1'b1;\n    else\n        s_apb3_pready <= 1'b0;\nend\n".format(param_define=to_localparam_statement(reg_dict['params']), addr_width=addr_width, reset_sensitivity=reset_sensitivity, reset_condition=reset_condition, index_width=addr_width-2)
    write_statement = "always @(posedge s_apb3_clk{reset_sensitivity}) begin\n    if({reset_condition}) begin\n        {{port_name}} <= {{width}}'b0;\n    end else if((loc_wr_vld == 1'b1) && (loc_addr == {index_width}'d{{address}})) begin\n        {{port_name}} <= s_apb3_pwdata[0 +: {{width}}];\n    end\nend\n\n".format(reset_sensitivity=reset_sensitivity, reset_condition=reset_condition, index_width=addr_width-2)

    read_statement = "always @(posedge s_apb3_clk{reset_sensitivity}) begin\n    if({reset_condition}) begin\n        s_apb3_prdata <= {data_width}'b0;\n    end else if(loc_rd_vld == 1'b1) begin\n        case (loc_addr)\n{{case_statement}}            default: s_apb3_prdata <= {data_width}'b0;\n        endcase\n    end\nend".format(data_width=data_width, reset_sensitivity=reset_sensitivity, reset_condition=reset_condition)

    read_case_statement = "            {index_width}'d{{index}} : s_apb3_prdata <= {{port_name}};\n".format(index_width=addr_width-2)
    ending_code = [
        "\n\nendmodule\n\n"
    ]
    output.writelines(beginning_code)
    for port in port_def:
        if port.writable:
            output.writelines(port.to_write_statement(write_statement))
    case_list = []
    for port in port_def:
        if port.readable:
            case_list += port.to_read_statement(read_case_statement)
    output.writelines(read_statement.format(case_statement="".join(case_list)))
    output.writelines(ending_code)
    return output.getvalue()

def parse(input_file, output_dir, force_overwrite):
    filepath = Path(input_file)
    if not filepath.exists():
        raise FileNotFoundError("the input file is not found!")
    with open(filepath, "r") as file:
        reg_dict = yaml.safe_load(file)
        if 'sync_reset' not in reg_dict:
            reg_dict['sync_reset'] = False
        if 'reset_polarity' not in reg_dict:
            reg_dict['reset_polarity'] = 0
        if 'offset' not in reg_dict:
            reg_dict['offset'] = 0
        if 'params' not in reg_dict:
            reg_dict['params'] = []
        if 'addr_width' not in reg_dict:
            raise KeyError("Users have to specify addr_width")
        if 'data_width' not in reg_dict:
            raise KeyError("Users have to specify data_width")
        if reg_dict['data_width'] == 0 or reg_dict['addr_width'] == 0:
            raise ValueError("data width and address width cannot be 0")

    verilog_file = output_dir.joinpath(filepath.stem + '.sv')
    c_file = output_dir.joinpath(filepath.stem + '.h')
    if verilog_file.exists() or c_file.exists():
        if not force_overwrite:
            print(f"output file {verilog_file} or {c_file} already exists. Script exit")
            return
        else:
            print(f"output file {verilog_file} or {c_file} already exists but --force flag is set. The original file will be overwritten") 

    port_def: list[RegDefine] = []
    index = reg_dict['offset']
    for reg in reg_dict['registers']:
        if 'port_num' in reg:
            unpack_width = reg['port_num']
            prefix = reg['name'] + '_' if 'name' in reg else ''
            for r in reg['registers']:
                port_name = [prefix + n for n in r['name']] if isinstance(r['name'], list) else prefix + r['name']
                pack_width = r['width']
                if 'reg_type' in r:
                    reg_type = r['reg_type']
                elif 'reg_type' in reg:
                    reg_type = reg['reg_type']
                else:
                    raise ValueError("Type of the register is not defined")
                port_def.append(RegDefine(port_name, pack_width, reg_type, unpack_width, reg_dict['data_width'], index))
                index += port_def[-1].reg_count
        elif type(reg['name']) is list:
            port_names = reg['name']
            pack_width = reg['width']
            reg_type = reg['reg_type']
            port_def.append(RegDefine(port_names, pack_width, reg_type, None, reg_dict['data_width'], index))
            index += port_def[-1].reg_count
        else:
            port_name = reg['name']
            pack_width = reg['width']
            reg_type = reg['reg_type']
            port_def.append(RegDefine(port_name, pack_width, reg_type, None, reg_dict['data_width'], index))
            index += port_def[-1].reg_count
    if len(port_def) == 0:
        raise KeyError("No registers are defined")

    reg_count = 0
    for port in port_def:
        reg_count += port.reg_count
    if 2**reg_dict['addr_width'] < reg_count:
        raise ValueError(f"Address width {reg_dict['addr_width']} of the bus is less than number of register: {reg_count}")
    
    verilog_code = io.StringIO()
    verilog_code.write(generate_verilog_module_header(filepath.stem, port_def, reg_dict))
    verilog_code.write(generate_verilog_module_body(port_def, reg_dict))
    with open(verilog_file, "w") as f:
        f.write(verilog_code.getvalue())

    c_code = generate_c_header(filepath.stem, port_def, reg_dict)   
    with open(c_file, "w") as f:
        f.write(c_code)
        
def main(arg_list: list[str] | None = None):
    global current_datetime
    parser = argparse.ArgumentParser()
    parser.add_argument("input_file", type=str, help="path of the YAML file that defines registers")
    parser.add_argument("--output_dir", type=str, help="output directory of the generated Verilog file", default=".")
    parser.add_argument("-f", "--force", help="force overwrite output file", action='store_true')
    parser.add_argument('--datetime_override', help=argparse.SUPPRESS)
    args = parser.parse_args(arg_list)
    if args.datetime_override is not None:
        current_datetime = datetime.fromtimestamp(int(args.datetime_override))
    else:
        current_datetime = datetime.now()
    parse(args.input_file, Path(args.output_dir), args.force)

if __name__ == '__main__':
    main() 