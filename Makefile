

COMPOSE="docker-compose"


help:   ## Show help
	@echo "make [opsitons]"
	@echo "options:"
	@grep '^[a-zA-Z_\%\-]*:.*## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-32s\033[0m %s\n", $$1, $$2}'

build:  ## Run build docker image
	$(COMPOSE) build

up:     ## Start docker container
	@mkdir -p run log
	$(COMPOSE) up -d

down:   ## Stop docker container
	$(COMPOSE) down

logs:   ## Show logs
	$(COMPOSE) logs

login:  ## Login to container
	$(COMPOSE) exec rsyslogd bash


test-socket:  ## Test with socket
	@logger --socket ./run/socket \
		--tag test/socket \
		"LOG:socket: Hello world."

test-tcp:     ## Test with tcp connection
	@logger --server localhost --port 5514 --tcp \
		--tag test/tcp \
		"LOG:tcp: Hello world."

test-udp:     ## Test with udp connection
	@logger --server localhost --port 5514 --udp \
		--tag test/udp \
		"LOG:udp: Hello world."


test-stress-%:  ## Test of stress (%=socket/tcp/udp)
	@_bgn="" ; _cnt=0 ; \
	while true ; \
	do \
		_cnt=$$( expr $${_cnt} + 1 ) ; \
		_hms=$$( date +%H:%M:%S ) ; \
		_sec=$$( date +%s ) ; \
		if test "$${_bgn}" == "" ; then _bgn=$${_sec} ; fi ; \
		_dif=$$( expr $${_sec} - $${_bgn} ) ; \
		printf "TEST %6d / %5d [lines/sec] @ %s\n" $${_cnt} $${_dif} $${_hms} ; \
		sleep 0.005s ; \
	done | \
	if   test "$*" == "tcp" ; then \
		logger --server localhost --port 5514 --tcp --tag test/tcp ; \
	elif test "$*" == "udp" ; then \
		logger --server localhost --port 5514 --udp --tag test/udp ; \
	else \
		logger --socket ./run/socket --tag test/socket ; \
	fi

# EOF
