package controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
public class MainController {

  @RequestMapping(value = "/index.do", method = {RequestMethod.GET})
  public String index(HttpServletRequest request, HttpServletResponse response) {
    return "index";
  }

}
