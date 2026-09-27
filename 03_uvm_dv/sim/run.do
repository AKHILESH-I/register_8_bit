cd ../tb

vsim -voptargs=+acc work.register_8_bit_tb

onfinish stop

run -all

cd ../sim

file mkdir ../results

coverage save ../results/register_coverage.ucdb

vcover report ../results/register_coverage.ucdb -cvg -details > ../results/coverage_report.txt
