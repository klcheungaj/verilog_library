import os
import sys
import pytest
import filecmp

parent_directory = os.path.abspath('.')
# parent_directory = os.path.abspath('..')
sys.path.append(parent_directory)
from registerGenerator import main

def test_zero_width():
    with pytest.raises(Exception) as e:   
        main(["tests/configs/zero_width.yaml"])
    assert str(e.value) == 'data width and address width cannot be 0'

def test_no_reg():
    with pytest.raises(Exception) as e:   
        main(["tests/configs/no_reg.yaml"])

def test_no_width():
    with pytest.raises(Exception) as e:   
        main(["tests/configs/no_width.yaml"])

def test_write_only():
    with pytest.raises(Exception) as e:   
        main(["tests/configs/write_only.yaml"])
    assert str(e.value) == "Write only type is not supported"

def test_no_file():
    with pytest.raises(Exception) as e:   
        main(["tests/configs/no_file.yaml"])
    assert str(e.value) == "the input file is not found!"

def test_unknown_reg_type():
    with pytest.raises(Exception) as e:   
        main(["tests/configs/unknown_reg_type.yaml"])
    assert str(e.value) == "Unpexected Read/Write attribute"
    
def test_no_reg_type_in_port():
    with pytest.raises(Exception) as e:   
        main(["tests/configs/no_reg_type_in_port.yaml"])
    assert str(e.value) == "Type of the register is not defined"

def test_apb3_example():
    main(["tests/configs/apb3_example.yaml", "--output_dir=tests/configs", "--datetime_override=0", "-f"])
    assert filecmp.cmp('tests/apb3_example.v', 'tests/configs/apb3_example.v')
    assert filecmp.cmp('tests/apb3_example.h', 'tests/configs/apb3_example.h')