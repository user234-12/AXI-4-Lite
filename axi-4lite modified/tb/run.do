# run.do

# Create work library
vlib work

# Compile the design and testbench with coverage enabled
vlog +incdir+./interface +incdir+./config_db +incdir+./write +incdir+./read +incdir+./test +incdir+./tb top.sv +acc -cover bcesf  ;# Enable code coverage (branch, condition, expression, statement, FSM)

# Create directories for logs and coverage
if { ![file exists logs] } { file mkdir logs }
if { ![file exists coverage] } { file mkdir coverage }

# Define the list of valid testcases (for validation)
set test_list {axi4l_write_test axi4l_write_fixed_test axi4l_write_read_random_test axi4l_strob_test axi4l_error_test}
set default_test "write_test_class"
set testname $default_test

# Check for coverage report mode (COVR=1)
if { [info exists ::env(COVR)] && $::env(COVR) == "1" } {
    echo "Generating final coverage report..."
    set coverage_db "coverage/regression_coverage.ucdb"

    # Clear previous merged coverage file
    if { [file exists $coverage_db] } { catch {file delete $coverage_db} }

    # Merge all coverage files
    set ucdb_files [glob -nocomplain coverage/*_coverage.ucdb]
    if { [llength $ucdb_files] > 0 } {
        catch {vcover merge $coverage_db {*}$ucdb_files} err
        if { $err == "" } {
            echo "Coverage merged into $coverage_db"
        } else {
            echo "Error merging coverage: $err"
        }

        # Generate coverage report
        if { [file exists $coverage_db] } {
            echo "Generating coverage report..."
            catch {vcover report -details -html -htmldir coverage_report -nofec $coverage_db} err
            if { $err == "" } {
                echo "Coverage report generated in directory: coverage_report"
            } else {
                echo "Error generating coverage report: $err"
            }
        }
    } else {
        echo "Warning: No coverage files found in coverage/ to merge"
    }

} else {
    # Single-test mode
    if { [info exists ::env(UVM_TESTNAME)] } {
        set testname $::env(UVM_TESTNAME)
        echo "Debug: Test name read from environment variable: $testname"
    } else {
        echo "Warning: Environment variable UVM_TESTNAME not set, using default testname: $testname"
    }

    # Validate testname against test_list
    if { [lsearch -exact $test_list $testname] >= 0 } {
        echo "Debug: '$testname' found in test_list, using it as testname"
    } else {
        echo "Warning: '$testname' not found in test_list: $test_list"
        echo "Using default testname: $default_test"
        set testname $default_test
    }

    # Delete previous coverage file for this testcase
    set old_coverage_file "coverage/${testname}_coverage.ucdb"
    if { [file exists $old_coverage_file] } {
        catch {file delete $old_coverage_file}
        echo "Deleted previous coverage file: $old_coverage_file"
    }

    # Run the single test with coverage
    echo "Running test: $testname"
    catch {
        vsim work.top -assertdebug +UVM_VERBOSITY=UVM_MEDIUM +UVM_TESTNAME=$testname \
             -l logs/run_${testname}.log \
             -coverage \
             -do "run -all; coverage save coverage/${testname}_coverage.ucdb"
    } err
    if { $err != "" } {
        echo "Error running $testname: $err"
    } else {
        echo "Test $testname completed"
        # Check pass/fail status
        if { [file exists logs/run_${testname}.log] } {
            set fid [open logs/run_${testname}.log r]
            set log_content [read $fid]
            close $fid
            if { [string match "*UVM_ERROR :    0*" $log_content] && [string match "*UVM_FATAL :    0*" $log_content] } {
                echo "Test $testname: PASSED"
            } else {
                echo "Test $testname: FAILED (check logs/run_${testname}.log for details)"
            }
        } else {
            echo "Test $testname: FAILED (log file missing)"
        }
    }
}
