(function () {

	var namespace = "com.sap.trackandtrace.webapp";

	sap.ui.controller(namespace + ".ext.controller.ListReportExtension", {
		onAfterRendering: function () {
			this.loadListReportData();
		},

		loadListReportData: function () {
			// automatically fire search
			var oListReportFilter = this.getView().byId("listReportFilter");
			if (oListReportFilter) {
				oListReportFilter.fireSearch();
			}
		}
	});
}());