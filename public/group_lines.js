/*jslint browser: true*/
/*global $, group_keys, group_values*/

$(function () {
    "use strict";
    $('#relative-group').highcharts({
        chart: {
            type: 'line'
        },
        title: {
            text: 'Relative Poverty - Trends over time'
        },
        subtitle: {
            text: 'Source: NBS Report'
        },
        xAxis: {
            categories: group_keys
        },
        yAxis: {
            title: {
                text: 'Percent of population (%)'
            }
        },
        plotOptions: {
            line: {
                dataLabels: {
                    enabled: true
                },
                enableMouseTracking: true
            }
        },
        series: group_values
    });
});
