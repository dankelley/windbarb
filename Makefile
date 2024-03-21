all: wb_test.out $(patsubst %.R,%.out,$(wildcard issue*.R))
%.out: %.R
	R --no-save < $< &> $@
clean:
	-rm *~ *png *.out *pdf
view:
	open *.png

