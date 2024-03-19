all: FORCE
	Rscript wb_test.R
	cp wb.R wb.R.md
	cp wb_test.R wb_test.R.md
clean: FORCE
	-rm -f *.out
	-rm -f *.png
FORCE:
