BIN_NAME=flp22-log

${BIN_NAME}: ${BIN_NAME}.pl
	swipl -q -g main -o $@ -c $^

.PHONY: clean
clean:
	rm -f ${BIN_NAME}
