Simple rsyslog and logrotate docker container.
====

## Usage

Logging with socket connection.

```
$ docker run --rm -d -v $(pwd)/run:/rsyslog/run -v $(pwd)/log:/var/log batatch/rsyslogd:latest

$ logger --socket ./run/socket --tag test/sock "LOG:sock: Hello world."

$ cat ./log/messages
=> ... test/sock LOG:sock: Hello world.
```

Logging with tcp connection.

```
$ docker run --rm -d -p 5514:514/tcp -v $(pwd)/log:/var/log batatch/rsyslogd:latest

$ logger --server localhost --port 5514 --tcp --tag test/tcp "LOG:tcp: Hello world."

$ cat ./log/messages
=> ... test/tcp LOG:tcp: Hello world.
```

Logging with udp connection.

```
$ docker run --rm -d -p 5514:514/udp -v $(pwd)/log:/var/log batatch/rsyslogd:latest

$ logger --server localhost --port 5514 --udp --tag test/udp "LOG:udp: Hello world."

$ cat ./log/messages
=> ... test/udp LOG:udp: Hello world.
```

## Configuration

Settings for rsyslog.

```
/etc/rsyslog.conf
/etc/rsyslog.d/*.conf
```

Settings for logrotate.

```
/etc/logrotate.conf
/etc/logrotate.d/*
```


// EOF
