sap.ui.define("com.sap.trackandtrace.webapp.localService.mockserver", [
	"sap/ui/core/util/MockServer"
], function (MockServer) {

	var oMockServer = null;
	var annotationsMockServers = null;
	var _sAppModulePath = "com/sap/trackandtrace/webapp/";
	var _sJsonFilesModulePath = _sAppModulePath + "localService/mockdata";

	return {

		/**
		 * Initializes the mock server.
		 * You can configure the delay with the URL parameter "serverDelay".
		 * The local mock data in this folder is returned instead of the real data for testing.
		 * @public
		 * @returns {void} Has no return.
		 */
		init: function () {
			annotationsMockServers = [];

			var oUriParameters = jQuery.sap.getUriParameters();
			var sJsonFilesUrl = jQuery.sap.getModulePath(_sJsonFilesModulePath);
			var sManifestUrl = jQuery.sap.getModulePath(_sAppModulePath + "manifest", ".json");
			var sErrorParam = oUriParameters.get("errorType");
			var iErrorCode = sErrorParam === "badRequest" ? 400 : 500;
			var oManifest = jQuery.sap.syncGetJSON(sManifestUrl).data;
			var oDataSource = oManifest["sap.app"].dataSources;

			// "DeliverieProcessUIs"
			var listReportPage = oManifest["sap.ui.generic.app"].pages[0];
			var sEntity = listReportPage.entitySet;
			var oMainDataSource = oDataSource.mainService;
			var sMetadataUrl = jQuery.sap.getModulePath(_sAppModulePath + oMainDataSource.settings.localUri.replace(".xml", ""), ".xml");

			// ensure there is a trailing slash
			var sMockServerUrl = /.*\/$/.test(oMainDataSource.uri) ? oMainDataSource.uri : oMainDataSource.uri + "/";
			var aAnnotations = oMainDataSource.settings.annotations;

			oMockServer = new MockServer({
				rootUri: sMockServerUrl
			});

			this._overrideResolveNavigation(oMockServer);

			// configure mock server with a delay of 1s
			MockServer.config({
				autoRespond: true,
				autoRespondAfter: oUriParameters.get("serverDelay") || 1000
			});

			// load local mock data
			oMockServer.simulate(sMetadataUrl, {
				sMockdataBaseUrl: sJsonFilesUrl,
				bGenerateMissingMockData: true
			});

			var aRequests = oMockServer.getRequests(),
				fnResponse = function (iErrCode, sMessage, aRequest) {
					aRequest.response = function (oXhr) {
						oXhr.respond(iErrCode, {
							"Content-Type": "text/plain;charset=utf-8"
						}, sMessage);
					};
				};

			// handling the metadata error test
			if (oUriParameters.get("metadataError")) {
				aRequests.forEach(function (aEntry) {
					if (aEntry.path.toString().indexOf("$metadata") > -1) {
						fnResponse(500, "metadata Error", aEntry);
					}
				});
			}

			// Handling request errors
			if (sErrorParam) {
				aRequests.forEach(function (aEntry) {
					if (aEntry.path.toString().indexOf(sEntity) > -1) {
						fnResponse(iErrorCode, sErrorParam, aEntry);
					}
				});
			}
			oMockServer.start();

			jQuery.sap.log.info("Running the app with mock data");

			aAnnotations.forEach(function (sAnnotationName) {
				var oAnnotation = oDataSource[sAnnotationName];
				var sUri = oAnnotation.uri;
				var sLocalUri = jQuery.sap.getModulePath(_sAppModulePath + oAnnotation.settings.localUri.replace(".xml", ""), ".xml");

				// annotiaons
				var ms = new MockServer({
					rootUri: sUri,
					requests: [{
						method: "GET",
						path: new RegExp(""),
						response: function (oXhr) {
							jQuery.sap.require("jquery.sap.xml");

							var oAnnotations = jQuery.sap.sjax({
								url: sLocalUri,
								dataType: "xml"
							}).data;

							oXhr.respondXML(200, {}, jQuery.sap.serializeXML(oAnnotations));
							return true;
						}
					}]
				});
				ms.start();

				annotationsMockServers.push(ms);
			});
		},

		/**
		 * @private override the internal method to make sure there is at least one entry is returned.
		 * @param {Object} mockserver - Sap.Ui.Core.Util.MockServer.
		 * @returns {void} Has no return.
		 */
		_overrideResolveNavigation: function (mockserver) {
			// Author: GTT-WebIde-Plugin team
			if (MockServer.prototype._resolveNavigation) {

				mockserver._resolveNavigation = function (sEntitySetName, oFromRecord, sNavProp) {
					try {
						var oEntitySet = this._mEntitySets[sEntitySetName];
						var oNavProp = oEntitySet.navprops[sNavProp];
						if (!oNavProp) {
							this._logAndThrowMockServerCustomError(404, this._oErrorMessages.RESOURCE_NOT_FOUND);
						}

						var aEntries = [];
						var iPropRefLength = oNavProp.from.propRef.length;
						// if there is no ref.constraint, the data is return according to the multiplicity
						if (iPropRefLength === 0) {
							if (oNavProp.to.multiplicity === "*") {
								return this._oMockdata[oNavProp.to.entitySet];
							} else {
								aEntries.push(this._oMockdata[oNavProp.to.entitySet][0]);
								return aEntries;
							}
						}
						// maybe we can do symbolic links with a function to handle the navigation properties
						// instead of copying the data into the nested structures
						jQuery.each(this._oMockdata[oNavProp.to.entitySet], function (iIndex, oToRecord) {

							// check for property ref being identical
							var bEquals = true;
							for (var i = 0; i < iPropRefLength; i++) {
								if (oFromRecord[oNavProp.from.propRef[i]] !== oToRecord[oNavProp.to.propRef[i]]) {
									bEquals = false;
									break;
								}
							}
							// if identical we add the to record
							if (bEquals) {
								aEntries.push(oToRecord);
							}
						});

						// If no items are matched, choose the first one.
						// Author: GTT-WebIde-Plugin team
						if (aEntries.length === 0) {
							aEntries.push(this._oMockdata[oNavProp.to.entitySet][0]);
						}

						return aEntries;
					} catch (error) {
						return MockServer.prototype._resolveNavigation.apply(mockserver, arguments);
					}
				};
			}
		},

		/**
		 * @public returns the mockserver of the app, should be used in integration tests
		 * @returns {sap.ui.core.util.MockServer} Return the mock server.
		 */
		getMockServer: function () {
			return oMockServer;
		},

		/**
		 * @public returns the mockserver for annotations of the app, should be used in integration tests
		 * @returns {Array} Return the mock servers for annotations.
		 */
		getAnnotationsMockServers: function () {
			return annotationsMockServers;
		}
	};
}, true);