(function () {

	var drawPieChart = function(origdata, valuekey, svgid, title)
{
    var fdata = origdata.filter(function(d) { return d[valuekey] > 0;} );
    if(fdata.length == 0) return;
    $(svgid).attr("class", "matchpiechart");

    var data = [];
        for(var i in fdata)
{
    data.push([fdata[i].player, fdata[i][valuekey]]);
}

    $(svgid).highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
        },
        navigation: {
            buttonOptions: {
                enabled: false,
            },
        },
        title: {
            text: title
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
            name: title,
            data: data
        }]
    });
}

	var ready = function(){
		drawPieChart(gon.damagechartdata["radiant"], "herodamage", "#radiantdamagechart", "Radiant Hero Damage");
		drawPieChart(gon.damagechartdata["radiant"], "towerdamage", "#radianttowerdamagechart", "Radiant Tower Damage");
		drawPieChart(gon.damagechartdata["radiant"], "gold", "#radiantgoldchart", "Radiant Gold");

		drawPieChart(gon.damagechartdata["dire"], "herodamage", "#diredamagechart", "Dire Hero Damage");
		drawPieChart(gon.damagechartdata["dire"], "towerdamage", "#diretowerdamagechart", "Dire Tower Damage");
		drawPieChart(gon.damagechartdata["dire"], "gold", "#diregoldchart", "Dire Gold");
	}

$(document).ready(ready);
}).call(this)
