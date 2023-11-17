package kr.or.ddit.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurationSupport;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import kr.or.ddit.handler.ChatHandler;

@Configuration
@EnableWebSocket
public class ChatWebSocketConfig extends WebSocketConfigurationSupport{

	 @Bean
	    public ChatHandler chatHandler() {
	        return new ChatHandler();
	    }

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(chatHandler(), "/chatting").setAllowedOrigins("*");
    }
	
}
