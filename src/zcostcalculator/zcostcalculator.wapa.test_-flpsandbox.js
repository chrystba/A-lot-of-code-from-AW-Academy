sap.ui.define(["sap/base/util/ObjectPath","sap/ushell/services/Container"],function(e){"use strict";e.set(["sap-ushell-config"],{defaultRenderer:"fiori2",bootstrapPlugins:{RuntimeAuthoringPlugin:{component:"sap.ushell.plugins.rta",config:{validateAppVers+
ion:false}},PersonalizePlugin:{component:"sap.ushell.plugins.rta-personalize",config:{validateAppVersion:false}}},renderers:{fiori2:{componentData:{config:{enableSearch:false,rootIntent:"Shell-home"}}}},services:{LaunchPage:{adapter:{config:{groups:[{til+
es:[{tileType:"sap.ushell.ui.tile.StaticTile",properties:{title:"Energiekostenschätzung für SWM",targetURL:"#costcalculator-display"}}]}]}}},ClientSideTargetResolution:{adapter:{config:{inbounds:{"costcalculator-display":{semanticObject:"costcalculator",+
action:"display",title:"Energiekostenschätzung für SWM",signature:{parameters:{}},resolutionResult:{applicationType:"SAPUI5",additionalInformation:"SAPUI5.Component=costcalculator",url:sap.ui.require.toUrl("costcalculator")}}}}}},NavTargetResolution:{con+
fig:{enableClientSideTargetResolution:true}}}});var t={init:function(){if(!this._oBootstrapFinished){this._oBootstrapFinished=sap.ushell.bootstrap("local");this._oBootstrapFinished.then(function(){sap.ushell.Container.createRenderer().placeAt("content")}+
)}return this._oBootstrapFinished}};return t});                                                                                                                                                                                                                