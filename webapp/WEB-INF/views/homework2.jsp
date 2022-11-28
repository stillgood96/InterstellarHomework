<%--
  Created by IntelliJ IDEA.
  User: imlsw96
  Date: 2022/11/26
  Time: 1:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Homework 2 ( seonu7875@gmail.com/이선우/01020775061 )</title>
</head>
<body>
<div class="container">

  <header>
    <h1>Homework2</h1>
    <h5>seonu7875@gmail.com / 이선우 / 010-2077-5061</h5>
  </header>

  <table>
    <tr>
      <td>지폐금액</td>
      <td>
        <input type="text" id="totalAmount" onkeyup="inputTotalAmount(this)">
        <input type="hidden" id="totalSubmitAmount" value="0"/>
      </td>
    </tr>
    <tr>
      <td>동전의 가지 수</td>
      <td>
        <button type="button" onclick="addType()">+</button>
        <button type="button" onclick="deleteType()">-</button>
      </td>
    </tr>
    <tr>
      <td></td>
      <td>
        <span>동전금액</span>
      </td>
      <td>
        개수
      </td>
    </tr>
    <tr class="coinType">
      <td></td>
      <td>
        <input type="text" class="coinPrice" oninput="inputCoinPrice(this)">
        <input type="hidden" class="coinSubmitPrice">
      </td>
      <td>
        <input type="text" class="coinAmount" oninput="inputCoinAmount(this)">
        <input type="hidden" class="coinSubmitAmount">
      </td>
    </tr>
  </table>
  <button type="button" id="calculation" onclick="goCalculation()">계산</button>
  <div id="resultContainer">
  </div>
</div>
</body>

<script>
  document.addEventListener("DOMContentLoaded", function(){
    console.log("Start Homework2 !!");
  });

  function addType() {
    let coinType = document.querySelectorAll('.coinType');

    let coinContainer = document.createElement("tr");
        coinContainer.setAttribute("class", "coinType");

    let coinItem = "<td></td>";
        coinItem += "<td><input type='text' class='coinPrice' oninput='inputCoinPrice(this)'><input type='hidden' class='coinSubmitPrice'></td>";
        coinItem += "<td><input type='text' class='coinAmount' oninput='inputCoinAmount(this)'><input type='hidden' class='coinSubmitAmount'></td>";
        coinContainer.innerHTML = coinItem;

    coinType[coinType.length - 1].after(coinContainer);
  }

  function deleteType() {
    let coinType = document.querySelectorAll('.coinType');

    if(coinType.length > 1) {
      coinType[coinType.length - 1].remove();
    }
  }

  function inputTotalAmount(el) {
    let submitTotalAmount = document.getElementById("totalSubmitAmount");
    el.value = el.value.replace(/[^0-9]/g,'');

    if(el.value > 10000) {
      el.value = '';
      submitTotalAmount.value = 0;
      alert("10,000 원 까지 입력이 가능합니다.");
      return false;
    }else if( el.value.length > 0 &&  el.value == 0) {
      el.value='';
    }else {
      submitTotalAmount.value = el.value;
      el.value = el.value.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
    }
  }

  function inputCoinPrice(el) {
    el.value = el.value.replace(/[^0-9]/g,'');
    el.nextElementSibling.value = el.value;
    el.value = el.value.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
  }

  function inputCoinAmount(el) {
    el.value = el.value.replace(/[^0-9]/g,'');
    el.nextElementSibling.value = el.value;
  }

  function goCalculation() {
    let resultContainer = document.getElementById('resultContainer');
    let totalAmount = document.getElementById("totalSubmitAmount");
    let coinSubmitPriceList = document.getElementsByClassName("coinSubmitPrice");
    let coinSubmitAmountList = document.getElementsByClassName("coinSubmitAmount");

    if(totalAmount.value == 0) {
      alert("지폐금액을 입력해주세요");
      return false;
    }

    let coinSubmitPriceArray = new Array();
    let coinSubmitAmountArray = new Array();

    for(let i  = 0; i < coinSubmitPriceList.length; i ++) {
      if(coinSubmitPriceList[i].value > 0 && coinSubmitAmountList[i].value > 0 ) {
        coinSubmitPriceArray.push(coinSubmitPriceList[i].value);
        coinSubmitAmountArray.push(coinSubmitAmountList[i].value);
      }else {
        alert( (i + 1) + "번째 동전의 가지 수 값을 입력해주세요");
        return false;
      }
    }

    if(coinSubmitPriceList.length > 0 && coinSubmitAmountList.length > 0) {

      let result = fetch('http://ec2-3-218-75-64.compute-1.amazonaws.com:5009/homework2API.do', {
        method: "POST",
        headers: {  "Content-Type": "application/json; charset=utf-8" },
        body: JSON.stringify({
          "totalAmount" : totalAmount.value,
          "coinPriceArray" : coinSubmitPriceArray,
          "coinAmountArray" : coinSubmitAmountArray,
        })
      }).then(res => res.json())
        .then((json) => {
          console.log(json);
          if(json.success) {
            resultContainer.innerHTML = "";
            let result = "<h4 class='resultMessage'>총 " + json.result +"가지</h4>";
            resultContainer.innerHTML = result;
          }
          return false;
        });
    }
  }
</script>
</html>
