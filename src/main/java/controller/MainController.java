package controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import vo.Homework2;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
public class MainController {

  @RequestMapping(value = "/homework1.do", method = {RequestMethod.GET})
  public String homework1(HttpServletRequest request, HttpServletResponse response) {
    return "homework1";
  }

  @RequestMapping(value = "/homework2.do", method = {RequestMethod.GET})
  public String homework2(HttpServletRequest request, HttpServletResponse response) {
    return "homework2";
  }

  @RequestMapping(value = "/homework2API.do", method = {RequestMethod.GET, RequestMethod.POST})
  @ResponseBody
  public ModelAndView homework2API(HttpServletRequest request, HttpServletResponse response, @RequestBody Map<String,Object> paramMap)  throws Exception{

    ModelAndView mv = new ModelAndView("jsonView");
    mv.addObject("success", false);

    System.out.println("Start Homework2API");
    System.out.println(paramMap.toString());

    if(paramMap.containsKey("totalAmount") && paramMap.containsKey("coinPriceArray") && paramMap.containsKey("coinAmountArray")) {

      int totalAmount = Integer.parseInt((String)paramMap.get("totalAmount"));
      List<String> coinPriceArray = (List<String>) paramMap.get("coinPriceArray");
      List<String> coinAmountArray = (List<String>) paramMap.get("coinAmountArray");

      int coin[][] = new int[coinPriceArray.size() + 1][2];
      int dp[][] = new int[coinPriceArray.size() +1][totalAmount + 1];

      for(int i = 1; i < coinPriceArray.size() + 1; i ++) {
        coin[i][0] = Integer.parseInt(coinPriceArray.get(i-1)); // 가격
        coin[i][1] = Integer.parseInt(coinAmountArray.get(i-1)); // 개수
        System.out.println(coin[i][0] + " / " + coin[i][1] );
      }

      dp[0][0] = 1;
      int count = 0;
      List<String> result = new ArrayList<>();
      for(int i = 1; i < coinPriceArray.size() + 1; i++) {
        int cost = coin[i][0];
        for(int j = 0; j < coin[i][1] + 1; j++) {
          for(int k = 0; k <= totalAmount; k++) { // i- 1 그전 계산된 row를 입혀주는 역할(j == 0) + 경우의수를 더해줌
            int pos = k + cost * j;
            if(pos > totalAmount) {
              break;
            }
            dp[i][pos] += dp[i-1][k];

          }
        }
      }

      mv.addObject("success", true);
      mv.addObject("result", dp[coinPriceArray.size()][totalAmount]);
      System.out.println(dp[coinPriceArray.size()][totalAmount]);

    }

    return mv;
  }



}
