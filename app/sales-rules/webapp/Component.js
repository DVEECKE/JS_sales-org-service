/**
 * Fiori Elements Component for Sales Rules App
 *
 * BEGINNER NOTE:
 * - This is a minimal component definition required by UI5
 * - sap.fe.core.AppComponent is the base class for Fiori Elements apps
 * - All configuration is in manifest.json
 * - No custom code needed for standard CRUD functionality
 */
sap.ui.define(
  ["sap/fe/core/AppComponent"],
  function (AppComponent) {
    "use strict";

    return AppComponent.extend("sales-org-service.sales-rules.Component", {
      metadata: {
        manifest: "json"
      }
    });
  }
);
