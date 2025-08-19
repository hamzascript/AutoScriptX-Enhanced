package main

import (
	"fmt"
	"io"
	"net"
	"strings"
	"time"
)

const (
	BufferSize        = 512 * 1024 // 512KB buffer for fast transfer
	ConnectionTimeout = 60 * time.Second
	HttpResponse101   = "HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\n\r\n"
	HttpResponse200   = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 0\r\n\r\n"
)

func main() {
	listenAddr := "0.0.0.0:80"   // listening address
	targetAddr := "127.0.0.1:2000" // target server address

	listener, err := net.Listen("tcp", listenAddr)
	if err != nil {
		panic(err)
	}
	fmt.Printf("[OK] Ultra-fast WS Proxy listening on %s → %s\n", listenAddr, targetAddr)

	for {
		client, err := listener.Accept()
		if err != nil {
			continue
		}
		go handle(client, targetAddr)
	}
}

func handle(client net.Conn, targetAddr string) {
	defer client.Close()
	enableFastTCP(client)

	buf := make([]byte, BufferSize)
	n, err := client.Read(buf)
	if err != nil {
		return
	}

	headers := string(buf[:n])
	target := getHeader(headers, "X-Real-Host")
	if target == "" {
		target = targetAddr
	}

	server, err := net.DialTimeout("tcp", target, ConnectionTimeout)
	if err != nil {
		return
	}
	defer server.Close()
	enableFastTCP(server)

	if strings.Contains(headers, "Upgrade:") {
		client.Write([]byte(HttpResponse101))
	} else {
		client.Write([]byte(HttpResponse200))
	}

	// relay data at maximum speed
	go io.CopyBuffer(server, client, make([]byte, BufferSize))
	io.CopyBuffer(client, server, make([]byte, BufferSize))
}

func enableFastTCP(conn net.Conn) {
	if tcp, ok := conn.(*net.TCPConn); ok {
		tcp.SetNoDelay(true)
		tcp.SetKeepAlive(true)
		tcp.SetKeepAlivePeriod(10 * time.Second)
	}
}

func getHeader(headers, key string) string {
	for _, line := range strings.Split(headers, "\r\n") {
		if strings.HasPrefix(line, key+": ") {
			return strings.TrimSpace(strings.TrimPrefix(line, key+": "))
		}
	}
	return ""
}