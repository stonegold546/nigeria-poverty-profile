/*jslint browser: true*/
/*global $, group_keys, group_values*/

$(function () {
    "use strict";
    $('#relative-group').highcharts({
        chart: {
            type: 'area'
        },
        title: {
            text: 'Relative Poverty - Trends over time'
        },
        subtitle: {
            text: 'Source: NBS Report'
        },
        xAxis: {
            categories: group_keys,
            tickmarkPlacement: 'on',
            title: {
                enabled: false
            }
        },
        yAxis: {
            title: {
                text: 'Percent of population (%)'
            }
        },
        tooltip: {
            pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.percentage:.1f}%</b> ({point.y:,.1f} million)<br/>',
            shared: true
        },
        plotOptions: {
            area: {
                stacking: 'percent',
                enableMouseTracking: true
            }
        },
        colors: ['#90ed7d', '#f8a13f', '#ba3c3d'],
        series: group_values
    });
});
