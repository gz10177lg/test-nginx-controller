package com.example.nginxcontroller.controller;

import com.example.nginxcontroller.dto.ResponseDTO;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import jakarta.servlet.http.HttpServletRequest;

@RestController
public class NginxTestController {

    // 场景1和5: 转发到 /api/hello
    @GetMapping("/api/hello")
    public ResponseDTO testApiHello(HttpServletRequest request) {
        return new ResponseDTO(
                "收到请求: /api/hello",
                "后端收到的URI: " + request.getRequestURI()
        );
    }

    // 场景2: 转发到 /hello
    @GetMapping("/hello")
    public ResponseDTO testHello(HttpServletRequest request) {
        return new ResponseDTO(
                "收到请求: /hello（场景2或场景6）",
                "后端收到的URI: " + request.getRequestURI()
        );
    }

    // 场景3: 转发到 /backendhello
    @GetMapping("/backendhello")
    public ResponseDTO testBackendHello(HttpServletRequest request) {
        return new ResponseDTO(
                "收到请求: /backendhello",
                "后端收到的URI: " + request.getRequestURI()
        );
    }

    // 场景4和场景7: 转发到 /backend/hello
    @GetMapping("/backend/hello")
    public ResponseDTO testBackendSlashHello(HttpServletRequest request) {
        return new ResponseDTO(
                "收到请求: /backend/hello",
                "后端收到的URI: " + request.getRequestURI()
        );
    }

    // 场景6 转发到 //hello
    @GetMapping("//hello")
    public ResponseDTO testDoubleSlashHello(HttpServletRequest request) {
        return new ResponseDTO(
                "收到请求: //hello",
                "后端收到的URI: " + request.getRequestURI()
        );
    }

    // 场景8: 转发到 /backend//hello
    @GetMapping("/backend//hello")
    public ResponseDTO testBackendDoubleSlashHello(HttpServletRequest request) {
        return new ResponseDTO(
                "收到请求: /backend//hello",
                "后端收到的URI: " + request.getRequestURI()
        );
    }
}