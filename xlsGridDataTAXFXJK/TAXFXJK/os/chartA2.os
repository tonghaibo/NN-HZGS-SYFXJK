function TAXFXJK_chartA2(){
//初始化中间件类
function _init(request) 
{
	var mwobj = new TAXFXJK_chartA2();
	return mwobj;
}

//输出分析图的方法
function getCharts()
{       
        var hello11 = "hello";       
	var chr = "<script>
		    $(function () {
		    
		    $('body').append(\"<div id='div2' style='min-width:800px;height:400px;margin-top:50px;'>\\
		                         <table border='1' cellspacing='0' style='font-size:14px;' align='center'>\\
		                              <caption align='top'>经济支出按来源和活动类型分</caption>\\
       <tr>\\
          <th width='30%'>指标</th>\\
		  <th>2001</th>\\
		  <th>2005</th>\\
		  <th>2006</th>\\
		  <th>2007</th>\\
		  <th>2008</th>\\
		  <th>2009</th>\\
		  <th>2010</th>\\
		  <th>2011</th>\\
		  <th>2012</th>\\
       </tr>\\
       <tr>\\
	      <td>RAD经费支出（亿元）</td>\\
		  <td>51.69</td>\\
		  <td>92.15</td>\\
		  <td>101.36</td>\\
		  <td>121.80</td>\\
		  <td>145.18</td>\\
		  <td>189.51</td>\\
		  <td>217.50</td>\\
		  <td>249.35</td>\\
		  <td>287.20</td>\\
       </tr>\\
       <tr>\\
	      <td>企业资金</td>\\
		  <td>12.48</td>\\
		  <td>23.27</td>\\
		  <td>33.83</td>\\
		  <td>34.07</td>\\
		  <td>44.09</td>\\
		  <td>66.77</td>\\
		  <td>76.73</td>\\
		  <td>97.77</td>\\
		  <td>114.52</td>\\
       </tr>\\
<tr>\\
	      <td>政府资金</td>\\
		  <td>34.52</td>\\
		  <td>56.51</td>\\
		  <td>57.89</td>\\
		  <td>80.23</td>\\
		  <td>94.10</td>\\
		  <td>115.23</td>\\
		  <td>131.00</td>\\
		  <td>141.44</td>\\
		  <td>161.83</td>\\
       </tr>\\
<tr>\\
	      <td>其他</td>\\
		  <td>4.69</td>\\
		  <td>12.36</td>\\
		  <td>10.87</td>\\
		  <td>5.66</td>\\
		  <td>8.20</td>\\
		  <td>11.11</td>\\
		  <td>12.22</td>\\
		  <td>8.99</td>\\
		  <td>13.14</td>\\
       </tr>\\
		                         </table>\\
                                        </div>\");
		    
		    
		    $('#container').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
        },
        title: {
            text: '经济支出按资金来源分布2012'
        },
        tooltip: {
    	    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    color: '#000000',
                    connectorColor: '#000000',
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %'
                }
            }
        },
        series: [{
            type: 'pie',
            name: '按资金来源分布',
            data: [
                ['企业税金',   39.87],
                ['其他',       3.78],               
                ['政府税金',    56.35]
            ]
        }],
        exporting:{
           enabled:false
        }
    });	
		                       
		                       
		                       
		});
		</script>";
	return chr;
}

}