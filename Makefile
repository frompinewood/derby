# based on:
# https://github.com/relops/leex_yecc_example/blob/master/Makefile
#
EBIN_DIR=ebin
SRC_DIR=src
INC_DIR=include
ERLC_FLAGS=-W0 -Ddebug +debug_info
ERLC=erlc -I $(INC_DIR) -o $(EBIN_DIR) $(ERLC_FLAGS)
ERL=erl -I -pa $(EBIN_DIR) -noshell -eval

APPNAME=derby
APPFILE=$(APPNAME).app
APPSRC=$(SRC_DIR)/$(APPFILE).src
PARSER_BASE_NAME=$(APPNAME)
TEST_NAME=$(APPNAME)_test
LEXER_NAME=$(PARSER_BASE_NAME)_lexer
PARSER_NAME=$(PARSER_BASE_NAME)_parser

SOURCES=$(wildcard $(SRC_DIR)/*.erl)
TARGETS=$(SOURCES:$(SRC_DIR)/%.erl=$(EBIN_DIR)/%.beam)

defaults: $(EBIN_DIR) test

$(EBIN_DIR):
	mkdir -p $(EBIN_DIR)

$(EBIN_DIR)/$(APPFILE): $(APPSRC)
	cp $(APPSRC) $(EBIN_DIR)/$(APPFILE)

$(SRC_DIR)/$(LEXER_NAME).erl: $(SRC_DIR)/$(LEXER_NAME).xrl
	$(ERL) 'leex:file("$(SRC_DIR)/$(LEXER_NAME)"), halt().'

$(SRC_DIR)/$(PARSER_NAME).erl: $(SRC_DIR)/$(PARSER_NAME).yrl
	$(ERL) 'yecc:file("$(SRC_DIR)/$(PARSER_NAME)"), halt().'

$(EBIN_DIR)/%.beam: $(SRC_DIR)/%.erl
	$(ERLC) $<

test: $(TARGETS) \
	$(EBIN_DIR)/$(LEXER_NAME).beam \
	$(EBIN_DIR)/$(PARSER_NAME).beam \
	$(EBIN_DIR)/$(APPFILE)
	$(ERL) '$(TEST_NAME):test(), halt().'

clean:
	rm -f erl_crash.dump
	rm -f $(SRC_DIR)/$(LEXER_NAME).erl
	rm -f $(SRC_DIR)/$(PARSER_NAME).erl
	rm -rf $(EBIN_DIR)

