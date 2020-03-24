package com.wmding.blog.controller.api;

import com.wmding.blog.service.BlogService;
import com.wmding.blog.util.PageQueryUtil;
import com.wmding.blog.util.Result;
import com.wmding.blog.util.ResultGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.websocket.server.PathParam;
import java.util.HashMap;
import java.util.Map;

/**
 * @author 明月
 * @version 1.0
 * @date 2020-03-24 17:59
 * @description:
 */
@RestController
public class ApiBlogController {

    @Autowired
    private BlogService blogService;

    @PostMapping("/api/blog/list1")
    public Result list(@RequestParam("page") Integer page, @RequestParam("limit") Integer limit) {

        HashMap<String, Object> params = new HashMap<>();
        params.put("page", page);
        params.put("limit", limit);

        if (StringUtils.isEmpty(params.get("page")) || StringUtils.isEmpty(params.get("limit"))) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        PageQueryUtil pageUtil = new PageQueryUtil(params);
        return ResultGenerator.genSuccessResult(blogService.getBlogsPage(pageUtil));
    }

    @PostMapping("/api/blog/list2")
    public Result list(@RequestBody Map<String, Object> params) {

        if (StringUtils.isEmpty(params.get("page")) || StringUtils.isEmpty(params.get("limit"))) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        PageQueryUtil pageUtil = new PageQueryUtil(params);
        return ResultGenerator.genSuccessResult(blogService.getBlogsPage(pageUtil));
    }


    @GetMapping("/api/blog/list3")
//    public Result list3(@RequestParam("page") Integer page, @RequestParam("limit") Integer limit) {
    public Result list3(@RequestParam Map<String, Object> params) {

        if (StringUtils.isEmpty(params.get("page")) || StringUtils.isEmpty(params.get("limit"))) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        PageQueryUtil pageUtil = new PageQueryUtil(params);
        return ResultGenerator.genSuccessResult(blogService.getBlogsPage(pageUtil));
    }


    @GetMapping("/api/blog/list4/{page}/{limit}")
    public Result list4(@PathVariable("page") Integer page, @PathVariable("limit") Integer limit) {

        HashMap<String, Object> params = new HashMap<>();
        params.put("page", page);
        params.put("limit", limit);

        if (StringUtils.isEmpty(params.get("page")) || StringUtils.isEmpty(params.get("limit"))) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        PageQueryUtil pageUtil = new PageQueryUtil(params);
        return ResultGenerator.genSuccessResult(blogService.getBlogsPage(pageUtil));
    }
}
