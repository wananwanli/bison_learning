.PHONY:run,clean 
run:
	bison -d syb.y
	g++ syb.tab.c -o syb
	./syb
clean:
	rm -fr syb