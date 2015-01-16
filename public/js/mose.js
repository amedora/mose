/* vim:set ts=4 sw=4: */
var mose = mose || {};
(function(app) {
    var setupSheet;
    var opt_graph;

    app.initSetupSheet = function(selector) {
        setupSheet = $(selector).DataTable({
            "columns": [{
                "title": "Category"
            },
            {
                "title": "Section"
            },
            {
                "title": "Component"
            }]
        });
    };

    app.show = function(formData, viewModel) {
        $.ajax({
            type: 'POST',
            contentType: false,
            processData: false,
            data: formData,
            dataType: 'json',
            cache: false,
            async: false,
            url: '/analyze',
            success: function(json) {
                if ('error' in json) {
                    viewModel.message(json.error.message);
                    alert(json.error.message);
                }
                updateSetupSheet(json);
            }
        });

        /*
        $('#analysis-tab a[href="#tab-analysis"]').tab('show');
		*/
    };

    app.viewModel = function() {
        var self = this;

        self.message = ko.observable('');

        self.file = ko.observableArray([{
            name: ''
        },
        {
            name: ''
        }]);

        self.addFile = function() {
            self.file.push({
                name: "New at " + new Date()
            });
        };

        self.removeFile = function() {
            self.file.remove(this);
        }
    }

    function updateSetupSheet(json) {
        var id = $(setupSheet.table().node()).attr('id');
        setupSheet.destroy();
        $('#' + id).empty();

        /* The first row in json.data is a column header */
        var columnHeader = json.data.shift().map(function(column_name) {
            return {
                "title": column_name.replace('<', '&lt').replace('>', '&gt')
            };
        });
        setupSheet = $('#' + id).DataTable({
            "processing": true,
            "paging": false,
            "columns": columnHeader,
            "data": json.data,
			"createdRow": function(row, data, dataIndex) {
				var isSame = data.slice(3).every(function(elem) {
					return (elem === data[3]);
				});
				if (!isSame) {
					$(row).css("color", "#B94A48");
				}
			}
        });
    }

    function render(graph_type, car) {
        $.ajax({
            url: '/render/graph/' + graph_type + '/' + car + '?' + $('#form_fileselect').serialize(),
            success: function(json) {
                opt_graph[graph_type].series = json.series;
                this["graph_" + graph_type] = new Highcharts.Chart(opt_graph[graph_type]);
            }
        });
    }

    function get_data() {
        tableData.fnDestroy();
        $.ajax({
            type: 'GET',
            url: '/analysis/datatable?' + $('#form_fileselect').serialize(),
            success: function(html) {
                $('#tabledata').replaceWith(html);
                tableData = $('#tabledata').dataTable({
                    "iDisplayLength": 150,
                    "aaSorting": [],
                    "sDom": "<'row'<'col-md-4'l><'col-md-4'T><'col-md-4'f>r><'row'<'col-md-12't>><'row'<'col-md-5'i><'col-md-7'p>>",
                    "oTableTools": {
                        "sSwfPath": '/swf/copy_csv_xls_pdf.swf',
                        "aButtons": ['copy', 'csv', 'pdf', 'print']
                    },
                    /*
                "sDom" : "<'row'<'col-md-6'l><'col-md-6'f>r>t<'row'<'col-md-6'i><'col-md-6'p>>",
				*/
                    "sPaginationType": "bootstrap",
                    "oLanguage": {
                        "sLengthMenu": "_MENU_ components per page"
                    }
                });
            }
        });
    }

})(mose);
