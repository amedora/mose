/* vim:set ts=4 sw=4: */
var tableData;
var opt_graph;

function render(graph_type, car) {
    $.ajax({
        url : '/render/graph/' + graph_type + '/' + car + '?' + $('#form_fileselect').serialize(),
		success : function (json) {
            opt_graph[graph_type].series = json.series;
			this["graph_" + graph_type] = new Highcharts.Chart(opt_graph[graph_type]); 
        }
    });
}

function get_data() {
    tableData.fnDestroy();
    $.ajax({
		type : 'GET',
        url : '/analysis/datatable?' + $('#form_fileselect').serialize(),
		success : function (html) {
            $('#tabledata').replaceWith(html);
			tableData = $('#tabledata').dataTable({
				"iDisplayLength" : 150,
				"aaSorting" : [],
				"sDom": "<'row'<'col-md-4'l><'col-md-4'T><'col-md-4'f>r><'row'<'col-md-12't>><'row'<'col-md-5'i><'col-md-7'p>>",
				"oTableTools": {
					"sSwfPath": '/swf/copy_csv_xls_pdf.swf',
					"aButtons": ['copy', 'csv', 'pdf', 'print']
				},
				/*
                "sDom" : "<'row'<'col-md-6'l><'col-md-6'f>r>t<'row'<'col-md-6'i><'col-md-6'p>>",
				*/
				"sPaginationType" : "bootstrap", "oLanguage" : {
                    "sLengthMenu" : "_MENU_ components per page"
                }
            }); 
        }
    });
}

