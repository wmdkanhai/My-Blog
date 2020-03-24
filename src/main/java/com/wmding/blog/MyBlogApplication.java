package com.wmding.blog;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.web.servlet.MultipartAutoConfiguration;
import org.springframework.boot.web.servlet.MultipartConfigFactory;
import org.springframework.context.annotation.Bean;

import javax.servlet.MultipartConfigElement;

@MapperScan("com.wmding.blog.dao")
@SpringBootApplication(exclude = {MultipartAutoConfiguration.class})
public class MyBlogApplication {

    @Value("${file.path}")
    private String filePath;

    public static void main(String[] args) {
        SpringApplication.run(MyBlogApplication.class, args);
    }

    /**
     * 解决文件上传,临时文件夹被程序自动删除问题
     *
     * 文件上传时自定义临时路径
     * @return
     */
    @Bean
    MultipartConfigElement multipartConfigElement() {
        MultipartConfigFactory factory = new MultipartConfigFactory();
        //该处就是指定的路径(需要提前创建好目录，否则上传时会抛出异常)
        factory.setLocation(filePath);
        return factory.createMultipartConfig();
    }
}
