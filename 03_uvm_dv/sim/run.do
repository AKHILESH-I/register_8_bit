vsim -voptargs=+acc work.register_8_bit_tb

run -all

file mkdir ../results

coverage save ../results/register_coverage.ucdb

vcover report ../results/register_coverage.ucdb -cvg -details > ../results/coverage_report.txt

quit -f
