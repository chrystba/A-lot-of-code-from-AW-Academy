sap.ui.define(["sap/ui/core/mvc/Controller","sap/ui/core/format/NumberFormat"],function(e,r){"use strict";return e.extend("costcalculator.controller.CostCalculator",{onInit:function(){},onUpdateSchaetzung:function(){const e=this.byId("slider1").getValue(+
);const t=this.byId("comboBox1").getSelectedKey();const o={1:1e3,2:1800,3:2700,4:3600,5:4400};const s=o[e.toString()];this.byId("stromverbrauch").setText(s);const i={basispreisProJahr:0,arbeitspreisProKwH:0};if(t==="swm_mflex"){i.basispreisProJahr=154.11+
;i.arbeitspreisProKwH=.5522}else if(klickenergie_KlickStrom==="klickenergie_KlickStrom"){i.basispreisProJahr=120.11;i.arbeitspreisProKwH=.33}var n=r.getCurrencyInstance();const a=n.format(i.basispreisProJahr+i.arbeitspreisProKwH*s);this.byId("preis").set+
Text(a+" €")},onTariffWaehlen:function(){window.location.href="http://www.google.de"}})});                                                                                                                                                                     